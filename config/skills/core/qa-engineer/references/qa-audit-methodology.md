---
description: Structured multi-phase QA audits for existing systems — from database integrity through E2E coverage
audience: { human: 30, agent: 70 }
purpose: { process: 45, wisdom: 30, knowledge: 25 }
---

# QA Audit Methodology

When you inherit a system, join a project mid-flight, or need to assess quality of something already running — you need a structured audit, not feature testing. This reference covers the approach.

---

## When to Audit

- A system has been built rapidly (especially by AI) and nobody has done a quality pass
- You're picking up a project that has tests but you don't know if they cover what matters
- Production bugs suggest systematic gaps, not one-off mistakes
- Before a major release or public launch
- After significant refactoring or architecture changes

---

## The 5-Phase Audit

Order matters. Start at the foundation (data) and work up to the user experience. Problems found in early phases often explain bugs in later phases.

### Phase 1: Database Integrity

**Why first**: If the data layer is broken, everything above it is unreliable. UI bugs may actually be data bugs wearing a UI disguise.

**What to check**:
- **FK constraints**: Do all foreign keys reference valid parent records? Run orphan queries.
- **Cascade behavior**: What happens when you delete a parent? Are children orphaned, cascaded, or set null?
- **Unique constraints**: Are uniqueness rules enforced at the DB level, not just application level?
- **Default values**: Do defaults match business rules?
- **Migration integrity**: Do all migrations run cleanly from scratch? Is the migration sequence deterministic?
- **Data relationships**: Follow data from creation through every join. Is the shape correct at each step?

**Concrete technique — orphan scan**:
```sql
-- Find orphaned child records (adapt table/column names)
SELECT c.id, c.parent_id
FROM child_table c
LEFT JOIN parent_table p ON c.parent_id = p.id
WHERE p.id IS NULL;
```

Run this pattern for every FK relationship. In production databases, also check:
```sql
-- Data distribution anomalies
SELECT column_name, COUNT(*) as count
FROM table_name
GROUP BY column_name
ORDER BY count DESC
LIMIT 20;
```

Unusual distributions (99% null, unexpected values dominating) signal data integrity issues.

**Output**: List of integrity issues with severity. Fix critical ones before proceeding — testing on top of bad data wastes time.

### Phase 2: Visual Review

**Why second**: After confirming data integrity, verify the UI renders that data correctly. This catches rendering bugs, missing data, and layout issues that automated tests miss.

**What to check**:
- **Every user-facing page**: Navigate the entire app as a real user would
- **Data correctness**: Is the displayed data correct? Not "is data present" — is it the RIGHT data?
- **Empty states**: What happens with no data? New user experience?
- **Error states**: Trigger real errors and see what the user sees
- **Loading states**: Are there spinners, skeletons, or blank flashes?
- **Navigation flow**: Does the user journey make sense? Are there dead ends?

**Technique — browser-assisted review**:
If Playwright MCP or similar browser automation is available, use it for systematic visual review:
1. Navigate to each page
2. Take full-page screenshots
3. Compare what you see against what the data layer says should be there
4. Check responsive behavior at key breakpoints

**Output**: Visual issues filed as individual items with screenshots. Categorize: broken (fix now), wrong (fix soon), ugly (fix later).

### Phase 3: User Data Pages

**Why third**: Pages that display user-specific data have the highest risk for data leakage, incorrect filtering, and auth bypasses.

**What to check**:
- **User isolation**: Can user A see user B's data? Test with multiple accounts.
- **Auth enforcement**: Remove/expire the session. Does the page redirect or expose data?
- **Data completeness**: Does the page show ALL of the user's data? Not just the first page?
- **Data accuracy**: Do aggregations, counts, and summaries match the raw data?
- **CRUD operations**: Create, read, update, delete — test each on user-owned data
- **Edge cases**: User with no data, user with maximum data, user with special characters in data

**User isolation test pattern**:
```
1. Create/login as User A
2. Add data as User A
3. Create/login as User B
4. Verify User B sees ONLY their own data (or nothing)
5. Attempt to access User A's data via direct URL/API manipulation
```

**Output**: Isolation violations and data accuracy issues. Isolation violations are always HIGH severity.

### Phase 4: E2E Test Expansion

**Why fourth**: Now that you understand the system's actual behavior (from phases 1-3), you can write meaningful E2E tests that cover what matters.

**What to add**:
- **Critical user paths**: The 3-5 workflows that define the product's value
- **Auth flows**: Login, logout, session expiry, role-based access
- **Data manipulation flows**: Create → read → update → delete, end to end
- **Cross-page workflows**: Flows that span multiple pages (e.g., import → view → analyze)
- **Error recovery**: What happens when a step fails mid-workflow?

