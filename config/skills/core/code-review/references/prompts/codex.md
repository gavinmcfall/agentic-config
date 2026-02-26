---
description: OpenAI Codex-optimized prompt template for disconnected code review
tags: [codex, openai, gpt, prompt, structured-output]
audience: { human: 10, agent: 90 }
purpose: { knowledge: 80, reference: 20 }
---

# Codex Review Prompt Template

Codex (gpt-5.2-codex) is trained specifically for code review. It expects structured output, priority levels, and a verdict with confidence score.

## Template

```
You are acting as a reviewer for a proposed code change made by another engineer. You have no prior context about this code. Focus on issues that impact correctness, performance, security, maintainability, or developer experience.

## Code to Review

Language: {LANGUAGE}
File: {FILE_PATH}

```{LANGUAGE}
{CODE_CONTENT}
```

## Output File

Write your complete review to: .codereview/{TIMESTAMP}_{REPO_NAME}_codex_Review.md

## Review Instructions

Flag only actionable issues introduced by this code. When flagging an issue:
1. Provide a short, direct explanation
2. Cite the affected file and line range
3. Assign priority: P0 (blocks merge), P1 (should fix), P2 (consider fixing)
4. Suggest a fix when possible

Prioritize severe issues. Avoid nit-level comments unless they block understanding.

## Output Format

Return findings as JSON:

```json
{
  "findings": [
    {
      "file": "string",
      "line_start": number,
      "line_end": number,
      "priority": "P0" | "P1" | "P2",
      "category": "security" | "correctness" | "performance" | "maintainability" | "dx",
      "title": "string (brief issue name)",
      "description": "string (what's wrong and why)",
      "suggestion": "string (how to fix, optional)"
    }
  ],
  "verdict": "correct" | "incorrect",
  "verdict_reason": "string (concise justification)",
  "confidence": number (0.0 to 1.0)
}
```

After JSON, provide a brief prose summary.
```

## Customization Points

| Placeholder | Description | Example |
|-------------|-------------|---------|
| `{LANGUAGE}` | Programming language | TypeScript, Python, Go |
| `{FILE_PATH}` | Path for location references | src/api/auth.ts |
| `{CODE_CONTENT}` | The actual code to review | [inline code] |
| `{TIMESTAMP}` | Review timestamp | 2026-01-24_14-30-00 |
| `{REPO_NAME}` | Repository directory name | my-api |

## Priority Definitions

| Priority | Meaning | Examples |
|----------|---------|----------|
| P0 | Blocks merge, must fix | Security vulnerability, data loss risk, crash |
| P1 | Should fix before merge | Bug, performance issue, missing error handling |
| P2 | Consider fixing | Code quality, optional improvement, style |

## Codex-Specific Practices

**Model and settings:**
- Model: `gpt-5.2-codex`
- Reasoning effort: `medium` for typical reviews, `high` for complex code
- Use structured output schema for consistent JSON parsing

**Prompting:**
- Codex is trained to focus on actionable issues
- Priority levels map to GitHub review behavior (P0/P1 = request changes)
- Confidence score helps calibrate trust in findings
- Remove instructions for plans or status updates (causes premature stop)

**Integration:**
- Works with AGENTS.md for project-specific context
- `@codex review` in GitHub PR comments for direct integration
- `/review` in Codex CLI for local review

## Focus Variants

### Security-Focused

Add to instructions:
```
Focus: Security issues only. Flag:
- Injection vulnerabilities (SQL, command, template)
- Authentication and authorization flaws
- Sensitive data exposure (logging, errors, responses)
- Cryptographic weaknesses
- Access control bypasses

Treat all security issues as P0 or P1.
```

### PR Diff Review

```
You are reviewing a pull request diff. Focus on changes only.

## Diff

```diff
{GIT_DIFF_OUTPUT}
```

## Context Files (read-only, for understanding)

{OPTIONAL_CONTEXT_FILES}

Review the diff for issues. Consider how changes interact with existing code.
```

## Example Output

```json
{
  "findings": [
    {
      "file": "src/api/users.ts",
      "line_start": 45,
      "line_end": 47,
      "priority": "P0",
      "category": "security",
      "title": "SQL injection in user query",
      "description": "User ID from request params is concatenated directly into SQL string. Attacker can inject arbitrary SQL.",
      "suggestion": "Use parameterized query: db.query('SELECT * FROM users WHERE id = $1', [params.userId])"
    },
    {
      "file": "src/api/users.ts",
      "line_start": 52,
      "line_end": 52,
      "priority": "P1",
      "category": "correctness",
      "title": "Unchecked null access",
      "description": "user.profile accessed without null check. Will throw if user has no profile.",
      "suggestion": "Add optional chaining: user.profile?.settings or explicit null check"
    },
    {
      "file": "src/api/users.ts",
      "line_start": 30,
      "line_end": 35,
      "priority": "P2",
      "category": "maintainability",
      "title": "Magic number in timeout",
      "description": "Timeout value 30000 should be a named constant for clarity.",
      "suggestion": "const QUERY_TIMEOUT_MS = 30000;"
    }
  ],
  "verdict": "incorrect",
  "verdict_reason": "P0 SQL injection vulnerability must be fixed before merge. P1 null safety bug will cause production crashes.",
  "confidence": 0.92
}
```

**Summary:** This code has a critical SQL injection vulnerability that allows arbitrary database access. The null safety issue will cause crashes for users without profiles. The magic number is a minor readability concern. Recommend blocking merge until P0 and P1 issues are addressed.

## JSON Schema (for structured output)

```json
{
  "type": "object",
  "properties": {
    "findings": {
      "type": "array",
      "items": {
        "type": "object",
        "properties": {
          "file": { "type": "string" },
          "line_start": { "type": "integer" },
          "line_end": { "type": "integer" },
          "priority": { "enum": ["P0", "P1", "P2"] },
          "category": { "enum": ["security", "correctness", "performance", "maintainability", "dx"] },
          "title": { "type": "string" },
          "description": { "type": "string" },
          "suggestion": { "type": "string" }
        },
        "required": ["file", "line_start", "line_end", "priority", "category", "title", "description"]
      }
    },
    "verdict": { "enum": ["correct", "incorrect"] },
    "verdict_reason": { "type": "string" },
    "confidence": { "type": "number", "minimum": 0, "maximum": 1 }
  },
  "required": ["findings", "verdict", "verdict_reason", "confidence"]
}
```

---

*Codex wants structured output and clear priority levels.*
