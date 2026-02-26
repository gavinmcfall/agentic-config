---
name: session-planner
description: Start-of-session and end-of-session rituals. Use at the beginning or end of any game dev work session. Bridges adhd-coach energy patterns with sprint-manager tickets. Collapses the gap between sitting down and building.
zones: { knowledge: 20, process: 35, constraint: 15, wisdom: 30 }
---

# session-planner

The hardest part is the first 60 seconds. Make those automatic.

---

## Capsule: SessionRitual

**Invariant**
A ritual is valuable because it's automatic. You don't decide to do it — you just do it. The ritual removes the "what should I do?" gap that ADHD exploits.

**Example**
Sit down. Read breadcrumb. Check energy. Pick ticket. State goal. Start. — This sequence takes 90 seconds and eliminates 30 minutes of drift.
//BOUNDARY: If the ritual itself becomes a source of friction (too many steps, takes too long), simplify it. Two steps is better than five steps you skip.

**Depth**
- The ritual is not planning. Planning happened during sprint planning. The ritual is executing: translating the plan into action for this specific session.
- Rituals work because they bypass decision-making. ADHD decision fatigue means every choice costs energy. The ritual removes choices.
- The end ritual is as important as the start. Without breadcrumbs, the next session's start ritual fails.

---

## Start Ritual

When you sit down to work:

### 1. Read the Breadcrumb (10 seconds)

Check the last breadcrumb. It tells you: what you were doing, what's next, where to look.

**If there's no breadcrumb**: scan the last 3 git commits and your Plane board. Pick the most obvious thing.

**Returning after a gap** (3+ days away from this project): spend 5 extra minutes. Read the last few commit messages, scan open tickets, re-read the project README. You're rebuilding context, not starting from scratch — the breadcrumbs from your last session and the codebase itself will bring you back faster than you expect.

### 2. Check Energy (5 seconds)

How do you feel right now? Be honest.

| Level | Feels Like |
|-------|------------|
| **High** | Alert, focused, ideas flowing. Want to build. |
| **Medium** | Functional but not sharp. Could work but not create. |
| **Low** | Tired, foggy, distracted. Here but barely. |
| **None** | Shouldn't be here. Go rest. (See: The Break in adhd-coach) |

### 3. Pick a Ticket (30 seconds)

Match ticket to energy:

| Energy | Pick a ticket that is... |
|--------|--------------------------|
| High | High-energy, core to the game. S or M sized. |
| Medium | Medium complexity. Bug fixes, feature polish, learning. |
| Low | Low-energy. Chores, ticket updates, file organization. |

**If nothing matches**: either the sprint needs rebalancing (talk to sprint-manager) or today is a Break day (talk to adhd-coach).

**If there's no sprint** (first session, or you've been learning all week): pick one small, concrete thing you can finish today. Create an ad-hoc ticket if needed. Don't let the absence of a formal sprint stop you from building.

### 4. State the Goal (15 seconds)

Say it out loud or type it: "This session, I'm going to [one specific thing]."

Not: "Work on the game."
Not: "Make progress."
Yes: "Get the player to jump and land with correct gravity."
Yes: "Complete chapter 2 of the GDScript course and build a practice scene."

### 5. Start (Two-Minute Rule)

Open the relevant file. Read the first line. Make one change. Momentum follows.

If it doesn't: the task is wrong. Check adhd-coach's TwoMinuteStart boundary — is the task too big, too vague, or too boring?

---

## End Ritual

When you're done (by choice, by energy, or by time):

### 1. Commit (30 seconds)

```
git add [files] && git commit -m "WIP: [what you did]"
```

WIP commits are fine. Lost work is not. Commit even if it's broken.

### 2. Write Breadcrumbs (30 seconds)

Three things:
- **What you were doing**: "Working on jump physics"
- **What's next**: "Gravity feels too floaty — increase multiplier"
- **Where to look**: "player_controller.gd line 47"

Store breadcrumbs where you'll find them: a `BREADCRUMBS.md` in the project root, a pinned Plane comment, or the last commit message.

### 3. Update Ticket (15 seconds)

Move the Plane ticket to reflect current state:
- Still working → leave In Progress
- Done → move to Done, celebrate
- Blocked → add a comment explaining why

---

## Session Shapes (Quick Reference)

From adhd-coach's session-patterns, matched to this ritual:

| Shape | Energy | Duration | Start Ritual Emphasis |
|-------|--------|----------|-----------------------|
| Sprint | High | 1-4 hours | Set direction firmly. Protect the session. |
| Wander | Medium | 1-2 hours | Loose goal is fine. "Explore [area]." |
| Tidy | Low | 30-60 min | Pick low-energy tickets. Don't force creativity. |
| Break | None | 0 | Skip the ritual. Go rest. |

---

## For AI Assistants

When a session starts:

1. **Ask about breadcrumbs**: "Do you have a breadcrumb from last session?" If yes, read it. If no, help reconstruct context from recent commits.
2. **Ask about energy**: "How's your energy right now?" Match to session shape.
3. **Suggest a ticket**: Based on energy + sprint contents + breadcrumb direction.
4. **Help state the goal**: Compress their intention into one sentence.
5. **Get out of the way**: The ritual is done. Let them build.

When a session ends:

1. **Prompt the commit**: "Want to commit what you have?"
2. **Write breadcrumbs together**: "What were you working on? What's next? Where should you look?"
3. **Prompt ticket update**: "Should we move [ticket] to Done, or leave it In Progress?"

**The whole ritual should take under 2 minutes.** If you're spending longer, you're over-planning. The session-planner's job is to get the user building, not to plan what they build (sprint-manager does that).

---

## Constraints

- Start ritual: under 2 minutes total
- End ritual: under 2 minutes total
- Never skip the end ritual, even if the session was short
- If there's no breadcrumb, don't panic — reconstruct from commits
- If energy is None, don't start. Rest is productive.

---

## Deeper

- The `adhd-coach` skill — Energy patterns, session shapes, breadcrumbs
- The `sprint-manager` skill — Ticket selection and sprint context
- The `scope-guardian` skill — Am I working on what matters?

---

*Sit down. Read breadcrumb. Check energy. Pick ticket. State goal. Start.*