**E2E test patterns that work**:
```
- Auth setup project: authenticate once, share state across tests
- waitForLoadState('networkidle'): reliable page-ready signal
- Conditional visibility checks: if (await element.isVisible()) — handle dynamic content
- Full-page screenshots: at key workflow steps for visual regression
- Explicit waits over arbitrary timeouts: waitForSelector > waitForTimeout
```

**What NOT to add**: Don't E2E-test implementation details. Test what the USER experiences, not what the code does internally.

**Output**: New E2E test files covering critical paths. Each test should be independently runnable.

### Phase 5: Unit/Integration Test Expansion

**Why last**: Unit tests are most valuable when you know what the system should do (from phases 1-4) and want to lock that behavior in.

**What to add**:
- **Untested endpoints**: Every API route should have at least: auth test, happy path, one error case
- **Untested business logic**: Complex calculations, filtering, sorting, aggregation
- **RBAC matrix**: Test every role against every protected endpoint
- **User isolation**: Test multi-tenant data separation at the API level
- **Edge cases discovered in phases 1-3**: Turn discoveries into regression tests

**Test infrastructure patterns**:
```
- setupTestDatabase(): Clean slate per suite (apply schema + migrations)
- Factory functions: createTestUser(), seedVehicle(), seedFleetEntry()
- Auth helpers: authHeaders() that generate valid signed session tokens
- Domain seeders: seedTradeData(), seedLootItem() — realistic data shapes
- User state variants: active, banned, deleted, expired session
```

**Coverage priority**:
1. Auth/RBAC (highest risk)
2. Data mutation endpoints (create, update, delete)
3. User-facing read endpoints (data correctness)
4. Admin endpoints (blast radius)
5. Public/health endpoints (lowest risk)

**Output**: New test files or expanded existing suites. Tests should follow the project's existing patterns.

---

## Filing Issues from Findings

Every finding should become a trackable item. Don't just fix — document first.

### Issue structure
- **Title**: What's wrong (not how to fix it)
- **Severity**: Critical / High / Medium / Low
- **Category**: Data integrity / Auth / UI / Logic / Test gap
- **Steps to reproduce**: Exact steps, including data state
- **Expected vs actual**: What should happen vs what does happen
- **Evidence**: Screenshots, SQL query results, API responses
- **Labels**: `qa-audit`, `phase-N`, severity label

### Severity guide
| Severity | Criteria | Action |
|----------|----------|--------|
| Critical | Data loss, security breach, complete feature failure | Fix before next deployment |
| High | Incorrect data shown to users, auth bypass, workflow broken | Fix this sprint |
| Medium | Cosmetic data issues, edge case failures, missing validation | Schedule fix |
| Low | Minor UI issues, test gaps, documentation needs | Backlog |

### Batch filing
Don't file 50 individual issues for related problems. Group them:
- One issue per root cause (not per symptom)
- One issue per page/feature for visual review findings
- One issue per endpoint for missing test coverage
- Reference related issues with links

---

## Adapting the Audit

### For small projects (< 20 endpoints)
Collapse phases 4 and 5. Write tests as you find issues in phases 1-3.

### For legacy systems (no existing tests)
Phase 5 becomes the primary output. Document what you find, then write the test infrastructure from scratch.

### For production systems under active use
Phase 2 gains priority — visual review against production data reveals issues that staging misses.

### For AI-built systems
Phase 1 gets extra weight. AI often builds schemas that look correct but have subtle relationship issues (wrong cascade direction, missing constraints, implicit assumptions about nullability).

---

## The Audit Report

After all phases, produce a summary:

```
## QA Audit Summary

### Scope
What was audited, what was excluded, and why.

### Findings by Phase
- Phase 1 (DB): N issues (X critical, Y high, Z medium)
- Phase 2 (Visual): N issues
- Phase 3 (User Data): N issues
- Phase 4 (E2E): N new tests, M gaps identified
- Phase 5 (Unit): N new tests, M gaps identified

### Critical Items (fix now)
- [Issue]: [One-line description]

### Systemic Patterns
- [Pattern observed across multiple findings]

### Confidence Assessment
- What you're confident about
- What you're uncertain about
- What you didn't test and why
```

The confidence assessment is the most valuable section. It tells the reader exactly how much to trust the audit.

---

*An audit is not a certificate of quality. It is a map of where the quality is — and where it isn't.*
