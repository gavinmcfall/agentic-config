---
description: What to verify for different types of changes — scaled to risk, not exhaustive
audience: { human: 20, agent: 80 }
purpose: { knowledge: 45, constraint: 35, process: 20 }
---

# Verification Checklist

Not everything needs the same level of verification. Scale effort to risk. But never skip verification entirely.

---

## Before Presenting ANY Work

The absolute minimum. Non-negotiable.

- [ ] It runs without errors
- [ ] The data shown is correct, not just present
- [ ] The primary user workflow works end-to-end
- [ ] You can articulate what you did NOT test

If you cannot check all four, say so before presenting. "This compiles but I haven't verified the data relationships" is acceptable. Silent omission is not.

---

## Database Changes

### Schema
- [ ] FK constraints are correct and enforced
- [ ] Cascade behavior (ON DELETE, ON UPDATE) is intentional
- [ ] Nullability matches business rules
- [ ] Indexes support the actual query patterns
- [ ] Migration runs forward cleanly
- [ ] Migration runs backward cleanly (if reversible)
- [ ] Existing data survives the migration intact

### Queries
- [ ] Joins return correct results (not duplicated, not missing)
- [ ] N+1 query patterns are avoided
- [ ] Queries handle empty result sets gracefully
- [ ] Parameterized queries used (no string concatenation)
- [ ] Pagination works correctly at boundaries (first page, last page, empty)

### Data Integrity
- [ ] Creating a record: all required fields populated, relationships established
- [ ] Updating a record: only intended fields change, relationships preserved
- [ ] Deleting a record: cascades behave correctly, no orphans created
- [ ] Concurrent operations: race conditions considered
- [ ] Orphan scan: query every FK relationship for dangling references
- [ ] Data distribution: check for anomalous concentrations (99% null, unexpected dominant values)
- [ ] Cross-table consistency: data that appears in multiple views/joins returns the same values

---

## API Changes

### Request Handling
- [ ] Valid request returns correct response
- [ ] Invalid request returns appropriate error (400, 422, etc.)
- [ ] Missing required fields return clear error messages
- [ ] Auth is enforced (401 for unauthenticated, 403 for unauthorized)
- [ ] Rate limiting / throttling behaves correctly

### Response Shape
- [ ] Response matches documented/expected schema
- [ ] Null/empty values handled correctly in response
- [ ] Error responses are structured and don't leak internals
- [ ] Pagination metadata is correct (total count, page size, etc.)

### Integration
- [ ] Upstream callers won't break on the new response shape
- [ ] Downstream services are called correctly
- [ ] Timeout and retry behavior is appropriate
- [ ] Circuit breaker / fallback works if dependency is down

---

## UI Changes

### Rendering
- [ ] Correct data displayed (not mock/placeholder/stale)
- [ ] Loading states shown during async operations
- [ ] Error states shown when operations fail
- [ ] Empty states shown when no data exists

### Interaction
- [ ] Primary user flow works end-to-end
- [ ] Form validation fires on appropriate events
- [ ] Submit works, with feedback on success/failure
- [ ] Navigation between related pages maintains state correctly
- [ ] Back button / browser refresh doesn't break state

### Edge Cases
- [ ] Very long text content doesn't break layout
- [ ] Very large datasets don't cause performance issues
- [ ] Concurrent actions from multiple tabs handled
- [ ] Keyboard navigation works for primary flows

---

## Authentication / Authorization

### Auth is a HIGH RISK area. Always verify deeply.

- [ ] Unauthenticated users cannot access protected resources (401)
- [ ] Authenticated users can only access their own resources
- [ ] Role-based access is enforced (not just hidden UI)
- [ ] Token expiration is handled gracefully
- [ ] Session invalidation works (logout, password change)
- [ ] Auth state persists across page refresh
- [ ] Auth errors don't leak information about valid accounts
- [ ] RBAC matrix tested: every role × every protected endpoint (user, admin, banned, deleted)
- [ ] User isolation: multi-user test — user A's data invisible to user B
- [ ] Direct URL/API manipulation cannot bypass authorization

---

## Configuration Changes

- [ ] Application starts with the new configuration
- [ ] Invalid configuration fails fast with clear error message
- [ ] Missing configuration uses sensible defaults
- [ ] Configuration changes don't require code deployment to take effect (if that's the design)
- [ ] Old configuration still works (if rollback is needed)

---

## CI/CD / Infrastructure Changes

- [ ] Pipeline runs to completion
- [ ] All existing tests still pass
- [ ] New tests are added for new behavior
- [ ] Deployment succeeds in staging/preview environment
- [ ] Health checks pass after deployment
- [ ] Rollback path is verified

---

## Scaling the Checklist

Not every change needs every check. Use risk assessment to decide depth:

| Risk Level | Verification Depth |
|------------|-------------------|
| **High** | Full relevant section + exploratory testing |
| **Medium** | Key items from relevant section + happy path |
| **Low** | "Before presenting" minimum + spot check |
| **Trivial** (typo fix, comment) | Visual confirmation only |

The checklist is a thinking tool, not a compliance form. Use it to prompt your thinking, not to tick boxes.

---

## Test Infrastructure Patterns

When building test infrastructure (not just individual tests), these patterns prevent common setup failures:

### Database Setup
- **Clean slate per suite**: `setupTestDatabase()` in `beforeAll()` — apply schema + all migrations from scratch
- **Deterministic ordering**: Schema tables first (auth, config), then domain migrations in sequence
- **FK prerequisites**: Parent tables must exist before child migrations run

### Factories and Helpers
- **User factories**: `createTestUser(db, overrides?)` returning `{ userId, sessionToken }` — isolated per test
- **Domain seeders**: `createTestProject()`, `createTestTask()`, `createTestComment()` — realistic data with sensible defaults
- **Auth helpers**: `authHeaders(sessionToken)` — generates properly signed session headers
- **State variants**: Factories should support `{ status: "banned" }`, `{ status: "deleted" }`, expired sessions

### Test Isolation
- Each test creates its own user(s) — never share users between tests
- Each suite starts with a clean database — never depend on another suite's state
- Each assertion is specific — not `expect(data).toBeTruthy()` but `expect(data.name).toBe("expected")`

---

*The question is never "did you test?" The question is "what did you test, and what didn't you test?"*
