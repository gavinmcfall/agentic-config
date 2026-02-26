---
description: How to write north star documents — testable outcome declarations from the user's perspective
tags: [north-star, outcomes, declarations, methodology]
audience: { human: 70, agent: 30 }
purpose: { gestalt: 20, high-agency-process: 50, reference: 30 }
---

# Writing North Star Documents

A north star declares what great looks like. Not features, not architecture — outcomes from the user's perspective, written as testable statements.

---

## Capsule: PaintTheDream

**Invariant**
Open with a narrative paragraph showing what the experience feels like when fully realized.

**Example**
"A group leader opens their dashboard and immediately sees who attended last week, who's been absent for three weeks, and which new visitors are ready for follow-up. No clicking through menus, no exporting spreadsheets, no asking the office administrator."
//BOUNDARY: The dream is aspirational but grounded. Not science fiction — achievable with known technology.

---

## Capsule: DeclarationsNotDescriptions

**Invariant**
Declare what should be achievable, not what a system is. North stars use active language about outcomes.

**Example**
Bad: "The system displays attendance data."
Good: "A group leader should be able to see who attended last week without leaving the group page."
//BOUNDARY: Descriptions document what exists. Declarations define what should exist.

---

## Capsule: EvaluableStatements

**Invariant**
Every declaration must be checkable as yes/no against an implementation.

**Example**
Testable: "A new user can complete registration in under 2 minutes without external help."
Not testable: "The registration experience should be intuitive."
//BOUNDARY: If you can't write a verification step, the declaration is too vague.

**Depth**
- The Dream Test: prefix any statement with "I have a dream:" — if it reads naturally, it's a valid declaration
- Each declaration guides many design decisions
- An agent can check "is this true in the system?" against each one

---

## Capsule: VisionNotImplementation

**Invariant**
North stars contain capabilities and outcomes, not components or mechanisms.

**Example**
Bad: "Use WebSockets for real-time updates."
Good: "Changes made by one team member are visible to others within seconds."
//BOUNDARY: Implementation belongs in the design layer. The north star defines what success looks like, not how to build it.

---

## Capsule: TimelessDeclarations

**Invariant**
No temporal markers. The north star describes a desired state, not a plan or a delta from current.

**Example**
Bad: "Currently users can't see attendance. We plan to add this in Q3."
Good: "Group leaders can see attendance history for any time period."
//BOUNDARY: "Currently" and "planned" both anchor to a moment in time. Declarations are timeless.

---

## Structure Template

```markdown
# [Feature Area] — North Star

[Narrative paragraph painting the dream — what does the experience feel like when done right?]

---

## Declarations

### [Category]

- [Testable outcome statement]
- [Testable outcome statement]

### [Category]

- [Testable outcome statement]

---

## What We Won't Accept

- [Anti-pattern or unacceptable outcome]
- [Constraint that must be respected]

---

## How to Use This Document

This north star is the evaluation target for designs and plans in this feature area.
A design decision that serves a declaration is justified.
One that doesn't needs a reason.
```

---

## What to Avoid

| Anti-Pattern | Problem | Fix |
|-------------|---------|-----|
| Feature lists | "Add search, add filters, add export" | State the outcome the features serve |
| Architecture in disguise | "Use microservices for scalability" | State the scalability requirement, not the solution |
| Vague aspirations | "World-class user experience" | Make it testable: what specifically would be true? |
| Temporal anchoring | "By Q3 we will..." | Remove the date. Declare the end state. |
| Describing current state | "Currently the system does X" | That belongs in findings, not north star |
