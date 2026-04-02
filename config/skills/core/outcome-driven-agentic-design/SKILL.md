---
name: outcome-driven-agentic-design
description: Declare what the system should be before writing code. Use when building new features, redesigning feature areas, or making significant changes that need a declaration of intent. Guides the declaration chain from findings through plans.
tags: [methodology, declaration, north-star, flow, design, plan, findings, agentic]
zones: { wisdom: 35, knowledge: 30, process: 20, constraint: 15 }
---

# Outcome-Driven Agentic Design

Start from the outcomes that matter. Work back to code.

The declaration chain gets from "what should be true" to "what is true in the running system." Each layer increases resolution — from outcomes to processes to architecture to verifiable truth statements — with verification at every step that you are building the right thing.

The declaration IS the code, at the highest level of abstraction. The north star is the system zoomed all the way out. The design is the system at architectural resolution. The plans are the system at specification resolution. The implementation is the system at maximum magnification. They are the same thing at different zoom levels, and they stay in sync.

You build this with your stakeholders, not alone. You are drafter and scribe; they are the authority on what matters.

**Do not use plan mode.** The declaration chain IS the planning methodology. Plan mode adds a redundant "plan to write the plan" layer, and its rigid workflow conflicts with the iterative, stakeholder-driven pace of agreement. Start writing findings directly. The structure comes from the chain, not from a planning tool.

## Important

To use this methodology you MUST have the expertise stored in the **writing-documents** and **mermaid** skills - invoke them first.

---

## Capsule: DeclarationIsCode

**Invariant**
The declaration of intent is the source of truth; the implementation is the declaration at maximum magnification.

**Example**
The north star says "A group leader should see who attended last week without leaving the group page." The design specifies a cached attendance summary. The code implements it. These are not three separate artifacts — they are the same decision at three zoom levels. When they disagree, the higher level wins, or it needs updating first.
//BOUNDARY: The declaration wins. Never drift silently.

**Depth**
- Not documentation of the system. The definition of how the system should work.
- Findings through design are code at progressively higher abstraction
- Changes enter at the declaration layer and flow down, never the reverse
- SeeAlso: ChangesFlowDown

---

## The Declaration

Five layers. Each builds on the previous. First four are permanent; plans are ephemeral.

| Layer | Contains | Never Contains | Checked Against |
|-------|----------|----------------|-----------------|
| **Findings** | Evidence from all sources | Recommendations | Reality (code, telemetry, feedback) |
| **North Star** | Testable outcome declarations | Implementation details | Findings |
| **Flows** | Processes, actors, failure modes | Our API contracts, internal data structures | North Star |
| **Design** | Contracts, architecture, trade-offs | Implementation code | Flows |
| **Plans** | Truth statements (EARS syntax) | Implementation instructions | Design |

Plans are deleted when truth statements are realized. Everything else persists and evolves.

**Why findings come first**: Findings synthesize code, telemetry, customer feedback, market research, and institutional knowledge into a shared picture of what is true today. Without this, the north star is a wish list disconnected from reality.

**Flows boundary**: A flow can say "the parent selects which children to check in" (process). It cannot say "the `POST /checkin/batch` endpoint accepts a list of child IDs" (our API design). Third-party API specs are allowed in flows because they prove viability. One flow per file — flows are discussed individually, evolve at different rates, and are referenced independently by design sections.

**How to write each layer**: You do not know how to write these documents from memory. Invoke the `writing-documents` skill before writing each layer — it will load the guide, template, and exemplar for that document type. Read the guidance yourself; do not delegate skill reading to subagents. The rules in those guides are mandatory, not advisory.

---

## Capsule: AgreeThenShape

**Invariant**
North star and flows are agreement layers — write them, iterate with stakeholders, reach consensus before proceeding. Design and plans are shaping layers — they follow agreement, not drive it.

**Example**
Wrong: Create tasks for all five layers up front and race through them. The north star gets one pass, flows get skipped, design starts before anyone agreed on outcomes.
Right: Write findings. Draft north star, present it, revise it. Draft flows, present them, revise them. Only when stakeholders say "yes, that's what we want" do you proceed to design.
//BOUNDARY: Do not plan design and plans as tasks until the agreement layers are accepted. The scope and shape of design depends on what was agreed.

