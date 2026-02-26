---
description: Detailed review criteria organized by category
tags: [code-review, criteria, security, performance, design]
audience: { human: 20, agent: 80 }
purpose: { knowledge: 70, reference: 30 }
---

# Review Criteria

Use these criteria based on review scope. Not every review needs every category.

## Functionality

| Check | Questions |
|-------|-----------|
| Correctness | Does code do what it claims? |
| Edge cases | Empty inputs? Null values? Boundary conditions? |
| Error handling | What happens on failure? Propagated? Swallowed? |
| Requirements alignment | Does it solve the actual problem? |
| Completeness | Any TODO comments? Unfinished paths? |

**Red flags**: Magic numbers, hardcoded values, assumptions in comments, dead code paths.

## Security (OWASP Top 10)

| Vulnerability | What to Check |
|---------------|---------------|
| Injection | User input in queries, commands, templates |
| Auth failures | Session handling, credential storage, bypass paths |
| Sensitive data | Logging, error messages, responses, encryption |
| XXE | XML parsing configuration |
| Access control | Authorization checks on all protected resources |
| Misconfig | Default credentials, verbose errors, unnecessary features |
| XSS | Output encoding, sanitization |
| Deserialization | Untrusted data deserialization |
| Dependencies | Known vulnerabilities in imports |
| Logging gaps | Security events captured? Sensitive data excluded? |

**Red flags**: String concatenation for queries, credentials in code, missing auth checks, `eval()` or equivalent.

## Design

| Aspect | Questions |
|--------|-----------|
| Patterns | Does approach fit the problem? Over-engineered? Under-engineered? |
| Coupling | How many things break if this changes? |
| Cohesion | Does this unit do one thing well? |
| Abstraction | Right level? Leaky? Missing? |
| Integration | Fits existing architecture? Introduces new patterns? |

**Red flags**: God classes, feature envy, inappropriate intimacy, duplicate abstractions.

## Maintainability

| Aspect | Questions |
|--------|-----------|
| Naming | Self-documenting? Misleading names? |
| Complexity | Cyclomatic complexity reasonable? Nested conditionals? |
| Size | Functions/classes right-sized? |
| Comments | Explain why, not what? Stale? |
| Consistency | Follows codebase conventions? |

**Red flags**: Single-letter variables outside loops, functions over 50 lines, comments contradicting code.

## Performance

| Aspect | Questions |
|--------|-----------|
| Algorithms | Right complexity? O(n^2) where O(n) possible? |
| Resources | Memory leaks? Connection leaks? File handles? |
| Queries | N+1 problems? Missing indexes? |
| Concurrency | Race conditions? Deadlock potential? |
| Caching | Appropriate? Invalidation correct? |

**Red flags**: Loops with database calls, unbounded collections, missing connection pooling.

## Testing

| Aspect | Questions |
|--------|-----------|
| Coverage | Happy path and error paths? |
| Edge cases | Boundary values? Empty states? |
| Assertions | Testing the right things? Brittle? |
| Isolation | Unit tests actually isolated? |
| Clarity | Test names describe behavior? |

**Red flags**: Tests that always pass, mock-heavy tests that don't test anything, missing error case tests.

## Severity Classification

| Level | Criteria | Examples |
|-------|----------|----------|
| Critical | Security vulnerability, data loss risk, blocks deployment | SQL injection, auth bypass, unencrypted PII |
| High | Significant bug, performance issue, maintainability blocker | Race condition, N+1 query, copy-paste code |
| Medium | Code quality issue, minor bug, tech debt | Poor naming, missing edge case, inconsistent style |
| Low | Nitpick, suggestion, preference | Formatting, optional refactor, documentation |

## Context-Dependent Scope

| Review Type | Primary Focus | Secondary |
|-------------|---------------|-----------|
| PR review | Changes only, integration points | Surrounding context |
| Feature audit | Functionality, design | Security, performance |
| Security audit | Security categories | Error handling |
| Performance review | Performance, queries | Algorithms, caching |
| Code quality | Maintainability, design | Testing |

---

*Not every review needs every criterion. Scope to what matters.*
