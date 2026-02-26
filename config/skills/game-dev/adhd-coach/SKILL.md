---
name: adhd-coach
description: Meta-cognitive support for ADHD+OCD during game development. Invoke when the user is stuck, looping, overwhelmed, paralysed, or burning energy on the wrong thing. Not clinical — practical frameworks for productive creative work.
zones: { knowledge: 15, process: 10, constraint: 10, wisdom: 65 }
---

# adhd-coach

Your brain is not broken. It has different fuel economics. Learn them.

---

## Capsule: EnergyEconomics

**Invariant**
ADHD brains don't have steady fuel. They have bursts and droughts. Plan for both.

**Example**
High-energy: core gameplay programming, creative problem-solving, prototyping new mechanics. Low-energy: organizing assets, writing commit messages, updating tickets, testing edge cases.
//BOUNDARY: This is self-knowledge, not an excuse. The work still needs doing — you're choosing WHEN, not WHETHER.

**Depth**
- Matching task to energy isn't laziness — it's engineering. A function runs where it's scheduled.
- High-energy windows are finite. Spending them on admin is waste. Spending them on the wrong creative task is also waste.
- Low-energy isn't zero-energy. It's the window for work that doesn't need spark.
- If you haven't had a high-energy window in days, something external needs attention. Sleep, food, medication, stress. The skill can't fix those.

---

## Capsule: TwoMinuteStart

**Invariant**
The hardest part is always starting. Commit to two minutes. Momentum is real.

**Example**
"I'll just open the project and read where I left off." Ten minutes later, you're refactoring a system. You didn't plan to — but starting gave permission to continue.
//BOUNDARY: If two minutes doesn't create momentum, the task may be wrong. Check: is it too big? Too vague? Too boring? Reframe before forcing.

**Depth**
- ADHD paralysis comes from the gap between "should do" and "want to do." Two minutes collapses the gap — it's small enough to not trigger resistance.
- The trick: commit to TWO MINUTES, not "I'll just do a little." The specificity matters. Vague commitments get vague resistance.
- If the two minutes genuinely don't create momentum, that's signal. The task needs breaking down, reframing, or deferring.
- SeeAlso: ContextBreadcrumbs (make starting easier by reducing context-rebuild cost)

---

## Capsule: HyperfocusLeverage

**Invariant**
Hyperfocus is the superpower. The question is never whether to use it — it's whether it's aimed at the right thing.

**Example**
Hyperfocusing on core gameplay mechanics: productive. Hyperfocusing on pixel-perfect menu animations before the game is fun: seductive but wasteful.
//BOUNDARY: Don't interrupt hyperfocus to evaluate it. Set direction BEFORE entering, not during.

**Depth**
- Hyperfocus follows interest, not priority. This is why pre-session direction matters.
- Interrupting hyperfocus to ask "is this the right thing?" destroys the state without answering the question. The answer is: decide before you start, then trust the decision.
- When hyperfocus lands on the wrong thing, don't guilt-trip afterward. Note what pulled you in (it reveals what interests you) and set clearer direction next time.
- Hyperfocus has a hangover. The crash afterward is real. Plan for it — don't schedule critical work in the hours after a deep session.

---

## Capsule: ShinyObjectFilter

**Invariant**
New ideas are not the enemy. Chasing them is. Capture, don't chase.

**Example**
Mid-session: "What if the game had a crafting system?" Write it in the ideas backlog. Don't open a new branch. Don't research crafting systems. Don't redesign the GDD. Write it down and return to the current task.
//BOUNDARY: If the new idea genuinely invalidates current work, that's a decision — invoke decision-journal, not impulse.

**Depth**
- ADHD brains generate ideas faster than any brain can execute them. This is a feature, not a bug — but only if you have a capture system.
- The capture system must be frictionless. A text file, a Plane ticket, a voice memo. Not a formatted design document.
- The ideas backlog is reviewed during planning, not during building. Mixing these modes is how scope creeps.
- Some ideas will feel urgent. They almost never are. If it's truly urgent, it will still be urgent after you finish the current task.
- SeeAlso: scope-guardian (future skill)

---

## Capsule: PerfectionTrap

**Invariant**
OCD says "it must be right." The project says "it must exist." Existing beats perfect every time.

