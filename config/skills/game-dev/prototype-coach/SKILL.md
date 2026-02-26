---
name: prototype-coach
description: Guide prototyping for solo game dev. Use when deciding what to prototype, scoping a prototype, evaluating results, or deciding whether to kill or commit. Prevents both over-investment in prototypes and skipping prototyping entirely.
zones: { knowledge: 10, process: 30, constraint: 25, wisdom: 35 }
---

# prototype-coach

A prototype's job is to die so your game can live.

---

## Capsule: Disposability

**Invariant**
A prototype exists to answer a question, not to become the game. Set the question before building. Discard after answering.

**Example**
Question: "Does grappling hook movement feel fun in 2D?" Build: 1 day. A square, a line, a circle to grapple to. No art, no sound, no menus. Answer: "Yes, the swing arc feels great when momentum carries." The prototype dies. The finding lives in the GDD.
//BOUNDARY: Vertical slices are the exception — they DO become the game's foundation. But even vertical slices are built AFTER mechanic prototypes have validated the core.

**Depth**
- "Disposable" means you're psychologically prepared to delete it. If you can't imagine deleting it, you're building a game, not a prototype.
- Prototype code quality doesn't matter. Hardcoded values, no architecture, spaghetti logic — fine. The point is speed.
- Save the FINDINGS, not the code. Screenshots, GIFs, notes about what felt right/wrong. These are the deliverables.

---

## Capsule: KillCriteria

**Invariant**
Define how you'll know the prototype failed BEFORE you build it. If you can't articulate failure conditions, you'll never kill it.

**Example**
"If after 2 days, the movement doesn't feel fun with just keyboard input (no polish, no juice), the mechanic is wrong for this game." This is a kill criterion. Without it, you spend day 3-7 adding polish hoping it will "feel better."
//BOUNDARY: Kill criteria should be about feel and function, not about polish. "It doesn't look good" is not a kill criterion for a mechanic prototype — it has no art. "It doesn't feel responsive" IS a kill criterion.

---

## Prototype Types

### Mechanic Test

**Answers**: "Does this game mechanic feel fun/interesting?"

- **Duration**: 1-3 days maximum
- **Scope**: One mechanic, placeholder everything else. Colored rectangles, no menus, no scoring.
- **Keep**: Findings only. Screenshots/GIFs of what worked. Notes on what didn't.
- **Kill if**: The mechanic doesn't feel engaging without any polish or juice.

### Art Test

**Answers**: "Can I create this art style at an acceptable quality level?"

- **Duration**: 1-2 days
- **Scope**: Create 3-5 representative assets (a character, a tile, an enemy, an effect). Apply to a simple scene.
- **Keep**: The assets if they're good. The style guide findings regardless.
- **Kill if**: After 2 days, the art style is beyond your current ability AND you don't want to invest months learning it.

### Tech Test

**Answers**: "Can the engine/hardware handle this?"

- **Duration**: 1-2 days
- **Scope**: Stress test the specific concern. 1000 particles? 100 enemies? Pathfinding on a large grid?
- **Keep**: Performance numbers, limitations found, workarounds discovered.
- **Kill if**: The engine can't handle it and there's no reasonable workaround.

### Vertical Slice

**Answers**: "Does the full experience work together?"

- **Duration**: 1-2 weeks
- **Scope**: One complete slice of gameplay: one level/room/encounter with real mechanics, real art (even if rough), real UI. Playable from start to finish.
- **Keep**: This IS the foundation for the real game. Write clean-enough code.
- **Kill if**: The core loop doesn't hold together even when all elements are present. This is a major pivot — record in decision-journal.

**Important**: Only build a vertical slice AFTER mechanic prototypes confirm the core is fun.

---

## Prototype Workflow

### Before Building

1. **State the question**: One sentence. What are you trying to learn?
2. **Set the time box**: How many days? (Maximum: 3 for tests, 10 for vertical slice)
3. **Define kill criteria**: What does failure look like? Write it down.
4. **Create a sprint ticket** (Spike type): Question, time box, kill criteria in the description.

### While Building

- **No polish**. No particle effects, no screen shake, no sound, no menus. Unless the prototype IS about those things.
- **No architecture**. No entity systems, no design patterns, no "doing it right." Speed matters.
- **No scope expansion**. "While I'm at it..." is the enemy. Answer the question, nothing more.
- **Check daily**: Is the question getting answered? If you've lost sight of the question, stop and restate it.

### After Building

1. **Evaluate against kill criteria**: Pass or fail. No "maybe with more time."
2. **Record findings**: What worked? What didn't? What surprised you? (Screenshots/GIFs)
3. **Update the GDD**: If the prototype validates a hypothesis, convert it to fact. If it invalidates one, update or remove.
4. **Record the decision**: Commit or kill, with rationale, in decision-journal.
5. **Delete the prototype** (unless vertical slice). If you can't bring yourself to delete it, move it to an `archive/prototypes/` folder — but don't keep building on it.

---

## ADHD Prototype Traps

| Trap | Symptom | Intervention |
|------|---------|-------------|
| **Polish creep** | Adding juice, effects, menus to a mechanic test | "Is the question answered? Then stop. Polish belongs in the real game." |
| **New prototype shiny** | Starting prototype 2 before evaluating prototype 1 | "Evaluate first. Write the findings. Then decide if a new prototype is needed." |
| **Can't kill it** | Extending time box because "it's almost there" | "You set kill criteria for a reason. What did they say?" |
| **Perfectionism** | Rewriting prototype code to be "cleaner" | "This code is supposed to die. Ugly is correct." |
| **Scope expansion** | "While testing combat, I'll also add inventory" | "One question per prototype. Inventory is a different question." |

---

## Constraints

- Every prototype has a written question, a time box, and kill criteria BEFORE work begins
- Maximum time boxes: 3 days for tests, 10 days for vertical slices
- No polish in mechanic/tech/art tests unless polish IS the question
- Evaluate immediately after the time box expires, not "when I have time"
- One prototype at a time. Finish, evaluate, then decide what's next.
- Prototype code is not production code. Don't refactor it. Don't build on it (except vertical slices).

---

## For AI Assistants

When the user wants to prototype:

1. **Identify the type**: Mechanic, art, tech, or vertical slice?
2. **Extract the question**: "What specifically are you trying to learn?"
3. **Help set kill criteria**: "What would tell you this isn't working?"
4. **Time box it**: "How about [N] days? We'll evaluate on [date]."
5. **Create the ticket**: Spike ticket with question, time box, and kill criteria.

During prototyping:
- If you see polish creep: "That's juice. Save it for the real game. Is the question answered?"
- If scope expands: "That's a separate prototype question. Note it for later."

After prototyping:
- "Time's up. Let's evaluate. What does the prototype tell you about [original question]?"
- Help update GDD and decision-journal with findings.
- If the prototype should die: "Great learnings. Ready to archive it and move on?"

---

## Deeper

- The `gdd-writer` skill — Prototypes validate GDD hypotheses
- The `scope-guardian` skill — Prototypes reveal true scope
- The `decision-journal` skill — Prototype outcomes are decisions
- The `sprint-manager` skill — Prototypes are Spike tickets

---

*Build it fast. Answer the question. Kill it with gratitude.*
