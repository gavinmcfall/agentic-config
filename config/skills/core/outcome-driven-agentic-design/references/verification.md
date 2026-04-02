---
description: How to verify each layer of the declaration chain against its predecessor
tags: [verification, error-correction, methodology, outcome-driven]
audience: { human: 20, agent: 80 }
purpose: { high-agency-process: 60, reference: 40 }
---

# Verification Chain

Each layer can be verified against its predecessor. These are mechanical checks agents can perform.

---

## The Chain

| From → To | The Question | What Failure Looks Like |
|-----------|-------------|------------------------|
| Reality → Findings | Are findings accurate? | Claims that don't match code or telemetry |
| Findings → North Star | Is every declaration grounded? | Declarations based on assumption, not evidence |
| North Star → Flows | Does every outcome have a process? | Orphaned declarations with no path to realization |
| Flows → Design | Does the architecture handle everything? | Happy-path designs; failure modes without responses |
| Design → Plans | Is everything covered? | Design sections with no plans |
| Plans → Code | Are truth statements true? | EARS statements that fail in the running system |

---

## Findings → North Star

**Check**: For each declaration, can you point to specific findings that justify it?

**Catch**:
- Declarations based on intuition rather than evidence
- Declarations addressing perceived gaps rather than real ones
- Significant findings with no north star response

**Technique**: List all declarations. For each, find the supporting finding. Flag any without a source. Flag any finding that seems significant but has no declaration.

---

## North Star → Flows

**Check**: For each declaration, is there at least one flow that makes it real?

**Catch**:
- Orphaned declarations with no process to deliver them
- Flows that don't trace to any declaration (scope creep)
- Declarations too vague to have a verifiable flow

**Technique**: Coverage matrix. Declarations as rows, flows as columns. Mark which flows serve which declarations. Empty rows are gaps. Columns with no row connections are scope creep.

---

## Flows → Design

**Check**: Does the design handle every stage, actor handoff, and failure mode?

**Catch**:
- Flow failure modes without architectural responses
- Missing cross-cutting concerns (authentication, error handling, logging that flows don't own but all need)
- Technology choices that cannot support a flow's requirements

**Technique**: Walk each flow stage. For each, find the design section that addresses it. Pay special attention to failure modes and actor handoffs — these are where designs underspecify.

---

## Design → Plans

**Check**: Do plans collectively cover everything the design describes?

**Catch**:
- Design sections with no plans (nothing will implement them)
- Plans that overlap in scope (will conflict during implementation)
- Plans that don't link to their design sections (context loss)
- Missing dependency declarations between plans

**Technique**: Map plan scopes against design sections. Look for gaps and overlaps. Verify the dependency graph is a DAG with no orphans.

---

## Plans → Implementation

**Check**: Are EARS truth statements actually true in the running system?

**Catch**:
- Statements true in tests but not production
- Statements partially true (some conditions met, others not)
- Statements true but fragile (no monitoring to detect regression)

**The three design questions apply here**:

| Question | What It Verifies |
|----------|-----------------|
| Works on my machine? | Local dev experience validates truth statements |
| Works in PRs? | Automated tests assert truth statements |
| Works in production? | Telemetry confirms truth statements at scale |

If the design cannot answer these three questions, it is not ready for plans.

---

## When to Run Verification

| Moment | What to Check |
|--------|---------------|
| After writing a new layer | Against the previous layer, before proceeding |
| Before implementation begins | Full chain review: findings through plans |
| After implementation | Plans → code: are truth statements true? |
| When something changes | Trace the change through the chain to find what else needs updating |

---

*If a layer fails verification, fix it before proceeding. Errors compound.*
