# Outcome-Driven Agentic Design

A design methodology where permanent documents declare how the system should work, and ephemeral plans close the gap between declaration and reality.

---

## The Idea

Before writing code, build a **declaration of intent** — a chain of documents that declares how the system should work.

Then write **plans** that close the gap between the declaration and reality. When the plans are done, delete them — the declaration remains as a living definition of how the system works.

Five layers, each building on the previous:

1. **Findings** — synthesize everything known into evidence
2. **North Star** — declare what great looks like
3. **Flows** — describe the processes that must exist
4. **Design** — specify contracts and architecture
5. **Plans** — state what's not true yet

The first four are permanent — they form the living declaration of intent. Plans are ephemeral, deleted when the gap they describe is closed. Each layer can be checked for accuracy against its predecessor, so errors surface early instead of compounding silently into production.

**Important**: The North Star, flows, and design should NOT be thought of as documentation. They should be thought of as code at a higher level of abstraction. They live alongside the implementation — and when functional changes are made, they are made to the documents first and flow down into implementation.

---

## The Layers

### Findings — What's true?

Most projects have enormous latent context — the codebase, production telemetry, support tickets, customer conversations, market research — but it's distributed across systems, people, and history. Nobody has the full picture.

An agent can read the actual code, query production metrics, cross-reference feedback with codebase behavior, and verify whether a claimed capability really exists. The synthesis is the superpower — not because any single source is hard to read, but because nobody has read them all together before.

Sources to draw from:
- **Existing code** — what the system actually does today (verify against code, don't assume)
- **Production telemetry** — how the system is actually used, not how it was designed to be used
- **User feedback** — support tickets, conversations, feature requests
- **Market research** — competitor approaches, industry standards
- **Institutional knowledge** — architecture decisions, post-mortems, previous designs

Findings are not recommendations. "The forms engine stores responses in a generic key-value table with no schema validation" is a finding. Whether to add schema validation belongs in the north star.

### North Star — What should be true?

The north star declares what great looks like. Written from the user's perspective in testable statements. Not features, not architecture — outcomes.

"A group leader should be able to see who attended last week without leaving the group page." That's a north star declaration. It's testable. It doesn't prescribe how. An agent can verify it ("is this true in the system?") and a human can evaluate it ("is this what we actually want?").

The north star is the evaluation target for everything downstream. A design decision that serves the north star is justified. One that doesn't needs a reason.

### Flows — What must the system do?

Flows describe multi-step processes that must exist to make the north star real. They establish unambiguous shared understanding of what the system does — not how it's built.

| Allowed | Not Allowed |
|---------|-------------|
| Third-party API specs (proves viability) | Your API designs (that's the design's job) |
| Failure modes and recovery | Implementation choices |
| Actors, stages, handoffs, decisions | Internal data structures |
| Domain rules that constrain behavior | Technology stack decisions |

Flows force you to think about failure before you think about architecture. If no process is complex enough to justify a flow, skip this layer.

### Design — How could it be built?

The design describes at a high level how the flows could be implemented. Contracts and architecture only. No implementation.

The design must answer three verification questions:

| Question | What It Forces |
|----------|----------------|
| How do I know it works on my machine? | Local dev experience, seed data, manual verification steps |
| How do I know it works in PRs? | Automated tests — what's asserted, what coverage means |
| How do I know it works in production? | Observability — metrics, alerts, what "healthy" looks like |

These aren't afterthoughts. They're architectural constraints. A system that can't be observed can't be trusted.

### Plans — What's not true yet?

A plan is a set of statements that must be true for the plan to be considered complete. Not tasks. Not implementation instructions. Statements about the state of the world.

Each plan:
- **Links back** to which north star declarations, flow stages, and design sections it satisfies
- **Has ancestors and descendants** — explicit dependency relationships with other plans
- **Declares what, not how** — the agent reads the declaration for context and uses its own judgment for implementation
- **Is deleted when complete** — once the statements are true in the running system, the plan has served its purpose

---

## What Makes This Different

### The Declaration Is the Source of Truth

The declaration of intent is not documentation of the system. It's the definition of how the system *should* work. When the declaration and the code disagree, the declaration wins — make a plan to align the code. Or, if intent has changed, update the declaration first.

### Each Layer Checks the One Before It

| Layer | Checked Against | The Question |
|-------|-----------------|--------------|
| **North Star** | Findings | Is every declaration grounded in evidence? |
| **Flows** | North Star | Does every outcome have a process to make it real? |
| **Design** | Flows | Does the architecture handle every failure mode? |
| **Plans** | Design | Does every design section have plan coverage? |
| **Implementation** | Plans | Are the truth statements actually true? |

Errors caught at the north star level cost almost nothing to fix — you revise a sentence. The same error caught in production costs orders of magnitude more.

### Plans Are Disposable

Plans are the only ephemeral artifact. North stars, flows, and designs persist and evolve as the system evolves. Plans exist to close a specific gap and are deleted when that gap is closed.

### Changes Flow Through the Declaration

When behavior needs to change: update the declaration, make plans to close the gap, implement, delete plans. This prevents the most common failure mode: code that drifts from intent because changes are made directly and documentation is updated "later" (it isn't).

---

## Why This Works With Agents

The methodology separates human judgment from agent work:

**Agents**: exhaustive research, code verification, drafting documents, implementing plans, checking whether truth statements hold. They can read the entire declaration for context and make good implementation decisions — if the declaration is unambiguous.

**Humans**: declaring what great looks like, making trade-offs, evaluating whether outcomes match intent. These are judgment calls that can't be delegated.

Plans use truth statements because agents can verify truth. "The `generateMailingName` function returns a correctly formatted salutation from member names" is verifiable. "Make the salutation feature work well" is not.

---

## Summary

| Layer | Question | Permanence | Contains | Never Contains |
|-------|----------|------------|----------|----------------|
| **Findings** | What's true? | Permanent | Evidence from all sources | Recommendations |
| **North Star** | What should be true? | Permanent | Testable outcome declarations | Implementation |
| **Flows** | What must the system do? | Permanent | Processes, failure modes, 3rd-party specs | Your API/UX designs |
| **Design** | How could it be built? | Permanent | Contracts, architecture, verification | Implementation |
| **Plans** | What's not true yet? | Deleted when done | Truth statements, links to declaration | Implementation |
