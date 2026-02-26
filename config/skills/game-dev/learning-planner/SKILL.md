---
name: learning-planner
description: Structure learning paths for game development. Use when planning what to learn, choosing courses, tracking learning progress, or connecting learning to building. Prevents tutorial hell and ensures learning serves the game.
zones: { knowledge: 40, process: 30, constraint: 10, wisdom: 20 }
---

# learning-planner

Tutorial completion is not learning. Building something you couldn't build before — that's learning.

---

## Capsule: LearnBuildCycle

**Invariant**
Learn just enough to attempt the next thing. Build it. Hit a wall. Learn what the wall requires. Repeat.

**Example**
Need player movement → learn GDScript basics (variables, functions, input handling) → build player movement → hit wall: sprite won't animate → learn AnimationPlayer → build animation → hit wall: physics feels wrong → learn RigidBody2D...
//BOUNDARY: "Just enough" means the minimum to attempt, not the minimum to master. You'll learn the rest through building.

**Depth**
- The alternative — complete Course A → Course B → Course C → start building — feels safe but produces no game. Courses are infinite; the game is finite.
- Walls are the learning curriculum. They tell you exactly what you need next. No syllabus does this as well.
- ADHD benefits from this cycle: each "learn" phase is short and targeted, each "build" phase has immediate application, each wall is a concrete problem (not abstract theory).
- SeeAlso: TwoMinuteStart (adhd-coach) — start building before you feel "ready"

---

## Capsule: TutorialHell

**Invariant**
If you've completed 3 tutorials without building something original, you're in tutorial hell. Stop learning and start building.

**Example**
Completed: GDScript basics, Godot scene tutorial, 2D platformer tutorial. Built from scratch: nothing. The cure: build a terrible, ugly version of the simplest thing you can imagine. A square that moves. A button that makes a sound. Anything.
//BOUNDARY: Following a tutorial IS building — but only the first time. The second tutorial without original work is the warning sign.

**Depth**
- Tutorial hell feels productive because you're "learning." But recall without application decays rapidly.
- The practice requirement on learning tickets (sprint-manager) is the structural defense: the ticket isn't done until you build something.
- The ugly-first-version is the antidote. It doesn't need to be good. It needs to be yours.
- SeeAlso: PerfectionTrap (adhd-coach) — waiting to feel "ready" is perfectionism in disguise

---

## Learning Domains

### Dependency Order

Learn in the order your project needs, not the order a course suggests.

```
Programming Fundamentals
└── Engine Basics
    └── Game-Specific Patterns
        └── Polish & Optimization

Art Fundamentals (parallel track)
└── Tool Proficiency
    └── Asset Pipeline
```

**Programming fundamentals first**: variables, functions, control flow, data structures. You can't learn engine scripting without these. boot.dev covers this well.

**Engine basics second**: scenes, nodes, input handling, basic physics. This is where you transition from "learning to code" to "learning to make games."

**Game-specific patterns third**: state machines, pathfinding, procedural generation, inventory systems. Learn these as you need them for your game, not ahead of time.

**Art is a parallel track**: Start when programming basics are solid enough to display what you create. No point learning pixel art if you can't render a sprite yet.

---

## Learning Path Structure

Each learning phase has:

| Element | Purpose |
|---------|---------|
| **Goal** | What you're learning to BUILD (not just learn) |
| **Resources** | boot.dev course + supplementary (YouTube, docs) |
| **Practice project** | Something original using what you learned |
| **Done signal** | How you know this phase is complete |
| **Next trigger** | What wall will tell you it's time for the next phase |

### Example Phase

```
Phase: GDScript Fundamentals
Goal: Write a simple interactive scene from scratch (no tutorial)
Resources:
  - boot.dev: [relevant GDScript/Python course]
  - Godot docs: GDScript reference
  - YouTube: "GDScript for beginners" (pick ONE, not five)
Practice: Build a number guessing game in Godot
Done signal: Can write a script that handles input, uses variables,
             and has conditional logic — without copying from a tutorial
Next trigger: "I can write basic scripts but don't know how to
              make things move on screen" → Engine Basics phase
```

---

## Connecting Learning to Building

### Decision Creates Learning Path

When a decision-journal entry is recorded, it may create learning needs:

1. Decision: "Use Godot 4 with GDScript"
2. → Learning need: GDScript fundamentals
3. → Learning need: Godot engine basics
4. → Sprint tickets created (via sprint-manager)

### Learning Tickets Have Practice Requirements

From sprint-manager: a learning ticket isn't done until you build something. This skill adds specificity:

- **What to build**: Something original, however small, using the concepts learned
- **How small**: The practice project should be completable in 1-2 hours
- **How ugly**: It can be terrible. The point is application, not portfolio

---

## Progress Tracking

### What to Track

- **Phases completed**: Which learning phases are done (based on done signals, not course completion percentage)
- **Walls hit**: What you couldn't do that sent you to learn something (these are the real curriculum)
- **Skills unlocked**: What you can now build that you couldn't before (concrete, not abstract)

### What NOT to Track

- Course completion percentages (vanity metric)
- Hours spent learning (not correlated with capability)
- Comparison to other learners' pace (irrelevant)

### Tracking Mechanism

A simple markdown file in the project:

```markdown
# Learning Log

## Current Phase: Engine Basics

### Skills Unlocked
- [x] Write GDScript with variables, functions, conditionals
- [x] Handle keyboard input
- [ ] Create and switch between scenes
- [ ] Use AnimationPlayer for sprite animations

### Walls Hit (= next learning targets)
- Couldn't figure out scene transitions → need to learn SceneTree
- Sprite just sits there → need to learn AnimationPlayer
```

---

## Constraints

- Never complete more than 2 courses without building something original
- Learning tickets always include a practice project
- Learn in project dependency order, not course catalog order
- Practice projects are time-boxed: 1-2 hours maximum
- Track skills unlocked, not courses completed

---

## For AI Assistants

When the user says "I need to learn X":

1. **Check why**: What are they trying to build? What wall did they hit?
2. **Scope it**: What's the minimum they need to learn to get past the wall?
3. **Find resources**: boot.dev course if available, supplementary if not
4. **Create a learning ticket**: With a practice project and done signal
5. **Prevent over-learning**: "You probably know enough to attempt [the thing] now. Try building it and see what wall you hit next."

When the user wants to "learn everything first":
- Gently redirect: "What's the next thing you want to build? Let's learn just enough for that."
- Reference LearnBuildCycle: "Each wall tells you what to learn next. You don't need to anticipate them all."

---

## Deeper

- The `boot-dev-companion` skill — Specific boot.dev course guidance
- The `sprint-manager` skill — Learning tickets with practice requirements
- The `adhd-coach` skill — Tutorial hell and perfectionism traps
- The `game-research` skill — Research determines what needs learning

---

*Learn enough to build the next thing. Build it. Hit a wall. Repeat.*
