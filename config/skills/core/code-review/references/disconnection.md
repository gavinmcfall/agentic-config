---
description: How to achieve genuine disconnection from accumulated context during code review
tags: [fresh-eyes, perspective, bias, context]
audience: { human: 10, agent: 90 }
purpose: { wisdom: 60, constraint: 25, process: 15 }
---

# Achieving Disconnection

Disconnection is a perspective shift, not a memory wipe. You clear assumptions while gathering fresh context.

## Capsule: NewHireMindset

**Invariant**
Review as a competent engineer who has never seen this codebase, never met the author, and has no stake in the approach.

**Example**
The author chose Redis for caching. A connected reviewer thinks "they had good reasons." A disconnected reviewer asks "why Redis and not in-memory? Is this complexity warranted?"
//BOUNDARY: Question decisions, don't attack them. The goal is insight, not criticism.

**Depth**
- You know the domain; you don't know this specific code
- You're qualified to judge; you're not invested in outcomes
- Skepticism without hostility
- Curiosity without assumption

## What to Disconnect From

| Accumulated Context | Disconnection Action |
|--------------------|---------------------|
| Conversation history | Ignore what was discussed |
| Author intent | Judge code, not intentions |
| Implementation journey | Ignore why choices were made |
| Sunk cost awareness | Ignore effort invested |
| Relationship with author | Review code, not person |
| Your prior suggestions | Critique them like anyone else's |

## What to Gather Fresh

| Fresh Context | How to Gather |
|---------------|---------------|
| Codebase patterns | Read related files, look for conventions |
| Dependencies | Trace imports, understand integrations |
| Requirements | Read docs, tests, comments for intended behavior |
| Standards | Look for linting, style guides, team conventions |

## Capsule: QuestionTheObvious

**Invariant**
What seems obvious to someone close to the code is often invisible to them as a potential problem.

**Example**
Function named `processData` seems clear to the author who wrote it. Fresh eyes ask: "Process how? Data of what type? What happens on failure?"
//BOUNDARY: Not everything needs renaming. Question, then decide if the answer is "it's actually fine."

**Depth**
- Naming that made sense during writing may not communicate to readers
- "Temporary" solutions invisible to those who implemented them
- Complexity justified by context that no longer exists
- Edge cases the author never considered because they knew the happy path

## Capsule: IndependentVerification

**Invariant**
Claims about code behavior require verification from the code itself, not from what you were told.

**Example**
"This handles rate limiting." Disconnected review: trace the code path, verify limits are actually enforced, check what happens when exceeded.
//BOUNDARY: Trust but verify. Author descriptions are hypotheses, not facts.

**Depth**
- Comments may be stale
- Documentation may be aspirational
- Tests show intended behavior; code shows actual behavior
- When they conflict, code is truth

## Signs of Incomplete Disconnection

| Symptom | Indicates |
|---------|-----------|
| "As we discussed..." | Still connected to conversation |
| Skipping obvious questions | Assuming prior context |
| Defending author's choices | Invested in outcome |
| Missing issues you'd see in others' code | Blind spot from involvement |
| Accepting complexity without challenge | Sunk cost bias |

## Technique: The External Auditor

Imagine you're a consultant hired to review this code. You:
- Are paid to find problems
- Will be judged on thoroughness
- Have no relationship to protect
- Care only about code quality
- Write a report for stakeholders who weren't in the conversation

This framing naturally produces disconnection.

## Checklist

- [ ] Cleared assumptions about author intent
- [ ] Gathered context from code, not memory
- [ ] Questioned things that "seem obvious"
- [ ] Verified claims by tracing code paths
- [ ] No references to prior conversation in findings
- [ ] Would find these same issues in a stranger's code

---

*You cannot see clearly while standing where you stood when you built it.*
