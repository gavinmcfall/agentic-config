---
name: review-responder
description: Process and respond to code review feedback. Use after receiving PR comments from GitHub, feedback from disconnected-code-review skill, or any code review input. Walks through changes one-by-one with user approval.
---

# Review Responder

You have received code review feedback. This skill guides you through processing that feedback systematically.

---

## Workflow Overview

1. **Summarize** — Present the review and proposed changes to the user
2. **Walk Through** — Apply or skip each change with user approval
3. **Respond** — Reply to GitHub comments if applicable

---

## Step 1: Summarize the Review

Present a clear summary to the user:

```markdown
## Review Summary

**Source**: [GitHub PR / disconnected-code-review skill / other]
**Overall Assessment**: [APPROVE / REQUEST CHANGES / NEEDS DISCUSSION]

### Changes Requested

| # | File | Issue | Severity |
|---|------|-------|----------|
| 1 | `src/auth.ts:47` | SQL injection vulnerability | 🔴 Blocking |
| 2 | `src/utils.ts:12` | Use existing helper | 🟡 Consider |
| 3 | `src/api.ts:89` | Add null check | 🟡 Consider |

### Summary
[1-2 sentences explaining the overall feedback]
```

**Ask the user**: "Ready to walk through these changes? I'll present each one for you to apply or skip."

---

## Step 2: Walk Through Changes

For each item, present:

```markdown
### Change 1 of N: [Brief title]

**File**: `path/to/file.ts:line`
**Severity**: [🔴 Blocking / 🟡 Consider / 🟢 Nit]

**Issue**:
[Explain what the reviewer flagged]

**Proposed Fix**:
[Show the specific code change]

---

Apply this change?
```

Use `AskUserQuestion` with options:
- **Apply** — Make the change
- **Skip** — Move to next item
- **Discuss** — Need more context before deciding

### On "Apply"
1. Make the change using Edit tool
2. Confirm: "Applied. Moving to next item..."

### On "Skip"
1. Note skipped for later reference
2. Continue: "Skipped. Moving to next item..."

### On "Discuss"
1. Provide additional context about the issue
2. Re-present the options

---

## Step 3: Respond to GitHub (If Applicable)

**Only if the review came from GitHub PR comments.**

After all changes are processed, summarize actions taken:

```markdown
## Actions Taken

| # | Issue | Action | Notes |
|---|-------|--------|-------|
| 1 | SQL injection | Applied | Used parameterized query |
| 2 | Use existing helper | Skipped | Intentional—helper doesn't fit this case |
| 3 | Add null check | Applied | — |
```

**Ask the user**: "Want me to respond to the GitHub comments?"

### If Yes, Respond to Each Comment

For each GitHub comment, post a reply:

**Applied changes**:
```
Done — [brief description of what was changed]
```

**Skipped changes**:
```
Skipped — [brief reason why, e.g., "intentional design choice because..."]
```

Use `gh pr comment` or the appropriate GitHub API to post replies.

---

## Detecting Review Source

Determine where the review came from:

| Source | Indicators | GitHub Response? |
|--------|------------|------------------|
| GitHub PR | URL mentioned, `gh pr` commands used, PR number referenced | Yes |
| code-review skill | Skill output format, no PR context | No |
| User-provided | Pasted feedback, verbal description | Ask user |

If unclear, ask: "Did this review come from a GitHub PR? If so, I can respond to comments directly."

---

## Handling Blocking Issues

For blocking issues (🔴):
- Present these **first**
- Emphasize they should be addressed before merge
- If user skips, confirm: "This was marked as blocking. Are you sure you want to skip?"

---

## End State

After walking through all items:

```markdown
## Complete

**Applied**: N changes
**Skipped**: M changes

[If GitHub]: Comments have been posted to the PR.
[If not pushed]: Don't forget to commit and push these changes.
```

---

*Systematic review response. Apply what makes sense, skip what doesn't, explain decisions.*
