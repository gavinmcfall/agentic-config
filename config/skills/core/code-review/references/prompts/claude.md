---
description: Claude-optimized prompt template for disconnected code review
tags: [claude, anthropic, prompt, xml]
audience: { human: 10, agent: 90 }
purpose: { knowledge: 80, reference: 20 }
---

# Claude Review Prompt Template

Claude responds well to XML structure, explicit criteria, and role framing.

## Template

```xml
<context>
You are a senior software engineer performing an independent code review. You have never seen this code before and have no prior context about the project. Review only what the code shows, not any assumptions about intent.
</context>

<task>
Review the following {LANGUAGE} code for issues across these categories:
- Security (OWASP Top 10, auth, input validation)
- Design (patterns, coupling, abstractions)
- Correctness (bugs, edge cases, error handling)
- Maintainability (naming, complexity, modularity)
- Performance (algorithms, resources, queries)
</task>

<code path="{FILE_PATH}">
{CODE_CONTENT}
</code>

<related_context>
{OPTIONAL: Related files, interfaces, or dependencies that help understand the code}
</related_context>

<output_file>
Write your review to: .codereview/{TIMESTAMP}_{REPO_NAME}_claude_Review.md
Create the file with your complete findings.
</output_file>

<output_format>
For each issue found:
1. Location (file:line or function name)
2. Severity (Critical/High/Medium/Low)
3. Category (Security/Design/Correctness/etc)
4. Description (what's wrong)
5. Impact (why it matters)
6. Suggestion (how to fix)

End with:
- Summary: Overall assessment in 2-3 sentences
- Confidence: How confident are you in this review (High/Medium/Low)
- Limitations: What couldn't you assess without more context
</output_format>

<constraints>
- Only flag actionable issues
- Distinguish between "must fix" and "consider fixing"
- If something looks suspicious but you're uncertain, note your uncertainty
- Do not reference any prior conversation or context not provided above
- Write complete review to the specified output file
</constraints>
```

## Customization Points

| Placeholder | Description | Example |
|-------------|-------------|---------|
| `{LANGUAGE}` | Programming language | TypeScript, Python, Go |
| `{FILE_PATH}` | Path for location references | src/api/auth.ts |
| `{CODE_CONTENT}` | The actual code to review | [inline code] |
| `{RELATED_CONTEXT}` | Optional: interfaces, types, dependencies | [related files] |
| `{TIMESTAMP}` | Review timestamp | 2026-01-24_14-30-00 |
| `{REPO_NAME}` | Repository directory name | my-api |

## Focus Variants

### Security-Focused

Add to `<task>`:
```xml
Priority: Security issues. Specifically check for:
- SQL/NoSQL injection vectors
- XSS and output encoding
- Authentication and session handling
- Authorization and access control
- Secrets or credentials in code
- Unsafe deserialization
```

### Performance-Focused

Add to `<task>`:
```xml
Priority: Performance issues. Specifically check for:
- Algorithmic complexity (O(n^2) or worse)
- N+1 query patterns
- Memory leaks or unbounded growth
- Missing caching opportunities
- Resource cleanup (connections, handles)
- Blocking operations in async contexts
```

### PR Review (Diff-Focused)

```xml
<context>
You are reviewing a pull request. Focus on the changes, not the entire file.
Understand enough surrounding context to assess the changes properly.
</context>

<diff>
{GIT_DIFF_OUTPUT}
</diff>
```

## Claude-Specific Notes

- Claude 4.x interprets literally; be explicit about scope
- XML tags help structure parsing
- Extended thinking improves complex analysis (if available)
- Confidence calibration works well when explicitly requested
- Claude handles long context well; include relevant files

## Example Output

```markdown
## Issues Found

### Critical

**1. SQL Injection in user lookup**
- Location: `src/users/repository.ts:47`
- Category: Security
- Description: User input concatenated directly into SQL query
- Impact: Attackers can extract or modify database contents
- Suggestion: Use parameterized queries: `db.query('SELECT * FROM users WHERE id = $1', [userId])`

### High

**2. Missing null check before access**
- Location: `src/users/service.ts:23`
- Category: Correctness
- Description: `user.profile.settings` accessed without checking if profile exists
- Impact: Runtime crash when user has no profile
- Suggestion: Add optional chaining: `user.profile?.settings` or explicit check

## Summary
Code has one critical security vulnerability that must be fixed before deployment. The null safety issue is a bug waiting to happen in production. Overall structure is reasonable but error paths need attention.

## Confidence
High for security and correctness issues. Medium for performance (would need to see database schema and query patterns).

## Limitations
Could not assess: integration with auth service, database indexes, caching strategy without seeing related services.
```

---

*Claude works best with explicit structure and clear scope.*
