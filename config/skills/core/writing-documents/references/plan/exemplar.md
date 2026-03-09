# Plan: Notification Dispatcher Component

Implements: [TaskFlow Notification Design](../design/exemplar.md) — NotifyWorker, DeliveryChannels, DigestBatcher

## Scope

**Covers:**
- `NotificationDispatcher` service and queue consumer implementation
- `DeliveryChannel` interface with in-app, email digest, and webhook implementations
- `DigestBatcher` with configurable time windows
- Notification persistence in `notifications` and `notification_deliveries` tables

**Does not cover:**
- WebSocket real-time delivery (Plan: WebSocket Server)
- User notification preferences UI (Plan: Settings Page)
- Webhook management API (Plan: Webhook Configuration)

## Enables

Once NotificationDispatcher exists:
- **Multi-channel delivery** — notifications reach users through their preferred channels
- **Reliable delivery** — failed deliveries are tracked and retried
- **Plan: WebSocket Server** can proceed — publishes to same Redis channel
- **Plan: Settings Page** can proceed — reads/writes user preferences that the dispatcher respects

This is the notification backbone. WebSocket adds real-time on top; this handles everything else.

## Prerequisites

- PostgreSQL tables: `notifications`, `notification_deliveries`, `user_preferences`
- Redis configured for pub/sub and queue operations
- Email provider API credentials (e.g., SendGrid, Postmark, SES)

## North Star

Every notification reaches the right person through the right channel within the expected timeframe. No silent failures — if delivery fails, it's tracked, retried, and eventually surfaced.

## Done Criteria

### NotificationDispatcher
- The dispatcher shall consume notification events from the Redis queue
  - When queue is empty, block-wait (no polling)
  - When event schema is invalid, log warning and skip
- The dispatcher shall resolve delivery channels from user preferences
  - When user has no preferences, use defaults (in-app only)
  - When user has opted out of a channel, skip it
- The dispatcher shall record delivery attempts in `notification_deliveries`

### DeliveryChannels
- The channel registry shall resolve channels by type
- Each channel shall implement `DeliveryChannel` with `canDeliver` and `deliver`
- The EmailChannel shall batch notifications into digest windows
  - When digest window closes, send single email with all pending items
  - If email send fails, mark `delivery_status = 'failed'` with error details
- The WebhookChannel shall POST event payload to configured URL
  - If endpoint returns 5xx, retry 3x with exponential backoff
  - If endpoint returns 4xx, log failure, no retry (client error)

### DigestBatcher
- The batcher shall group notifications by user and channel within a time window
- The batcher shall flush when the window expires or batch reaches max size
  - When only one notification in batch, still send (don't wait for more)
- The batcher shall be configurable per-channel (email: 5 min, others: immediate)

## Constraints

- **At-least-once delivery** — duplicates are acceptable; missed notifications are not. Consumers must be idempotent.
- **Email rate limits** — provider limits per-second sends; batcher naturally smooths this via digest windows
- **Webhook timeout** — 10 second timeout per webhook call; slow endpoints don't block the queue

## References

- [TaskFlow Notification Design](../design/exemplar.md) — component contracts, delivery flow, error handling
- Email provider documentation — rate limits, batch API, error codes
- Redis streams documentation — consumer groups, acknowledgment, dead letter

## Error Policy

Errors should not halt the dispatcher. When a delivery fails:
1. Log warning with channel, recipient, and error details
2. Mark delivery as `failed` in `notification_deliveries`
3. Schedule retry based on channel policy (email: next digest, webhook: exponential backoff)
4. Continue processing remaining notifications
5. After max retries exhausted, mark as `dead_letter` for manual review

This aligns with north star — a failed webhook shouldn't prevent email delivery to the same user.