**Example**
"I can't commit this code until I've handled every edge case." But the feature doesn't work at all yet. Handle the happy path first. Edge cases are future work.
//BOUNDARY: This doesn't mean ship garbage. It means match quality to stage. Prototype quality for prototypes. Polish for release.

**Depth**
- Perfectionism disguises itself as quality. The test: is this making the thing better for the player, or making you feel better about the code?
- OCD re-checking is the most expensive form. Re-reading code you just wrote. Re-running tests that just passed. Re-researching a decision you just made. Each feels productive; none are.
- The decision-journal exists precisely for this. "I already decided this. The revisit trigger hasn't been met." That sentence is worth its weight in gold.
- Quality has diminishing returns. The jump from 0% to 80% is where the value lives. The jump from 80% to 95% costs 3x as much and the player may not notice.
- SeeAlso: DecisionAmnesia (decision-journal), RevisitTrigger (decision-journal)

---

## Capsule: ContextBreadcrumbs

**Invariant**
Future-you will not remember where present-you left off. Leave breadcrumbs before you stop.

**Example**
End of session: "Working on player movement. Jump feels floaty — next session: increase gravity multiplier and test. The relevant file is player_controller.gd line 47."
//BOUNDARY: Breadcrumbs are 2-3 sentences, not a status report. If it takes more than 30 seconds to write, you're over-documenting.

**Depth**
- Context rebuild is the hidden cost of ADHD. The 30 minutes spent remembering where you were could have been 30 seconds of reading a note.
- Breadcrumbs go at session end, not session start. You know the most right before you stop.
- Good breadcrumb: what you were doing, what's next, where to look.
- Bad breadcrumb: what you did today (that's a log, not a breadcrumb).
- The two-minute start becomes a ten-second start when there's a breadcrumb waiting.

---

## Capsule: DecisionClosure

**Invariant**
A made decision is worth more than an optimised decision. Close the loop and build.

**Example**
"Godot or Unity?" If research shows both work: pick one. The time spent agonising between two adequate options exceeds the cost of picking the slightly-less-optimal one.
//BOUNDARY: This applies to decisions between adequate options. If research reveals a clear winner, this isn't needed.

**Depth**
- ADHD+OCD creates a perfect storm for decision paralysis. ADHD generates options; OCD evaluates them endlessly.
- The cost of delay is always higher than the cost of a suboptimal choice between adequate options. You can't build in either engine while you're comparing them.
- "Satisficing" (good enough) beats "maximising" (best possible) for 90% of decisions. Reserve maximising for decisions with irreversible, high-cost consequences.
- Decision-journal's revisit triggers give you the safety net. "I can revisit this IF [specific condition]." That conditional permission is what lets you close the loop.
- SeeAlso: RevisitTrigger (decision-journal)

---

## For AI Assistants

When you notice these patterns, gently intervene:

| Pattern | What You See | What to Say |
|---------|-------------|-------------|
| Decision loop | Same question researched twice | "This was decided in [entry]. The revisit trigger is [X]. Has that been met?" |
| Perfectionism | Refining before the thing works | "Does this need to be polished now, or does it need to work first?" |
| Scope creep | New feature mid-sprint | "Interesting idea. Want me to capture it in the backlog for later?" |
| Task paralysis | Long pause, no action | "What's the smallest thing you could do in two minutes?" |
| Wrong-target hyperfocus | Deep work on low-priority item | (Don't interrupt. At session end: "You went deep on [X] today. What pulled you in? Should we adjust tomorrow's direction?") |
| Energy mismatch | Forcing creative work while drained | "This might be a good time for [low-energy task] instead." |
| Re-checking | Re-running tests, re-reading code | "These tests passed 2 minutes ago. What changed?" |

**Tone matters.** These are observations, not accusations. Curiosity, not correction. "I notice..." not "You shouldn't..."

**Timing matters.** Don't interrupt flow state. Don't coach during hyperfocus. The best time is: session start (direction), session end (breadcrumbs), or when explicitly asked.

---

## Deeper

- The `decision-journal` skill — Primary tool for breaking decision loops
- The `sprint-manager` skill — Task sizing for ADHD attention patterns
- `references/session-patterns.md` — Practical patterns for structuring work sessions

---

*Your brain has different fuel economics. Learn them, work with them, build the game.*
