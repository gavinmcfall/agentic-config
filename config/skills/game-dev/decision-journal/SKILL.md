---
name: decision-journal
description: Record project decisions with context, rationale, and confidence. Use when making or revisiting decisions about game development — engine, genre, art style, tools, architecture, learning path. Prevents decision amnesia and ADHD re-evaluation loops.
zones: { knowledge: 15, process: 25, constraint: 15, wisdom: 45 }
---

# decision-journal

A decision without recorded rationale is a decision you'll make again.

---

## Capsule: DecisionAmnesia

**Invariant**
Future-you will not remember why present-you chose this. Write it down now, or re-derive it later at 10x the cost.

**Example**
"I chose Godot because..." — without this, month 6 becomes: research engines again, question the choice, lose a week, arrive at the same answer.
//BOUNDARY: Not every micro-decision needs a record. Only decisions that constrain future options.

**Depth**
- ADHD amplifies this: the urge to revisit is strong, and without evidence the old decision was sound, you WILL revisit
- OCD amplifies this: the urge to get it "right" means re-evaluation feels productive even when it isn't
- The journal is the antidote: "I already decided this. Here's why. The revisit trigger hasn't been met."

---

## Capsule: RevisitTrigger

**Invariant**
Every decision includes the conditions under which it should be reopened. If those conditions haven't been met, the decision stands.

**Example**
Decision: Use Godot 4.
Revisit trigger: "Revisit if Godot drops C# support, or if the game requires AAA-quality 3D rendering that Godot can't deliver."

Without a trigger, any doubt becomes a valid reason to reopen. With a trigger, doubt meets a concrete test.

**Depth**
- The trigger is a gift to future-you: it transforms "should I reconsider?" into "has the trigger been met?"
- Good triggers are observable and specific, not vague ("if it feels wrong")
- Multiple triggers are fine: any one met = reopen
- SeeAlso: DecisionAmnesia

---

## When to Record

Record a decision when:
- It constrains future options (engine, language, genre, art style)
- It resolves a question that took research to answer
- It settles a debate (even an internal one)
- You find yourself re-evaluating something you already decided

Do NOT record:
- Implementation details that can be changed trivially
- Preferences that don't constrain anything
- Decisions someone else owns

---

## The Entry Format

See `references/entry-template.md` for the full template.

Every entry captures:

| Field | Purpose |
|-------|---------|
| **Title** | What was decided, in imperative form |
| **Domain** | engine, language, genre, art, audio, tools, architecture, learning, scope |
| **Status** | `decided`, `exploring`, `superseded` |
| **Confidence** | `high` (well-researched), `medium` (informed judgment), `low` (gut call / time-boxed) |
| **Context** | What situation prompted this decision |
| **Decision** | What was chosen |
| **Rationale** | Why this option over alternatives |
| **Alternatives considered** | What was rejected and why |
| **Consequences** | What this enables and constrains |
| **Revisit trigger** | When to reopen this decision |
| **Evidence** | Links to research, benchmarks, prototypes |

---

## The Recording Process

1. **Identify the decision** — What are you actually deciding? State it crisply.
2. **Check for existing entries** — Has this been decided before? If yes, check the revisit trigger. If the trigger hasn't been met, the decision stands. Stop.
3. **Record context** — Why is this decision being made now?
4. **Document alternatives** — What options were considered? (Even if briefly.)
5. **State the decision and rationale** — What and why.
6. **Define the revisit trigger** — Under what conditions should this be reopened?
7. **Link evidence** — Research docs, prototypes, benchmarks.
8. **Set confidence** — Be honest. A gut call is fine; just label it.

---

## Storage

```
<project>/decisions/
├── 001-game-engine.md
├── 002-programming-language.md
├── 003-art-style.md
├── 004-genre-and-scope.md
└── ...
```

Sequential numbering. Git-tracked. Searchable by grep/glob.

**Naming**: `NNN-brief-description.md` — number for ordering, description for findability.

---

## Querying Decisions

```bash
# All decisions
ls decisions/

# By domain
grep -l "domain: engine" decisions/*.md

# By status
grep -l "status: decided" decisions/*.md

# Superseded decisions (historical context)
grep -l "status: superseded" decisions/*.md
```

---

## Constraints

- Never delete a decision entry. Supersede it: set `status: superseded`, add `superseded_by: NNN`, and create the new entry.
- Never record a decision without a revisit trigger.
- Never leave confidence blank. If you don't know how confident you are, it's `low`.
- Link to evidence. "I read about it somewhere" is not evidence.

---

## For AI Assistants

When a user makes a decision during a session:
1. Offer to record it: "This seems like a decision worth recording. Want me to create a journal entry?"
2. If yes, use the entry template
3. Ask about revisit triggers — the user often won't think of this unprompted
4. Set confidence based on the research depth that informed it

When a user wants to revisit a decision:
1. Read the existing entry first
2. Check the revisit trigger: "The trigger for reopening this was [X]. Has that happened?"
3. If no, gently note this: "The conditions for revisiting haven't been met. The original decision was [X] because [Y]."
4. If yes, proceed with research and create a new entry that supersedes the old one

---

## Deeper

- `references/entry-template.md` — Full decision entry template
- The `research` skill — For decisions that need investigation first
- The `game-research` skill (future) — For game-specific research

---

*Decide once, record well, revisit only when the trigger says to.*
