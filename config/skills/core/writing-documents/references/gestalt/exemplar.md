# SC Bridge — Gestalt

**What it is**: A Star Citizen companion web app that tracks ships, fleet composition, insurance, loot data, and trade commodities.

**Why it exists**: The game has no built-in fleet management. Players with 50+ ships need to see what they own, find coverage gaps, and make informed purchasing decisions.

**Where it fits**: Standalone web app. Pulls game data from RSI's public API and community data sources. Users import their hangar via browser extension.

---

## How It Fits

```
RSI Public API / DataCore
        ↓ game data sync
SC Bridge Backend (Cloudflare Worker + D1)
        ↓ JSON API
React SPA Frontend
        ↓ renders
Player's browser
```

### Capsule: SingleDeploymentUnit

**Invariant**
Backend and frontend deploy as one unit — a Cloudflare Worker serving the API and static assets from the same domain.

**Example**
Push to `main` → GitHub Actions → `wrangler deploy` → live in ~30 seconds. No separate frontend deployment, no CDN invalidation, no orchestration.
//BOUNDARY: This simplicity breaks if the app needs WebSocket connections or long-running processes.

**Depth**
- D1 (SQLite) for persistence — 72 migrations, single database
- R2 for image storage (ship renders, paint variants)
- KV for caching (game version data)
- No external databases, no Redis, no queues

---

## Key Concepts

### The Import Model

Users don't manually add ships. They install HangarXplor (browser extension), which extracts hangar data from RSI's website, then paste the JSON into SC Bridge.

Import is **clean-slate**: every import deletes all existing fleet entries and re-creates from the import data. This is intentional — the browser extension is the source of truth, not SC Bridge.

### Capsule: UserIsolation

**Invariant**
Every data query is scoped to the authenticated user. There is no admin override for viewing another user's fleet.

**Example**
`GET /api/vehicles` always filters by `user_id` from the session. Even if you know another user's fleet entry ID, the query won't return it.
//BOUNDARY: Public fleet sharing (org visibility) is opt-in per user, not a default.

**Depth**
- Better Auth handles sessions (JWT + cookie)
- Every route that touches user data extracts `userId` from the session
- RBAC: `user`, `super_admin`, plus status flags (`banned`, `deleted`)
- Fleet visibility: `private | public | org | officers`

### The Game Data Layer

Game reference data (ships, components, trade commodities, shops, loot items) is separate from user data. It syncs from external sources and is shared across all users.

User data (fleet entries, collections, wishlists, settings) references game data via foreign keys but never modifies it.

---

## Constraints

- **D1 is SQLite** — no concurrent writes, no stored procedures, limited to 10MB per query result. Design queries to be simple.
- **Worker CPU limits** — 30 seconds wall time per request. Sync operations must be chunked.
- **Clean-slate import** — cannot merge imports. If the extension misses a ship, SC Bridge loses it too.
- **No real-time** — no WebSockets. Polling or manual refresh only.
- **Auth via Better Auth** — session management is a dependency. Breaking changes in Better Auth require careful migration.

---

## What It Does NOT Do

- Track in-game currency or aUEC balances (volatile, no API)
- Provide real-time game state (no live connection to game servers)
- Store RSI credentials (auth is via Discord/GitHub OAuth, not RSI login)
- Manage org membership (reads org data, doesn't write it)

---

## Deeper

- Database conventions — `src/db/CONVENTIONS.md`
- Route structure — `src/routes/` (one file per domain)
- Auth setup — `src/lib/auth.ts` (Better Auth factory with Kysely D1)
- Test infrastructure — `.claude/test-infrastructure-summary.md`

---

## Why This Works as Gestalt

**Essential essence in first paragraph**: Companion app, fleet tracking, game data.

**Key concepts unlock understanding**:
- Import model (clean-slate, extension is source of truth)
- User isolation (every query scoped, no admin override)
- Game data vs user data separation

**Constraints shape decisions**: D1 limits, Worker CPU limits, clean-slate import.

**What it does NOT do**: Prevents scope confusion with adjacent features.

**Pointers to depth**: Links to code, conventions, test infrastructure.

**After reading**: You understand what SC Bridge is, how data flows through it, what the architectural constraints are, and where new features would fit. You could reason about whether a change affects user data or game data, predict the blast radius of a schema change, and explain the system to someone else.
