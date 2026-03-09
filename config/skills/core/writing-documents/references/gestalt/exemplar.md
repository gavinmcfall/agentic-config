# TaskFlow — Gestalt

**What it is**: A team task management web app. Users create projects, assign tasks, track progress, and get notified when things change.

**Why it exists**: Teams need a shared view of who's doing what. Spreadsheets lose structure. Chat loses history. TaskFlow gives tasks a home with accountability and visibility.

**Where it fits**: Standalone web app. PostgreSQL for persistence, Redis for real-time updates, S3 for file attachments. Deployed as containers behind a load balancer.

---

## How It Fits

```
Browser / Mobile App
        ↓ REST + WebSocket
API Gateway (rate limiting, auth)
        ↓
Application Server (Node.js)
        ↓ queries / writes
PostgreSQL          Redis (pub/sub, cache)
        ↓
S3 (attachments)
```

### Capsule: SingleSourceOfTruth

**Invariant**
PostgreSQL is the source of truth for all task state. Redis is a cache and pub/sub layer — losing Redis means degraded real-time updates, not data loss.

**Example**
Task status change: write to PostgreSQL first, then publish to Redis for WebSocket broadcast. If Redis is down, the change persists — clients refresh to see it.
//BOUNDARY: If we needed guaranteed delivery of notifications, we'd need a proper message queue, not Redis pub/sub.

**Depth**
- PostgreSQL: all task, project, user, and comment data
- Redis: WebSocket presence, notification fan-out, query cache
- S3: file attachments, referenced by URL in task records
- No event sourcing — current state model with audit log table

---

## Key Concepts

### The Permission Model

Every project has an owner and members with roles: `admin`, `member`, `viewer`. Permissions cascade — project-level roles grant access to all tasks within.

There is no global admin who can see all projects. The system is multi-tenant by isolation, not by flag.

### Capsule: TaskLifecycle

**Invariant**
Tasks move through a defined lifecycle. Backwards transitions are allowed but logged.

**Example**
`open → in_progress → review → done`. Moving from `done` back to `in_progress` is valid (rework) but creates an audit entry explaining why.
//BOUNDARY: Deleted tasks are soft-deleted (archived). Hard deletion only via data retention policy.

**Depth**
- Status transitions validated server-side — the UI can show any button, but the API rejects invalid moves
- Custom statuses per project (beyond the defaults) stored in `project_settings`
- Audit log captures: who, what, when, previous value, new value

### The Notification Model

Notifications are fire-and-forget. Users are notified of changes to tasks they own, are assigned to, or are watching. Delivery channels: in-app, email (digest), webhook.

Missing a notification is acceptable. Missing a data write is not. This priority shapes the architecture — notifications are eventual, writes are synchronous.

---

## Constraints

- **PostgreSQL row-level locking** — concurrent edits to the same task serialize at the database. No optimistic concurrency in the app layer.
- **WebSocket scaling** — each app server holds its own connections. Redis pub/sub broadcasts across servers. Adding servers adds WebSocket capacity linearly.
- **File size limits** — S3 accepts anything, but the API enforces 25MB per attachment. Clients upload directly to S3 via presigned URL.
- **No offline mode** — the app assumes connectivity. Offline support would require conflict resolution we haven't designed.

---

## What It Does NOT Do

- Gantt charts or timeline views (tasks have due dates, not duration)
- Time tracking (no built-in timers or hour logging)
- Invoicing or billing (it's a task tool, not a business tool)
- Chat or messaging (comments on tasks, not conversations)

---

## Deeper

- Database schema — `docs/schema.md`
- API routes — `src/routes/` (one file per resource)
- Auth setup — `src/lib/auth.ts` (session-based with JWT refresh)
- WebSocket protocol — `docs/websocket.md`
- Deployment — `docs/deployment.md` (Docker Compose for dev, k8s for production)
