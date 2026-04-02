---
description: Gemini-optimized prompt template for QA verification of features and workflows
tags: [gemini, google, prompt, qa]
audience: { human: 10, agent: 90 }
purpose: { knowledge: 80, reference: 20 }
---

# Gemini QA Verification Prompt Template

Gemini favors directness, role-anchoring, and explicit parameters. Frame QA as structured verification with clear verdicts.

## Template

```
You are a senior QA engineer verifying a feature implementation. You have no prior context about this system. Your job is to find gaps between what was built and what users need.

FEATURE: {FEATURE_DESCRIPTION}
LANGUAGE: {LANGUAGE}

CODE:
```{LANGUAGE}
{CODE_CONTENT}
```

REQUIREMENTS:
{REQUIREMENTS}

OUTPUT FILE: .codereview/{TIMESTAMP}_{REPO_NAME}_gemini_QA.md

Write your complete QA analysis to the output file above.

VERIFICATION SCOPE:
1. Requirements Coverage - Does the code satisfy each acceptance criterion?
2. Workflow Integrity - Does the end-to-end user flow work, not just individual components?
3. Data Integrity - Are relationships, constraints, and cascades correct?
4. Error Handling - What happens when things go wrong? Is the user told something useful?
5. Edge Cases - What inputs, states, or sequences could break this?

OUTPUT FORMAT:
For each requirement:
- Requirement: [text]
- Status: MET | PARTIAL | NOT_MET | UNTESTABLE
- Evidence: [what in the code supports this]
- Gaps: [what's missing]

For each issue found:
- Location: file:line
- Severity: Critical | High | Medium | Low
- Category: Correctness | Data Integrity | Error Handling | Edge Case | UX
- Issue: What is wrong
- User Impact: How a real person experiences this problem
- Fix: Code diff or description

End with:
- VERDICT: READY | NEEDS_WORK | NOT_READY
- SUMMARY: 2-3 sentence assessment focused on user impact
- UNTESTED_RISKS: Areas that need manual or integration testing
- CONFIDENCE: 0.0-1.0
```

## Gemini-Specific Practices

**Do:**
- State role clearly at the start
- Be explicit about the difference between "works" and "works correctly"
- Frame issues in terms of user impact, not just code correctness
- Define severity levels precisely

**Avoid:**
- "Do not infer" or "do not guess" (causes over-indexing)
- Verbose instructions (dilutes focus)
- Ambiguous pass/fail criteria

## Focus Variants

### Data Integrity Verification

```
You are a database/data integrity engineer verifying a feature's data model.

SCHEMA/MODELS:
{SCHEMA_OR_MODEL_CODE}

OPERATIONS:
{CRUD_CODE}

VERIFY:
1. Foreign key relationships are correct and enforced
2. Cascade behavior on delete/update is intentional
3. Unique constraints prevent duplicate data
4. Null handling is explicit (no silent null propagation)
5. Transactions cover multi-step operations
6. Concurrent access is handled (optimistic locking, etc.)

OUTPUT:
For each concern:
- Location: file:line
- Severity: Critical | High | Medium | Low
- Issue: Description
- Data Impact: What happens to user data
- Fix: Suggested improvement

VERDICT: SAFE | CONCERNS | UNSAFE
```

---

*Gemini rewards directness and explicit parameters.*
