---
name: scope-guardian
description: Protect project scope at every level — feature, sprint, and project. Use when evaluating new ideas, reviewing the backlog, assessing project size, or when the game's vision has grown beyond what one person can build. The external "no" that ADHD needs.
zones: { knowledge: 15, process: 15, constraint: 40, wisdom: 30 }
---

# scope-guardian

The game you ship beats the game you imagine. Ruthlessly.

---

## Capsule: CoreTest

**Invariant**
Every feature must answer: "Can this be cut without ruining the game?" If yes, it's not core.

**Example**
A roguelike needs: procedural levels, combat, permadeath. A roguelike does NOT need: crafting, base building, multiplayer, leaderboards, achievements, cutscenes. Those are all nice. None are the game.
//BOUNDARY: "Core" means the game doesn't exist without it. Not "the game is worse without it" — that's "important," not "core."

**Depth**
- Core features for a solo dev first game: aim for 3-5. If your core list has 10 items, you haven't been ruthless enough.
- The test works recursively. Within each core feature, apply it again: what's the minimum viable version of this feature?
- This is the hardest discipline in game dev. Everything feels core when you're excited about it. Time is the revealer — if you still think it's core after a week, it might be.

---

## Capsule: ScopeLevels

**Invariant**
Every feature, asset, and piece of content belongs to exactly one level. The levels determine what gets built and in what order.

**Example**
For a 2D roguelike:
- **Core**: Player movement, combat, procedural dungeon, permadeath, 3 enemy types
- **Important**: Sound effects, 5 more enemy types, item system, boss fights
- **Nice to have**: Achievements, leaderboards, daily challenges, character customization
- **Out of scope**: Multiplayer, 3D, mobile port, modding support
//BOUNDARY: Moving a feature UP a level requires removing something else at that level or cutting from the level below.

**Depth**
- "Out of scope" is the most important level. It's an explicit "no" that prevents future re-evaluation. Record it in the decision-journal with a revisit trigger.
- Important features are the negotiation space. When behind schedule, cut from here first.
- Nice-to-have is the ideas backlog. Review during planning, never during building.
- The levels should be written down and visible. When someone (including you) suggests a feature, check which level it belongs to.

---

## Capsule: ContentBudget

**Invariant**
Scope isn't just features. It's also how much content each feature requires. A "simple inventory system" with 200 items is not simple.

**Example**
"The game has enemies" is a feature. "The game has 50 unique enemies each with distinct sprites, animations, behaviors, and sound effects" is a content commitment. One is a week of work. The other is months.
//BOUNDARY: Budget content in the same way you budget features. Ask: what's the minimum number of [enemies/levels/items/etc.] needed for the game to feel complete?

**Depth**
- Solo dev content budgets should shock you with how small they are. Vampire Survivors launched with ~20 weapons. Undertale has ~20 unique enemies. Celeste has ~8 mechanics.
- Content scales linearly with time. 10 enemies takes 10x longer than 1 enemy. There are no shortcuts except reducing the count.
- Art assets are the most expensive content. Each unique sprite, each animation frame, each UI element takes time. Budget accordingly.
- Audio is cheaper per unit but adds up. Budget sound effects per interaction type, not per entity.

---

## Capsule: ShipDate

**Invariant**
A game without a target ship date will expand to fill all available time. Set one, even if it moves.

**Example**
"I'll ship when it's ready" → never ships. "I'll ship a playable demo by December" → makes scope decisions concrete. Every new feature competes against the date.
//BOUNDARY: The date can move. That's fine. The point is that it EXISTS, creating pressure that forces scope decisions. Without it, every feature is "eventually."

**Depth**
- A target date is a scope enforcement tool, not a commitment. It answers: "Given this date, can I afford this feature?"
- ADHD responds to deadlines — but only real ones. A self-imposed date you don't believe is meaningless. Tie it to something external: a game jam submission, a store page going live, showing a friend.
- The date doesn't have to be the final release. It can be: playable prototype, demo, alpha, beta. Intermediate milestones are more useful than a distant launch date.
- SeeAlso: DecisionClosure (adhd-coach) — a date forces decisions that would otherwise loop forever

---

## Scope Evaluation Process

When a new feature or idea appears:

### 1. Apply the Core Test

"Can this be cut without ruining the game?"
- **Yes** → It's not core. Move to step 2.
- **No** → It's core. It stays. But apply the test to its sub-features too.

### 2. Assign a Level

| Level | Criteria | Action |
|-------|----------|--------|
| Important | Makes the game notably better | Add to backlog with scope level label |
| Nice to have | Would be cool | Add to ideas backlog |
| Out of scope | Doesn't fit, too expensive, or wrong game | Record in decision-journal with "out of scope" |

### 3. Check the Budget

If Important:
- What does this feature cost in time? (Rough: S/M/L/XL)
- What content does it require? (sprites, levels, sounds, etc.)
- Does adding this push past the target date?
- If yes: what gets cut to make room?

### 4. Record the Decision

- If kept: scope level label in Plane
- If cut: decision-journal entry with revisit trigger ("revisit if the game feels empty without it after playtesting")
- If out of scope: decision-journal entry with firm "no" and rationale

---

## Scope Review Cadence

### Monthly: Scope Check (30 min)

1. **Core list**: Is it still 3-5 features? Has anything crept in?
2. **Important list**: Is it growing? Anything that should be cut or moved to Nice-to-have?
3. **Content budget**: Are art/content commitments realistic for the target date?
4. **Target date**: Still realistic? If not, what scope reduces to make it realistic?

### Per-Sprint: Quick Check

During sprint planning (sprint-manager):
- Are sprint tickets aligned with Core and Important features?
- Is anyone working on Nice-to-have while Core is incomplete?
- Has anything been added without something being removed?

---

## For AI Assistants

When the user proposes a new feature:
1. **Apply the Core Test**: "Can the game ship without this?"
2. **Assign a level**: "This sounds like [Important/Nice-to-have]. Want to add it to the [backlog/ideas list]?"
3. **Check the budget**: "Adding this would mean [X more sprites/levels/etc.]. Is that worth it given your timeline?"
4. **Enforce scope-in/scope-out**: "If this goes in, what comes out?"

When the game's scope feels too big:
1. **List the Core features**: "Let's check — what are the 3-5 things that make this game this game?"
2. **Challenge each one**: "Is [X] truly core, or is it Important?"
3. **Count content**: "How many unique [enemies/levels/items] are you committed to? What's the minimum that feels right?"

**Tone**: Direct but not dismissive. The user's ideas are good — the question is timing, not quality. "Great idea. Is it for v1.0 or post-launch?"

---

## Constraints

- Core features: 3-5 maximum. If your list is longer, you haven't been ruthless.
- Every "in" requires an "out" (or a date extension acknowledged)
- Out-of-scope decisions are recorded in decision-journal, not just forgotten
- Content budgets are explicit: count the assets, don't estimate them
- Never work on Nice-to-have while Core is incomplete

---

## Deeper

- The `adhd-coach` skill — ShinyObjectFilter for in-the-moment capture
- The `sprint-manager` skill — Sprint-level scope enforcement
- The `decision-journal` skill — Recording scope decisions with revisit triggers
- The `game-research` skill — Research on what's realistic for solo devs

---

*The game you ship beats the game you imagine. Cut until it hurts, then ship.*
