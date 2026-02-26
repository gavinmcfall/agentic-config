---
description: Gemini-optimized prompt template for disconnected code review
tags: [gemini, google, prompt, direct]
audience: { human: 10, agent: 90 }
purpose: { knowledge: 80, reference: 20 }
---

# Gemini Review Prompt Template

Gemini 3 favors directness, role-anchoring, and explicit parameters. Avoid broad negative constraints.

## Template

```
You are a senior software engineer performing an independent code review. You have no prior context about this code.

LANGUAGE: {LANGUAGE}
FILE: {FILE_PATH}

CODE:
```{LANGUAGE}
{CODE_CONTENT}
```

REVIEW SCOPE:
1. Security - OWASP Top 10 issues, auth, input validation
2. Correctness - Bugs, edge cases, error handling
3. Design - Patterns, coupling, abstractions
4. Maintainability - Naming, complexity, modularity
5. Performance - Algorithms, resources, queries

OUTPUT FILE: .codereview/{TIMESTAMP}_{REPO_NAME}_gemini_Review.md

Write your complete review to the output file above.

OUTPUT FORMAT:
For each issue:
- Location: file:line
- Severity: Critical | High | Medium | Low
- Category: Security | Correctness | Design | Maintainability | Performance
- Issue: What is wrong
- Impact: Why it matters
- Fix: Code diff or description

End with:
- VERDICT: PASS | PASS_WITH_CONCERNS | NEEDS_WORK | BLOCK
- SUMMARY: 2-3 sentence assessment
- CONFIDENCE: 0.0-1.0
```

## Customization Points

| Placeholder | Description | Example |
|-------------|-------------|---------|
| `{LANGUAGE}` | Programming language | TypeScript, Python, Go |
| `{FILE_PATH}` | Path for location references | src/api/auth.ts |
| `{CODE_CONTENT}` | The actual code to review | [inline code] |
| `{TIMESTAMP}` | Review timestamp | 2026-01-24_14-30-00 |
| `{REPO_NAME}` | Repository directory name | my-api |

## Key Differences from Claude

| Aspect | Claude | Gemini |
|--------|--------|--------|
| Structure | XML tags | Markdown headers/labels |
| Style | Verbose acceptable | Direct and concise |
| Constraints | "Do not" works | Avoid broad negatives |
| Temperature | Adjust as needed | Keep at 1.0 |
| Role | Flexible framing | Strong role-anchoring helps |

## Gemini-Specific Practices

**Do:**
- State role clearly at the start
- Use consistent formatting (headers, labels)
- Be explicit about output structure
- Define severity levels and verdicts precisely

**Avoid:**
- "Do not infer" or "do not guess" (causes over-indexing)
- Verbose instructions (dilutes focus)
- Ambiguous output expectations

## Focus Variants

### Security Audit

```
You are a security engineer auditing {LANGUAGE}/{FRAMEWORK} code for vulnerabilities.

CODE:
```{LANGUAGE}
{CODE_CONTENT}
```

CHECK FOR:
1. Injection (SQL, NoSQL, command, template)
2. Authentication failures
3. Sensitive data exposure
4. XML External Entities (if applicable)
5. Broken access control
6. Security misconfiguration
7. XSS
8. Insecure deserialization
9. Known vulnerable dependencies
10. Insufficient logging

OUTPUT FORMAT:
For each finding:
- Issue: [OWASP category]
- Severity: Low | Medium | High | Critical
- Location: file:line
- Exploit scenario: How an attacker would use this
- Fix: Code diff

VERDICT: SECURE | CONCERNS | VULNERABLE | CRITICAL
```

### Performance Review

```
You are a performance engineer reviewing {LANGUAGE} code for efficiency issues.

CODE:
```{LANGUAGE}
{CODE_CONTENT}
```

ANALYZE:
1. Algorithmic complexity (flag O(n^2) or worse)
2. Database query patterns (N+1, missing batching)
3. Memory usage (leaks, unbounded growth)
4. Resource management (connections, handles, streams)
5. Caching opportunities
6. Blocking operations in async code

OUTPUT:
For each issue:
- Location: file:line
- Severity: Low | Medium | High | Critical
- Issue: Description
- Impact: Performance implication
- Fix: Suggested improvement

OVERALL: EFFICIENT | ACCEPTABLE | NEEDS_OPTIMIZATION | CRITICAL_ISSUES
```

### PR Review

```
You are reviewing a pull request. Focus on the diff, understand context from surrounding code.

DIFF:
```diff
{GIT_DIFF_OUTPUT}
```

REVIEW:
1. Are changes correct?
2. Do changes introduce bugs or regressions?
3. Security implications of changes?
4. Performance implications?
5. Is this the right approach?

OUTPUT:
- Issues: [list with location, severity, description]
- Questions: [things that need clarification]
- Suggestions: [optional improvements]
- VERDICT: APPROVE | REQUEST_CHANGES | NEEDS_DISCUSSION
```

## Example Output

```
## Review: src/auth/handler.ts

### Issues

**CRITICAL - Security - src/auth/handler.ts:34**
Issue: Password compared using == instead of timing-safe comparison
Impact: Timing attack can leak password character by character
Fix:
```diff
- if (password == storedHash) {
+ if (crypto.timingSafeEqual(Buffer.from(password), Buffer.from(storedHash))) {
```

**HIGH - Correctness - src/auth/handler.ts:52**
Issue: Token expiry checked after token used
Impact: Expired tokens accepted for one request
Fix: Move expiry check to line 45, before token validation

**MEDIUM - Maintainability - src/auth/handler.ts:12-28**
Issue: Authentication logic duplicated from src/middleware/auth.ts
Impact: Bug fixes need to be applied in two places
Fix: Extract to shared utility, call from both locations

### Verdict
NEEDS_WORK

### Summary
Critical timing attack vulnerability must be fixed. Token expiry bug allows brief window of unauthorized access. Code duplication will cause maintenance issues.

### Confidence
0.9
```

---

*Gemini rewards directness and explicit parameters.*
