# TaskFlow Notification System — Design

## North Star

Build the simplest notification system that reliably delivers through multiple channels, handles failures gracefully, and doesn't become a bottleneck for the rest of the application.

## Context

TaskFlow needs to notify users when things happen to their tasks — assignments, status changes, comments. Notifications go through multiple channels (in-app, email, webhook) based on user preferences and project configuration.

**Flows this enables:**
- Task assignment notification flow
- Status change notification flow
- Comment notification flow
- Webhook integration flow

## Constraints

- Users choose their notification preferences per channel
- Email should be batched (digest) to avoid inbox flooding
- Webhook delivery must not block other notifications
- Real-time (WebSocket) is separate — this design covers persistent notifications and async delivery
- Must handle notification spikes (e.g., bulk task import assigns 50 tasks at once)

---

## Components

```
┌─────────────────────────────────────────────────────────────┐
│                      Task API                                │
│  Creates notification events on task mutations               │
└─────────────────────────────────────────────────────────────┘
                              │
                         Redis pub/sub
                              │
         ┌────────────────────┼────────────────────┐
         ▼                    ▼                    ▼
┌─────────────┐      ┌─────────────┐      ┌─────────────┐
│  WebSocket  │      │  Dispatcher │      │  (future)   │
│  Server     │      │             │      │             │
│ - Real-time │      │ - Consume   │      │ - Mobile    │
│ - Ephemeral │      │ - Route     │      │ - Push      │
└─────────────┘      │ - Deliver   │      └─────────────┘
                     └─────────────┘
                              │
              ┌───────────────┼───────────────┐
              ▼               ▼               ▼
       ┌───────────┐   ┌───────────┐   ┌───────────┐
       │ In-App    │   │ Email     │   │ Webhook   │
       │ Channel   │   │ Channel   │   │ Channel   │
       │           │   │           │   │           │
       │ - Store   │   │ - Batch   │   │ - POST    │
       │ - Mark    │   │ - Digest  │   │ - Retry   │
       │   read    │   │ - Send    │   │ - DLQ     │
       └───────────┘   └───────────┘   └───────────┘
```

---

## Contracts

### DeliveryChannel

```typescript
interface DeliveryChannel {
  type: string;
  canDeliver(notification: Notification, preferences: UserPreferences): boolean;
  deliver(notification: Notification): Promise<DeliveryResult>;
}

interface DeliveryResult {
  success: boolean;
  channel: string;
  error?: string;
  retryable?: boolean;
}
```

**Implementations:**
- `InAppChannel` — Writes to `notifications` table, queryable via API
- `EmailChannel` — Batches into digest, sends via email provider
- `WebhookChannel` — POSTs to project-configured URL with retry

### NotificationDispatcher

```typescript
interface NotificationDispatcher {
  dispatch(event: NotificationEvent): Promise<void>;
}

interface NotificationEvent {
  type: string;           // "task.assigned", "task.status_changed", etc.
  actorId: string;        // Who caused the event
  recipientIds: string[]; // Who should be notified
  data: Record<string, unknown>;
}
```

**Implementation:** `MultiChannelDispatcher`
- Resolves user preferences for each recipient
- Fans out to applicable channels
- Records delivery attempts
- Never throws — logs failures and continues

### DigestBatcher

```typescript
interface DigestBatcher {
  add(notification: Notification): void;
  flush(userId: string): Promise<Notification[]>;
}

interface DigestConfig {
  windowMs: number;    // How long to batch (default: 5 minutes)
  maxBatchSize: number; // Force flush at this size (default: 50)
}
```

**Implementation:** `TimedDigestBatcher`
- Groups notifications by user
- Flushes on window expiry or max size
- Single notification still sends (no artificial delay for lone items)

---

## Data Flow

### Notification Dispatch

```
Task mutation (assign, status change, comment)
    │
    ▼
API publishes NotificationEvent to Redis
    │
    ▼
Dispatcher consumes event
    │
    ├─► For each recipient:
    │       preferences = loadPreferences(recipientId)
    │       channels = resolveChannels(event, preferences)
    │
    │       for each channel:
    │           result = channel.deliver(notification)
    │           record(deliveryAttempt)
    │
    │           if !result.success && result.retryable:
    │               scheduleRetry(channel, notification)
    │
    ▼
Log summary: "Dispatched task.assigned to 3 recipients (3 in-app, 2 email, 1 webhook)"
```

