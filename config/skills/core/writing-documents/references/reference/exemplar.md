# Service Catalog Reference — Hybrid Pattern

This exemplar demonstrates the hybrid approach: CSVs for queryable facts and relationships, markdown for guidance.

## File Structure

```
infrastructure/
├── services.csv                  # Service facts, descriptions, notes
├── service-calls.csv             # Direct call relationships
├── service-events-publish.csv    # Event publishing
├── service-events-consume.csv    # Event consumption
└── service-catalog.md            # Guidance on using the data
```

---

## services.csv

```csv
service,environment,url,repository,technology,purpose,database,logs_enabled,deployments_tracked,chronic_errors,notes
TaskAPI,production,https://api.taskflow.example.com,taskflow-api,Node.js,Core API for tasks and projects,PostgreSQL,true,true,,"Main entry point. All writes go through here."
AuthService,production,https://auth.taskflow.example.com,taskflow-auth,Node.js,Authentication and session management,PostgreSQL + Redis,true,true,,"Session tokens in Redis. User records in PostgreSQL."
NotifyWorker,production,n/a (internal),taskflow-notify,Node.js,Email digests and webhook dispatch,Redis (queue),true,false,Occasional email timeout,"Runs as background worker. No HTTP endpoint."
WebSocketServer,production,wss://ws.taskflow.example.com,taskflow-ws,Node.js,Real-time notifications,Redis (pub/sub),true,false,,"Stateful connections. Scales horizontally via Redis."
FileService,production,https://files.taskflow.example.com,taskflow-files,Node.js,Presigned URL generation for S3 uploads,S3,true,true,,"No file content passes through the service."
```

**Queryable:**
- `WHERE chronic_errors != ''` — services with known issues
- `WHERE logs_enabled = 'false'` — observability gaps
- `WHERE notes LIKE '%source of truth%'` — authoritative data owners

---

## service-calls.csv

```csv
caller,callee,reason,criticality
TaskAPI,AuthService,Session validation,high
TaskAPI,FileService,Presigned URL for attachments,low
TaskAPI,Redis,Publish notification events,medium
WebSocketServer,Redis,Subscribe to notification events,high
WebSocketServer,AuthService,Validate WebSocket connection token,high
NotifyWorker,Redis,Consume notification queue,high
NotifyWorker,EmailProvider,Send digest emails,medium
NotifyWorker,ExternalWebhook,Dispatch webhook events,low
```

**Queryable:**
- `WHERE callee = 'AuthService'` — what depends on auth (blast radius)
- `WHERE caller = 'TaskAPI'` — what the API depends on
- `WHERE criticality = 'high'` — critical path dependencies

---

## service-events-publish.csv

```csv
publisher,event_type,description
TaskAPI,task.created,New task created in a project
TaskAPI,task.assigned,Task assigned to a user
TaskAPI,task.status_changed,Task moved to a new status
TaskAPI,comment.added,Comment added to a task
AuthService,user.logged_in,User started a new session
```

**Queryable:**
- `WHERE publisher = 'TaskAPI'` — events the API emits
- `WHERE event_type LIKE 'task.%'` — task-related events

---

## service-events-consume.csv

```csv
consumer,event_type,action
WebSocketServer,task.assigned,Push real-time notification to assignee
WebSocketServer,task.status_changed,Push update to project viewers
WebSocketServer,comment.added,Push notification to task watchers
NotifyWorker,task.assigned,Queue email notification for digest
NotifyWorker,task.assigned,Dispatch webhook if project has one configured
NotifyWorker,task.status_changed,Queue email notification for digest
```

**Queryable:**
- `WHERE event_type = 'task.assigned'` — what reacts to assignment
- `WHERE consumer = 'NotifyWorker'` — what events the worker handles

---

## service-catalog.md

```markdown
# Service Catalog

Production services, their relationships, and event flows.

## Data Files

| File | Contains | Use For |
|------|----------|---------|
| `services.csv` | Service facts, URLs, notes | Finding a service, checking observability |
| `service-calls.csv` | Direct call relationships | Blast radius, dependency tracing |
| `service-events-publish.csv` | Event publishing | Understanding event sources |
| `service-events-consume.csv` | Event consumption | Understanding event handlers |

## Common Queries

**Find production URL for a service:**
```sql
SELECT url FROM services.csv
WHERE service = 'TaskAPI' AND environment = 'production'
```

**Blast radius — what breaks if AuthService goes down:**
```sql
SELECT caller, reason FROM service-calls.csv
WHERE callee = 'AuthService' AND criticality = 'high'
```

**Event flow — what happens when a task is assigned:**
```sql
-- Who publishes it
SELECT * FROM service-events-publish.csv WHERE event_type = 'task.assigned'

-- Who reacts to it
SELECT consumer, action FROM service-events-consume.csv WHERE event_type = 'task.assigned'
```

**Services with known issues:**
```sql
SELECT service, chronic_errors FROM services.csv WHERE chronic_errors != ''
```

## Blast Radius Summary

Derived from `service-calls.csv WHERE criticality = 'high'`:

| Service Down | Direct Impact |
|--------------|---------------|
| AuthService | TaskAPI, WebSocketServer (all auth fails) |
| Redis | WebSocketServer, NotifyWorker (real-time + notifications) |
| PostgreSQL | TaskAPI, AuthService (all reads and writes) |

## Maintenance

**Adding a service:**
1. Add rows to `services.csv` (one per environment)
2. Add call relationships to `service-calls.csv`
3. Add event relationships if applicable
4. Document any chronic errors in the `chronic_errors` column

**Updating relationships:**
- Direct calls → `service-calls.csv`
- Event publishing → `service-events-publish.csv`
- Event consuming → `service-events-consume.csv`
```

---

## Why This Pattern

**All facts in CSV:**
- Services, URLs, descriptions, notes → queryable
- Direct calls → queryable relationships with criticality
- Events → queryable publish/subscribe flows

**Markdown provides:**
- How to query the data
- Pre-computed summaries (blast radius table)
- Maintenance procedures

**The boundary:** Data goes in CSV. Guidance goes in markdown.