**Depth**
- North star and flows are often written days or weeks before design begins — they are where different disciplines reach alignment
- Creating a task list for the full chain up front creates urgency to finish rather than urgency to agree
- The agreement layers surface the hard questions: What outcomes matter? What processes exist? What failure modes must we handle? These answers reshape everything downstream.
- Design and plans are mechanical once agreement exists — they translate agreed outcomes into architecture and truth statements

---

## Capsule: StakeholdersAreSources

**Invariant**
The people in the room know things that are not written down; ask them before assuming.

**Example**
You draft a north star for check-in. The children's ministry director says "we also need to handle custody restrictions — some children can only be picked up by specific adults." This was not in any codebase, ticket, or telemetry. It was in her head. Without asking, the declaration would have been incomplete and every downstream layer wrong.
//BOUNDARY: Research what you can first. Then bring a draft and ask what's missing. Do not show up empty-handed.

**Depth**
- You are drafter and scribe. The stakeholders are the authority on intent, domain rules, edge cases, and what burns people who don't know.
- North stars and flows are especially iterative. Draft from findings, present to stakeholders, refine based on what they tell you. Multiple rounds are normal.
- Use `AskUserQuestion` actively during these layers. Do not wait until you have a finished document — surface your understanding early so misinterpretation is caught before it compounds.
- Good questions to ask: "Is this the right framing?", "What am I missing?", "Which of these outcomes matters most?", "What happens when this goes wrong?"
- Findings also benefit — stakeholders know history, past failures, and constraints that never made it into documentation. Ask about the why behind what you observe in code.

---

## When to Engage

