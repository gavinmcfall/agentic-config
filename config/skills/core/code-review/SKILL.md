---
name: code-review
description: Review code with fresh eyes for correctness, security, and maintainability. Generate standalone prompts for Claude, Gemini, and Codex. Use when reviewing PRs, commits, staged changes, or auditing code.
context: fork
allowed-tools:
  - Read
  - Glob
  - Grep
  - Skill
  - Bash(git diff:*)
  - Bash(git show:*)
  - Bash(git log:*)
  - Bash(gh pr diff:*)
  - Bash(gh pr view:*)
  - Bash(mkdir:*)
  - Bash(ls:*)
  - Write
---

# Code Review

> **Runs as Sub-Agent**
>
> This skill uses `context: fork` to run in an isolated sub-agent. This saves tokens in the main conversation—you perform the review and return only the summary.

---

**First**: Invoke the `writing-documents` skill. Your review output is a findings document.

**Start here**: Read `references/disconnection.md`. The fresh-eyes mindset is the core skill.

---

## Capsule: FreshEyes

**Invariant**
A disconnected review ignores what you know and examines only what the code shows.

**Example**
You helped write a feature over 10 messages. For the review, you are a new hire seeing the code for the first time. You question what seems obvious. You find what the author missed because they were too close.
//BOUNDARY: Disconnection is not ignorance. You gather fresh context; you don't ignore context entirely.

## Capsule: StandalonePrompt

**Invariant**
A prompt is standalone when it produces useful output without any prior conversation context.

**Example**
Bad: "Review the authentication changes we discussed."
Good: "Review the following authentication code for OWASP Top 10 vulnerabilities. Code: [inline code or file paths]."
//BOUNDARY: Self-contained is not exhaustive. Scope and focus, not every detail.

---

## What to Review

Determine the diff to review:

1. **If `$ARGUMENTS` provided**: Review that file, commit, or PR
2. **If staged changes exist**: `git diff --cached`
3. **If unstaged changes exist**: `git diff`
4. **Otherwise**: Ask user what to review

---

## Review Priority (High to Low)

1. **Correctness** — Does it work? Logic errors, edge cases, null handling
2. **Security** — OWASP Top 10, input validation, secrets exposure
3. **Architecture** — SOLID violations, layer boundaries, coupling
4. **Performance** — O(n²) loops, N+1 queries, resource leaks
5. **Tests** — Coverage of critical paths, test quality
6. **Maintainability** — Naming, complexity, documentation
7. **Style** — Only if egregious; formatters should handle this

---

## Review Process

### 1. Disconnect

- Clear assumptions about author intent
- Adopt external auditor mindset
- You're a competent engineer who has never seen this code

### 2. Gather Fresh Context

For each file changed:
- Read related files for conventions
- Trace imports and dependencies
- Check tests for intended behavior

### 3. Analyze

| Category | What to Examine |
|----------|-----------------|
| Functionality | Does code do what it claims? Edge cases? |
| Security | OWASP Top 10, auth, input validation |
| Design | Patterns, coupling, separation of concerns |
| Maintainability | Naming, complexity, modularity |
| Performance | Bottlenecks, resource usage, scaling |
| Testing | Coverage, edge cases, assertions |

### 4. Check for Reuse Opportunities

New code often duplicates existing utilities. Search the codebase:

- **Similar function names** — Does a helper already exist?
- **Common directories** — `utils/`, `helpers/`, `lib/`, `common/`, `shared/`
- **Nearby files** — How do similar features solve this?

If existing utilities could replace new code, flag it.

### 5. Document Findings

Write a findings document using `writing-documents` guidance.

---

## Severity Prefixes

Use visual prefixes for scannability:

| Prefix | Meaning | Author Action |
|--------|---------|---------------|
| `🔴 Blocking:` | Must fix before merge | Required |
| `🟡 Consider:` | Strong suggestion | Author decides |
| `🟢 Nit:` | Minor polish | Optional |
| `❓ Question:` | Need clarification | Please respond |

### Explain the "Why"

**Weak**: "Use a map here"

**Strong**: "🟡 Consider: `src/users.ts:34` — This list scan is O(n) per loop iteration, making the overall operation O(n²). With 10k users, that's 100M comparisons. A Map gives O(1) lookup."

### Offer Fixes for Blocking Issues

```
🔴 Blocking: `src/api/query.ts:12` — SQL injection vulnerability.
User input is concatenated directly into the query.

Instead of:
  `db.query("SELECT * FROM users WHERE id = " + userId)`

Use parameterized queries:
  `db.query("SELECT * FROM users WHERE id = ?", [userId])`
```

---

## Red Flags (Always Blocking)

- Hardcoded secrets, API keys, passwords
- SQL/command injection vulnerabilities
- Missing input validation on user data
- Unbounded loops or recursion
- Resources opened but not closed
- Catch blocks that swallow exceptions silently
- Tests without assertions

## Yellow Flags (Flag as Consider)

- New utility that duplicates existing helper
- Pattern differs from how nearby code solves same problem
- Reimplemented logic available in project dependencies
- New abstraction when existing one could be extended

---

## Output Directory Setup

Before generating prompts, ensure output directory exists:

1. **Create directory** (if not present): `.codereview/` in repo root
2. **Add to .gitignore** (if not present): append `.codereview/` to `.gitignore`

**File naming convention**:
```
.codereview/YYYY-MM-DD_HH-MM-SS_{repo-name}_{agent}_Review.md
```

---

## Output Structure

### Findings Document

```markdown
## Summary

[1-2 sentences: what this change does and overall assessment]

**Verdict: APPROVE / REQUEST CHANGES / NEEDS DISCUSSION**

---

## Blocking Issues

[Must fix — omit section if none]

### 🔴 [Brief issue title]
`file:line`

[Explanation of problem and why it matters]

**Fix:**
[Concrete suggestion or code example]

---

## Suggestions

[Strong recommendations — omit section if none]

### 🟡 [Brief issue title]
`file:line`

[Explanation and reasoning]

---

## Minor Notes

[Nits and questions — omit section if none]

- 🟢 `file:line` — [Brief note]
- ❓ `file:line` — [Question]
```

### Generated Prompts

Three separate prompts optimized for:
- **Claude** → `references/prompts/claude.md` — XML structure, extended thinking
- **Gemini** → `references/prompts/gemini.md` — Direct style, role-anchored
- **Codex** → `references/prompts/codex.md` — JSON output, priority levels

---

## Constraints

- Never reference conversation history in findings or prompts
- Gather context independently; don't assume from prior discussion
- Question what seems obvious—including code you helped write
- Include code inline or by explicit path in generated prompts
- Mark confidence levels: verified (code), inferred (patterns), uncertain
- Critique your own prior suggestions as rigorously as anyone else's

---

## After Review

When returning your review to the main conversation, recommend invoking `review-responder` to process findings:

> To address these findings, invoke the `review-responder` skill with this review.

---

## Deeper

- `references/disconnection.md` — How to achieve fresh perspective
- `references/criteria.md` — Detailed review criteria by category
- `references/prompts/` — AI-specific prompt templates

---

*Review what IS, not what was meant. Continuous improvement, not perfection.*
