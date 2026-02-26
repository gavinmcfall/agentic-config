---
name: gdd-writer
description: Write and maintain Game Design Documents for solo dev projects. Use when starting a new game concept, after prototyping reveals design changes, or when the game's vision needs clarifying. Keeps the GDD lean, living, and connected to actual development.
zones: { knowledge: 25, process: 25, constraint: 15, wisdom: 35 }
---

# gdd-writer

A GDD for one person isn't communication — it's memory. Write what future-you needs to remember.

---

## Capsule: LivingDocument

**Invariant**
A GDD written before prototyping is a hypothesis. A GDD updated after prototyping is a plan. Treat them differently.

**Example**
Pre-prototype GDD: "The core loop is explore → fight → loot → upgrade." Post-prototype GDD: "The core loop is explore → fight → loot → upgrade. Fights last 15-30 seconds. Looting is automatic (manual looting tested poorly in prototype 2)."
//BOUNDARY: "Living" means it evolves with evidence. It does not mean "change it whenever you feel like it." Changes should be prompted by prototyping results, playtesting feedback, or scope decisions — not whims.

**Depth**
- The GDD has two phases: **hypothesis** (before you've built anything) and **plan** (after prototyping confirms the design)
- Hypothesis-phase sections are allowed to be vague. "Combat should feel crunchy" is a valid hypothesis. After prototyping, it becomes: "Combat uses screen shake (3px, 100ms), hit pause (50ms), and particle burst on contact."
- Every GDD update should reference what caused the change: "Updated after prototype 3 showed that..."

---

## Capsule: DesignPillars

**Invariant**
Design pillars are feelings, not features. They answer "what should the player experience?" not "what systems should the game have?"

**Example**
Pillar: "Every run tells a story." This pillar says yes to emergent narrative, varied encounters, and memorable moments. It says no to repetitive grinding, identical runs, and purely mechanical optimization.
//BOUNDARY: 3-5 pillars maximum. More than 5 means some aren't real pillars — they're features disguised as pillars.

**Depth**
- Pillars are decision filters. When evaluating a feature idea: "Does this serve at least one pillar?" If no, it's out of scope.
- Pillars don't change after early prototyping confirms them. If a pillar needs to change, that's a major design decision — record it in decision-journal.
- Good pillars are specific enough to say "no" to things. "Fun gameplay" is not a pillar. "Combat that rewards positioning over stats" is.

---

## GDD Structure

### Phase 1: Minimum Viable GDD (Before Prototyping)

Write this before you build anything. It takes 30-60 minutes.

#### 1. Vision Statement (2-3 sentences)

What is this game? Who is it for? Why will they play it?

```
[Game Name] is a [genre] where the player [core verb].
The experience is [feeling/mood]. Think [reference game A]
meets [reference game B].
```

#### 2. Design Pillars (3-5)

Each pillar is one sentence describing a feeling or experience the game MUST deliver.

#### 3. Core Loop

What does the player do?

| Timeframe | Activity |
|-----------|----------|
| **30 seconds** | The moment-to-moment action (move, shoot, dodge) |
| **5 minutes** | The short-term goal (clear a room, solve a puzzle) |
| **30 minutes** | The session-level goal (complete a floor, finish a run) |
| **Multiple sessions** | The long-term pull (unlock new characters, see new areas) |

#### 4. Scope Definition

Map directly from scope-guardian:

| Level | Features |
|-------|----------|
| **Core** (must ship) | 3-5 features max |
| **Important** (should ship) | Features that significantly enhance core |
| **Nice-to-have** | Would be great, but can cut without ruining the game |
| **Out of scope** | Explicitly not building for v1.0 |

#### 5. Art Direction (Brief)

Mood, visual style, reference images or games. Not asset lists.

#### 6. Technical Constraints

Engine, target platform(s), minimum spec, known limitations.

---

### Phase 2: Expanding the GDD (After Prototyping)

Add these sections only after prototypes validate the core design. Each section earns its place by answering a real development question.

| Section | Add When | Answers |
|---------|----------|---------|
| **Player Mechanics** | Core loop prototype works | Exactly how does movement/combat/interaction work? |
| **Content Structure** | Scope is locked | How many levels/areas/runs? What's the progression? |
| **UI/UX Flow** | Core mechanics feel right | How does the player navigate menus, HUD, inventory? |
| **Audio Direction** | Art direction is established | What mood does sound reinforce? References. |
| **Enemy/NPC Design** | Combat prototype works | Types, behaviors, difficulty curve |
| **Progression System** | Session loop is validated | How does the player grow across sessions? |

**Don't write sections you don't need yet.** An empty section is better than a speculative one.

---

## Writing GDD Sections

### Rules

- **Present tense**: "The player moves with WASD" not "The player will move with WASD"
- **Specific over vague**: "3 enemy types in v1.0" not "various enemies"
- **Reference decisions**: "Chosen because [decision-journal entry]" or "Validated by prototype [N]"
- **Mark hypotheses**: Before prototyping confirms something, mark it: `[HYPOTHESIS]`
- **Maximum section length**: No section should exceed one screen of text. If it does, it needs splitting or pruning.

### Anti-Patterns

| Don't | Why | Instead |
|-------|-----|---------|
| Write 50+ pages | Solo dev wastes time writing, then ignores it | Keep it under 10 pages total |
| Describe features you haven't prototyped | Speculation becomes commitment | Mark as `[HYPOTHESIS]` or omit |
| Include implementation details | That's code, not design | "Combat feels weighty" not "apply 3-frame hitstop on collision event" |
| Copy from genre templates | Your game isn't generic | Write what YOUR game does differently |
| Freeze the document | Design evolves | Update after every significant prototype or playtest |

---

## GDD Maintenance

### When to Update

| Trigger | What to Do |
|---------|------------|
| Prototype completed | Update relevant sections with findings. Convert hypotheses to facts. |
| Scope decision made | Update scope table. Adjust section detail accordingly. |
| Playtest feedback | Note what worked/didn't. Adjust design if warranted. |
| Major pivot | Rewrite affected sections from scratch. Record in decision-journal. |
| Monthly review | Read the whole GDD. Does it still match what you're building? |

### Version Snapshots

At major milestones (post-prototype, pre-alpha, beta), save a snapshot:

```
gdd/
├── GDD.md              ← current, living document
└── snapshots/
    ├── v0.1-concept.md
    ├── v0.2-post-prototype.md
    └── v0.3-pre-alpha.md
```

Snapshots are read-only. They show how the design evolved.

---

## Constraints

- Maximum 5 design pillars
- Maximum 10 pages total (including all expanded sections)
- No section without a clear development purpose
- Every Core feature in the scope table must have a corresponding GDD section
- Hypotheses must be marked and resolved through prototyping
- Update the GDD after every prototype — don't let it drift from reality

---

## For AI Assistants

When helping write a GDD:

1. **Ask about phase**: Has the user prototyped anything? This determines whether sections are hypotheses or plans.
2. **Start with Vision + Pillars**: If the user doesn't have these, help them articulate the feeling they want, not the features they want.
3. **Connect to scope-guardian**: Before expanding any section, check if the feature is Core. Only Core features get detailed GDD sections in Phase 1.
4. **Challenge vagueness**: "What does 'fun combat' mean specifically? What game's combat feels closest to what you want?"
5. **Resist feature lists**: If the user starts listing features, redirect to pillars: "Which pillar does this serve?"

When the user says "help me write my GDD":
- If no GDD exists: walk through the Phase 1 structure, one section at a time
- If a GDD exists: read it, check for drift from current state, suggest updates
- If post-prototype: help convert hypotheses to validated design facts

---

## Deeper

- The `scope-guardian` skill — Scope levels that structure GDD detail
- The `game-research` skill — Research that informs GDD content
- The `decision-journal` skill — Design decisions referenced from GDD
- The `prototype-coach` skill — Prototyping that validates GDD hypotheses

---

*A GDD before prototyping is a bet. A GDD after prototyping is a blueprint. Know which one you're writing.*
