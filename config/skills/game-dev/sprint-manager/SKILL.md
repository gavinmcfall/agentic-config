---
name: sprint-manager
description: Solo dev sprint planning and task management with Plane. Use when planning sprints, sizing tasks, managing the backlog, or structuring work for ADHD productivity patterns. Not Agile — solo dev workflow.
zones: { knowledge: 35, process: 30, constraint: 15, wisdom: 20 }
---

# sprint-manager

Agile is for teams. You need the planning, not the ceremony.

---

## Capsule: SoloSprint

**Invariant**
A sprint for one person is a commitment device, not a process artifact. It answers: "what will I build this week?"

**Example**
Monday: pick 3-5 tickets sized S or M. Friday: review what got done. No standup, no retro, no velocity tracking. Just: did the things I planned get built?
//BOUNDARY: If a sprint becomes a source of guilt rather than focus, shorten it or simplify it. The sprint serves you, not the other way around.

**Depth**
- One week sprints. Two weeks is too long for ADHD — the deadline doesn't feel real until day 13.
- Sprint planning takes 15-30 minutes maximum. If it takes longer, the backlog needs grooming, not the plan.
- Never plan more than 70% capacity. ADHD brains need slack for the unexpected hyperfocus session or the unexpected energy drought.
- A sprint with 1 completed ticket beats a sprint with 5 planned and 0 completed.

---

## Capsule: TaskSizing

**Invariant**
If a task can't be completed in a single work session, it's too big. Break it down.

**Example**
Too big: "Implement player movement." Right size: "Player moves left/right with arrow keys." Even smaller: "Player sprite renders on screen."
//BOUNDARY: Some tasks genuinely span sessions (art creation, complex systems). Mark these explicitly as multi-session and define session-sized checkpoints.

**Depth**
- Use T-shirt sizes, not hours. ADHD makes time estimation unreliable.
  - **S**: One focused session (1-2 hours). Clear start and end.
  - **M**: Half a day. May need one break. Still clear done criteria.
  - **L**: Full day or multi-session. Must be breakable into S/M subtasks.
  - **XL**: Too big. Break it down before it enters a sprint.
- The definition of "done" must be concrete. Not "player movement works" but "player moves left/right, stops at screen edges, animation plays."
- When breaking down an L, the first subtask should be the one that proves the approach works. Build confidence early.

---

## Plane Setup

### Recommended Project Structure

```
Workspace: Game Dev
├── Project: [Game Name]          ← the game itself
├── Project: Learning             ← boot.dev courses, tutorials
└── Project: Infrastructure       ← k8s, tools, pipeline
```

### Workflow States

Keep it simple. More states = more overhead.

| State | Meaning |
|-------|---------|
| **Backlog** | Captured but not committed to |
| **Sprint** | Committed for this sprint |
| **In Progress** | Actively working on it |
| **Done** | Meets the definition of done |

That's four states. Resist adding more. "Blocked," "In Review," and "QA" are team concepts. If you're blocked, add a comment and move on. If it needs review, review it yourself and mark done.

### Labels

Labels serve two purposes: filtering and energy matching.

| Label Category | Values | Purpose |
|---------------|--------|---------|
| **Size** | S, M, L | Sprint planning capacity |
| **Energy** | high-energy, low-energy | Match to session type (see adhd-coach) |
| **Domain** | gameplay, art, audio, engine, tools, learning | Filter by what you're working on |

### Modules

Use modules to group related issues that span multiple sprints:

- "Core Movement System" — all tickets related to player movement
- "Main Menu" — all UI/UX tickets for the menu
- "Chapter 1" — all content for the first chapter

Modules give you a cross-sprint view of feature progress.

---

## Sprint Cadence

Pick a consistent day to plan and a consistent day to review. Monday/Friday works for a standard week; adjust to match your actual schedule. The rhythm matters more than the specific days.

### Start of Week: Plan (15-30 min)

1. Review last sprint: what got done? What didn't? (No guilt — just data.)
2. Move incomplete tickets: back to backlog or into new sprint.
3. Pick 3-5 tickets from the backlog. Mix of sizes and energy levels.
4. Ensure at least one "quick win" (S-sized, low-energy) for momentum.
5. Total planned work should feel slightly easy, not ambitious. Under-commit.

### During the Week: Build

- Pick tickets based on current energy (see adhd-coach session patterns)
- Move tickets to "In Progress" when starting, "Done" when done
- New ideas → backlog ticket, not sprint addition
- If you finish everything early: pull ONE more ticket, or enjoy the slack

### End of Week: Review (10 min)

- What got done? Celebrate it. Literally. ADHD brains need the reward signal.
- What didn't? Why? (Too big? Wrong energy? Life happened? No judgment.)
- Any tickets that have been in backlog for 4+ weeks? Either commit or delete.
- Write a breadcrumb for next-week-you: "The game is at [state]. Next week focus on [area]."

---

## Backlog Health

A healthy backlog is small and current. An unhealthy backlog is a graveyard of good intentions.

### Grooming Rules

- **Maximum 30 tickets** in the active backlog. If you have more, prune.
- **Prune monthly**: Delete or archive anything you wouldn't do in the next month.
- **Ideas backlog is separate**: Captured ideas (from ShinyObjectFilter) live in a separate view or label. They don't count toward the 30.
- **Each ticket has a definition of done**: If it doesn't, it's not ready for a sprint.

### When Decisions Create Work

A decision-journal entry often creates tickets:

1. Decision: "Use Godot 4"
2. → Ticket: "Complete boot.dev Godot fundamentals course" (Learning project)
3. → Ticket: "Set up Godot project structure with version control" (Game project)
4. → Ticket: "Build hello-world prototype in Godot" (Game project)

Create these tickets when the decision is recorded. They're the bridge between deciding and doing.

---

## Constraints

- Never plan more than 70% capacity. Leave room for life and ADHD.
- Never add tickets to an active sprint without removing one. Scope in = scope out.
- Never use hour estimates. T-shirt sizes only.
- Every ticket needs a concrete "done" definition before entering a sprint.
- Sprint planning is time-boxed to 30 minutes. If you're not done, the backlog needs grooming.

---

## For AI Assistants

When helping with sprint management:

**Creating tickets:**
- Default to S-sized. If the user describes something bigger, help break it down.
- Always include a definition of done. Ask: "How will you know this is finished?"
- Suggest an energy label. "This sounds like high-energy creative work" or "This is a good low-energy task."

**Sprint planning:**
- Count the sizes: 3S + 1M = roughly right for a week. 2L + 3M = too much.
- Ensure energy mix: at least one low-energy ticket for drained days.
- Check for dependencies: does ticket B need ticket A? Order accordingly.

**When the user wants to add mid-sprint:**
- "That's interesting. Want to add it to the backlog for next sprint, or swap it with something in the current sprint?"
- Never just add it. The constraint is: scope in = scope out.

**Sprint review:**
- Celebrate completions. "You shipped [X] this week. That's real progress."
- Normalize incomplete sprints. "3 out of 5 is solid. The other 2 carry forward."
- Look for patterns: always finishing S but never M? Tasks might need different sizing.

---

## Deeper

- The `adhd-coach` skill — Energy patterns and session shapes for task matching
- The `decision-journal` skill — Decisions that create sprint tickets
- `references/ticket-templates.md` — Templates for common ticket types

---

*Plan the week. Build the thing. Celebrate what got done.*