### Email Digest Flow

```
EmailChannel.deliver(notification)
    │
    ▼
DigestBatcher.add(notification)
    │
    ├─► Window still open → queued
    │
    └─► Window expired or batch full:
            batch = batcher.flush(userId)
            html = renderDigestEmail(batch)
            emailProvider.send(userId.email, html)
```

---

## Database Schema

```sql
CREATE TABLE notifications (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    recipient_id UUID NOT NULL REFERENCES users(id),
    event_type TEXT NOT NULL,
    actor_id UUID NOT NULL REFERENCES users(id),
    data JSONB NOT NULL,
    read_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_notifications_recipient ON notifications(recipient_id, created_at DESC);
CREATE INDEX idx_notifications_unread ON notifications(recipient_id) WHERE read_at IS NULL;

CREATE TABLE notification_deliveries (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    notification_id UUID NOT NULL REFERENCES notifications(id),
    channel TEXT NOT NULL,           -- 'in_app', 'email', 'webhook'
    status TEXT NOT NULL DEFAULT 'pending',  -- 'pending', 'sent', 'failed', 'dead_letter'
    attempts INTEGER NOT NULL DEFAULT 0,
    last_error TEXT,
    next_retry_at TIMESTAMPTZ,
    delivered_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_deliveries_retry ON notification_deliveries(next_retry_at)
    WHERE status = 'failed';

CREATE TABLE user_notification_preferences (
    user_id UUID NOT NULL REFERENCES users(id),
    channel TEXT NOT NULL,
    enabled BOOLEAN NOT NULL DEFAULT true,
    config JSONB,                    -- Channel-specific settings
    PRIMARY KEY (user_id, channel)
);
```

---

## Error Handling

| Scenario | Behavior |
|----------|----------|
| Redis unavailable | Notifications degrade — task writes still succeed, notifications queued in-memory with short TTL |
| Email provider down | Mark `failed`, retry next digest cycle |
| Webhook endpoint 5xx | Retry 3x with exponential backoff (1s, 5s, 25s) |
| Webhook endpoint 4xx | Log failure, no retry (client misconfiguration) |
| Recipient has no preferences | Use defaults: in-app enabled, email disabled, webhook n/a |
| Bulk event (50 recipients) | Process in batches of 10 to avoid Redis/DB contention |
| Notification for deleted task | Skip delivery, log info |

---

## Trade-offs

| Chose | Over | Because |
|-------|------|---------|
| Redis pub/sub | Dedicated message queue (RabbitMQ, SQS) | Already in stack for caching; sufficient at this scale |
| Email digest batching | Immediate per-event emails | Users hate notification floods; digest is better UX |
| At-least-once delivery | Exactly-once | Simpler; duplicate notification is better than missed one |
| PostgreSQL for notification storage | Redis-only | Notifications need to persist, be queryable, support read/unread |
| Channel interface | Hardcoded channels | New channels (mobile push, Slack) without core changes |
| Fire-and-forget from API | Synchronous delivery | Task writes must not be slowed by notification delivery |

## Alternatives Considered

**Dedicated message queue (RabbitMQ, SQS):** Better delivery guarantees but adds operational complexity. Redis pub/sub is sufficient at current scale. Clear upgrade path if needed.

**Per-event emails:** Simpler implementation but terrible UX. A bulk import would send 50 individual emails.

**Notification microservice:** Separate deployment for notifications. Overkill — the dispatcher is a background worker in the same codebase. Extract later if it outgrows this.

## Risks

| Risk | Mitigation |
|------|------------|
| Redis pub/sub loses messages | At-least-once via delivery tracking; retry from `failed` status |
| Email digest timing confuses users | Configurable window; default 5 min is short enough to feel responsive |
| Webhook abuse (slow endpoints) | 10s timeout per call; circuit breaker after 5 consecutive failures |
| Notification table grows unbounded | Retention policy: archive after 90 days, delete after 1 year |

## Extension Points

- `DeliveryChannel` — Add channels (mobile push, Slack, Teams) without core changes
- Digest templates configurable per project
- Webhook payload format versioned (`v1` in URL path)
- Priority levels (urgent bypasses digest, sends immediately)
