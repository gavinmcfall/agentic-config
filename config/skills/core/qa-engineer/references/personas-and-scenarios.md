---
description: Thinking through user perspectives using personas and given/when/then scenarios
audience: { human: 30, agent: 70 }
purpose: { wisdom: 45, knowledge: 30, process: 25 }
---

# Personas and Scenarios

Personas prevent you from testing only as yourself. Scenarios prevent you from testing only the happy path.

---

## Why Personas

You (the builder) are the worst person to test your own work. You know how it's supposed to be used. You avoid the things that break. You follow the happy path because you built the happy path.

Personas force you to think as someone who doesn't know what you know.

---

## Core Personas

These four cover most testing needs. Adapt them to your domain.

### The New User
- Has never seen this interface before
- Doesn't know the conventions or shortcuts
- Reads labels literally
- Clicks things in unexpected order
- **Tests**: discoverability, clarity, onboarding, error messages that actually help

### The Power User
- Moves fast, uses keyboard shortcuts
- Has memorized the workflow and skips the "normal" steps
- Tries to do things in bulk
- Expects everything to be fast
- **Tests**: performance, efficiency, keyboard navigation, batch operations, edge cases from volume

### The Hostile User
- Actively trying to break it
- Submits garbage data, SQL injection, XSS payloads
- Manipulates URLs, API calls, hidden form fields
- Uses the system in ways you explicitly didn't intend
- **Tests**: security, input validation, authorization enforcement, error handling under adversarial conditions

### The Constrained User
- Slow network connection
- Small screen or large zoom level
- Uses assistive technology (screen reader, keyboard-only)
- May have intermittent connectivity
- **Tests**: accessibility, responsive design, offline/degraded behavior, loading states

---

## Given/When/Then Scenarios

Structure scenarios around the three elements:

- **Given**: the preconditions (who, what state, what context)
- **When**: the action (what the user does)
- **Then**: the expected outcome (what should happen)

### Writing Effective Scenarios

**Bad scenario** (too vague):
> Given a user, when they submit a form, then it should work.

**Good scenario** (specific, testable):
> Given a new user who has not verified their email,
> When they attempt to access the dashboard,
> Then they are redirected to the email verification page with a clear message explaining why.

### Critical Path Scenarios

For every feature, identify the 3-5 critical paths. These are the scenarios where failure is unacceptable:

1. **The primary happy path** — the most common use case
2. **The primary error path** — the most common way it fails
3. **The data boundary path** — empty state, maximum load, first/last item
4. **The permission path** — what happens for unauthorized access
5. **The recovery path** — what happens after a failure (retry, undo, back)

### Negative Scenarios

For every "when X, then Y" scenario, also ask:
- When NOT X, then what?
- When X but in the wrong state, then what?
- When X but with bad data, then what?
- When X but interrupted midway, then what?

Negative scenarios find more bugs than positive scenarios. The system is designed for positive paths; negative paths reveal assumptions.

---

## Persona-Based Scenario Matrix

Combine personas with scenarios for structured coverage:

```
Feature: Password Reset

| Persona         | Scenario                                         | Risk |
|-----------------|--------------------------------------------------|------|
| New User        | Requests reset, follows email link, sets new pwd | Med  |
| New User        | Enters email that doesn't exist                  | Med  |
| Power User      | Requests reset while already logged in            | Low  |
| Hostile User    | Attempts to enumerate valid emails via reset      | High |
| Hostile User    | Uses expired/tampered reset token                 | High |
| Constrained     | Reset email arrives, clicks link on mobile         | Med  |
| Constrained     | Slow network during password submission            | Low  |
```

You don't test every cell. You test the high-risk cells deeply and the low-risk cells lightly. But having the matrix makes the coverage decisions explicit.

---

## For AI Agents: Generating Scenarios

When building a feature, generate scenarios as you go:

1. **Before building**: Write 3-5 critical path scenarios. These are your acceptance criteria.
2. **During building**: When you make an assumption, write a scenario that tests it.
3. **After building**: Walk through each scenario. Did you build for it?
4. **Before presenting**: Pick the two highest-risk scenarios and verify them end-to-end.

Don't write 50 scenarios. Write the 5 that matter most and test those thoroughly.

---

*The user who finds the bug is never the user you designed for.*
