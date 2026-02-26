# Session Patterns

Practical patterns for structuring work sessions. Not a rigid system — a menu of options to match your energy and context.

---

## Session Start

**What's the goal?** One sentence. Not "work on the game" — "get player jump feeling right."

**What energy level?** High, medium, or low. Be honest. Match the task.

| Energy | Good For | Bad For |
|--------|----------|---------|
| High | Core mechanics, creative problem-solving, prototyping, learning new concepts | Admin, polishing, documentation |
| Medium | Feature implementation, bug fixing, asset creation, testing | Novel architecture, learning from scratch |
| Low | Organizing files, updating tickets, reviewing code, writing breadcrumbs | Anything requiring creative spark |

**Where did you leave off?** Read the breadcrumb. If there isn't one, spend 5 minutes scanning recent commits and open tickets before diving in.

---

## Session Shapes

### The Sprint (High Energy, 1-4 hours)

You're locked in and the problem is clear. Protect this.

- Set direction before entering: what are you building?
- Close distractions (notifications, unrelated tabs)
- Don't check Plane/tickets mid-session — you already know the task
- When new ideas appear: write one line in the ideas backlog, return immediately
- When finished or energy drops: write breadcrumbs, commit, stop

### The Wander (Medium Energy, 1-2 hours)

Energy is fine but focus is loose. Use this for exploration.

- Good for: trying approaches, reading docs, prototyping throwaway ideas
- Keep a scratch file for notes
- Set a timer if wandering feels unproductive after 30 minutes
- Outcome: either you found something useful (record it) or you didn't (that's fine, stop)

### The Tidy (Low Energy, 30-60 minutes)

Energy is low but you want to contribute. Do the work that doesn't need spark.

- Update Plane tickets with status
- Organize asset folders
- Write or update breadcrumbs
- Review and close stale ideas
- Run tests and fix simple failures
- Commit work-in-progress with clear messages

### The Break (No Energy)

Not every day has a session. That's fine.

- Don't force it. Forced low-energy sessions produce guilt, not progress.
- If breaks extend beyond a week, check: is the project still interesting? Is something blocking you externally? Is it just ADHD boredom that will pass?
- The project will be there tomorrow. The breadcrumbs will help you restart.

---

## Session End

Every session ends with:

1. **Commit** what you have, even if incomplete. WIP commits are fine. Lost work is not.
2. **Breadcrumbs**: 2-3 sentences. What were you doing? What's next? Where to look.
3. **Ticket update** (if applicable): move the Plane ticket to reflect current state.

This takes 2 minutes. It saves 30 minutes next session.

---

## When You're Stuck

Stuck is a state, not a personality. Diagnose before treating.

| Symptom | Likely Cause | Try This |
|---------|-------------|----------|
| Can't start | Task too big or vague | Break it down. What's the two-minute version? |
| Started but lost | Direction unclear | Re-read the breadcrumb or ticket. What were you trying to achieve? |
| Going in circles | Problem too hard for current approach | Step back. Explain the problem to Claude. Or leave it and come back fresh. |
| Everything feels wrong | Perfectionism / OCD | Ship the ugly version. Fix it later. The ugly version teaches more than the imagined perfect one. |
| New idea won't stop | Shiny object | Write it down. Set a 5-minute timer. If you're still thinking about it after 5 minutes, create a Plane ticket and explicitly defer it. |
| Bored | Task is boring | Is there a more interesting way to do it? Can you automate it? If not, it's a Tidy task — save it for low energy. |

---

*Match the work to the energy. Match the energy to the session. Leave breadcrumbs.*