| Signal | Approach |
|--------|----------|
| New feature area with complex processes | Full chain: Findings → North Star → Flows → Design → Plans |
| Redesign of existing feature | Start with Findings to establish current truth, then update declaration |
| Targeted improvement, north star clear | Abbreviated: Findings → Plans (skip layers that don't need updating) |
| Simple code fix, single behavior change | Just use plans |

---

## Capsule: ScaleToFit

**Invariant**
Skip layers that add no value; the methodology adapts to the complexity of the change.

**Example**
OCIA journey tracking: full chain (findings, north star, flows, design, 7 plans). Household salutation fix: findings and 2 plans. Both are correct.
//BOUNDARY: Skipping findings is almost never right. You need to know what is true before declaring what should be true.

**Depth**
- No north star needed when the vision is already clear
- No flows needed when there are no complex multi-step processes
- No design needed when the architecture does not change
- Ask: does this layer add clarity, or is it ceremony?
- You can suggest which layers to skip, but the stakeholder decides. If they want flows for something you think is simple, write the flows.

---

## Capsule: ErrorCorrectionChain

**Invariant**
Each layer is verifiable against its predecessor; errors caught early cost almost nothing to fix.

**Example**
North star says "parishes track OCIA journeys." Findings show process queues already exist. Grounded. But if the north star said "parishes track journeys with real-time GPS," findings would catch this immediately. One sentence revised vs. an architecture thrown away.
//BOUNDARY: Skip verification and errors compound silently into production.

**Depth**
- Agents can perform mechanical checks: does every declaration trace to a finding? Does every flow stage have a design response?
- The full verification protocol is in `references/verification.md`

---

## Capsule: BacktrackToFix

**Invariant**
When writing layer N reveals a problem in layer N-1, stop, fix N-1, re-verify, then resume N.

**Example**
Writing a flow for check-in, you realize the north star never declared what happens at pickup. Stop writing the flow. Add the pickup declaration to the north star. Verify it traces to findings. Resume the flow.
//BOUNDARY: Do not patch around the gap in the current layer. Fix it at the source.

**Depth**
- This is the most common real-world situation — writing a layer surfaces missing or wrong content above it
- Fixing upstream is cheap; working around it compounds into the design and plans
- The error-correction chain works in both directions: forward for verification, backward for discovery

---

## Capsule: TruthStatements

**Invariant**
Plans declare what must be true, not what must be done; agents verify truth.

**Example**
Plan: "The FileScanner shall classify files by comparing against stored hashes." Verifiable. Does it? Yes or no.
Not a plan: "Step 1: Create a file scanner. Step 2: Add hash comparison."
//BOUNDARY: If you cannot evaluate it as true or false in the running system, it is not a truth statement.

**Depth**
- EARS patterns for testable statements:

| Pattern | Template | Example |
|---------|----------|---------|
| Ubiquitous | The [system] shall [response] | The scanner shall compute SHA256 hashes |
| Event-driven | When [trigger], the [system] shall [response] | When a parent scans their QR code, the system shall display all eligible children |
| State-driven | While [state], the [system] shall [response] | While a journey is paused, the system shall prevent stage advancement |
| Optional | Where [feature], the [system] shall [response] | Where bulk check-in is enabled, the system shall pre-select all children |
| Unwanted | If [condition], then the [system] shall [response] | If a room reaches capacity, then the system shall suggest alternatives |

- Truth statements give agents an evaluation function, not a script
- The agent reads the full declaration for context and uses its own judgment for implementation
- Plans link back to which north star declarations, flow stages, and design sections they satisfy
- **Plan granularity**: scope a plan to one coherent piece of the design that can be implemented and verified independently. If truth statements span unrelated concerns, split into separate plans.

---

## Capsule: ChangesFlowDown

**Invariant**
When an existing declaration needs to change, enter at the highest affected layer, update downward, and make plans to close the gap.

**Example**
Business wants compute-with-override salutations. This changes what the system should do (north star), how it resolves salutations (flow), and the data model (design). Update the north star declaration. Update the flow. Update the design. Make plans for the delta between the updated declaration and current reality. Implement. Delete plans.
A performance optimization that changes only the design? Enter at design. Update design, make plans, implement.
//BOUNDARY: Never change code without updating the declaration first. Emergency fixes happen, but the declaration must be updated before the fix is considered complete.

**Depth**
- **Identify the entry point.** Not every change starts at the north star. A new outcome enters at north star. A process change enters at flows. A technical decision enters at design. Enter at the highest layer the change affects, then cascade down.
- **Update downward through each layer below the entry point.** If you changed the north star, check whether flows still serve every declaration. If you changed a flow, check whether the design handles the new stages and failure modes.
- **Make plans for the delta** between the updated declaration and current code. These are new plans — the gap between what the declaration now says and what the system currently does.
- **Stale plans get deleted.** If plans existed before the change and no longer match the updated declaration, delete them and write new ones from the current state. Do not patch old plans to fit new intent.
- **Re-verify the changed layer against the one above it.** The error-correction chain applies to changes, not just initial creation.

---

## Who Contributes Where

| Phase | Product | UX | Engineering |
|-------|---------|-----|-------------|
| **Agree** (North Star, Flows) | Goals, priorities | User journeys | Constraints, feasibility |
| **Shape** (Design, Plans / Visual Assets) | Reviews UX | Look and feel | Working functionality |
| **Polish** (Code) | -- | Real-time direction | Live iteration |
| **Verify** (Declaration) | -- | -- | Correctness against declaration |

---

## Worth Asking

Before starting:
- What is actually true right now?
- What should be true?
- What must the system do to make it true?
- Who knows things I cannot find in code, telemetry, or documentation?

During:
- Does this layer check out against the previous one?
- Am I putting the right content in the right layer?
- Would skipping this layer leave a gap, or remove ceremony?
- What does the stakeholder know that I don't? Have I asked, or am I assuming?

After:
- Are truth statements specific enough to verify?
- Is there plan coverage for everything the design describes?
- Can the plans be deleted when done without losing information?
- Has a stakeholder confirmed the declaration matches their intent?

---

## Boundaries

| Need | Go to |
|------|-------|
| How to write each layer | `writing-documents` skill |
| Verification protocol | `references/verification.md` |
| Worked example | Look for declaration chains in the current project |

---

*If the declaration and the code disagree, the declaration wins — or it needs updating first.*
