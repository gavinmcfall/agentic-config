---
name: boot-dev-companion
description: Navigate boot.dev courses for game development. Use when planning learning paths, mapping boot.dev progress to game-dev readiness, choosing which courses to prioritize, or connecting platform content to the game project. Bridges backend-focused curriculum with game dev goals.
zones: { knowledge: 60, process: 15, constraint: 10, wisdom: 15 }
---

# boot-dev-companion

boot.dev teaches you to think like a programmer. Your game needs you to think like a programmer. The overlap is the skill.

---

## Capsule: GameDevRelevanceFilter

**Invariant**
Not every boot.dev course serves the game. Know which ones do before investing weeks.

**Example**
Learn SQL is valuable for backend careers but irrelevant to a solo game dev's first project. Learn OOP is foundational for every game engine. Prioritize OOP.
//BOUNDARY: This filter applies to the game project. If the user is also building backend skills for career reasons, both tracks have value — don't dismiss career-relevant courses.

**Depth**
- The filter is about sequencing and emphasis, not exclusion
- A course being "not relevant to game dev" doesn't mean "skip it" — it means "don't prioritize it over game-relevant courses"
- The user's boot.dev subscription gives access to all courses; the filter helps allocate limited time

---

## Course Relevance Map

### Tier 1 — Build These Skills First

These courses directly enable game development. Prioritize them.

| Course | Game Dev Connection | Unlocks |
|--------|-------------------|---------|
| Learn Coding Basics (Python) | Programming fundamentals | Everything else |
| Learn Linux | Build toolchains, shell scripting | Asset pipelines, automation |
| Learn Git | Version control | Any project work |
| Learn OOP (Python) | Entity systems, inheritance, game object hierarchies | Game architecture |
| **Build an Asteroids Game** (Pygame) | Game loops, sprites, collision, state management | First hands-on game project |
| Learn Functional Programming | Immutable state, pure functions | Clean game state management |

### Tier 2 — Strengthen Foundations

These deepen CS fundamentals that improve game code quality.

| Course | Game Dev Connection | Unlocks |
|--------|-------------------|---------|
| Learn Data Structures & Algorithms | Pathfinding, spatial data, collision systems | Efficient game systems |
| **Build a Maze Solver** (Tkinter) | Pathfinding algorithms with visual output | Algorithm visualization skills |
| Learn Memory Management (C) | Understanding allocation, pointers | Performance optimization |
| Learn DSA 2 | Priority queues, weighted graphs, shortest paths | AI pathfinding, event systems |

### Tier 3 — Useful But Not Urgent

Relevant to game dev but not blocking early progress.

| Course | Game Dev Connection |
|--------|-------------------|
| Build a Bookbot | Practice project (reading/parsing) |
| Build an AI Agent | AI concepts applicable to game NPCs |
| Learn Golang | Systems programming (alternative engine choice) |
| Learn Networking (planned) | Multiplayer game networking |
| Learn Discrete Math (planned) | Game physics, procedural generation |
| Learn Computer Architecture (planned) | Performance understanding |

### Not Game-Dev Relevant

Skip or defer unless pursuing backend career goals: HTTP clients/servers, SQL, Docker, file storage/CDNs, pub/sub architecture, Blog Aggregator, Static Site Generator, Pokedex (API client), web security, job search.

---

## Mapping boot.dev Progress to Game Readiness

### Capsule: ReadinessGates

**Invariant**
Certain boot.dev milestones unlock specific game development capabilities. Track gates, not course completion percentages.

**Example**
After completing OOP + Asteroids, the user can start learning a game engine (Godot, Unity). Before that, engine tutorials will be frustrating because the programming concepts aren't solid.
//BOUNDARY: Gates are "ready to start learning X," not "mastered X." The user will continue learning while building.

---

| Gate | boot.dev Milestone | What It Unlocks |
|------|-------------------|-----------------|
| **Can Code** | Coding Basics complete | Simple scripts, automation |
| **Can Structure** | OOP complete | Game engine tutorials make sense |
| **Can Build a Game Loop** | Asteroids complete | First original game prototype |
| **Can Optimize** | DSA + Memory Mgmt complete | Performance-aware game code |
| **Can Architect** | FP + DSA 2 complete | Complex game systems (ECS, state machines) |

### What boot.dev Does NOT Unlock

boot.dev will not teach:
- Game engines (Godot, Unity, Unreal)
- Game design (mechanics, balancing, player experience)
- Art creation (sprites, 3D models, animation)
- Sound design (music, SFX)
- Steam publishing

These require separate learning tracked by learning-planner. The user needs to start supplementing boot.dev with game-engine-specific learning after the "Can Structure" gate.

---

## Using boot.dev Effectively

### The Platform's Strengths

- **Training Grounds**: Use for spaced repetition on game-relevant topics (OOP, algorithms). Personalized challenges based on recent coursework. Paid members get unlimited practice.
- **RPG gamification**: XP, levels, streaks, quests align with ADHD dopamine patterns. Use the gamification as motivation fuel, not as an end in itself.
- **Boots (AI mentor)**: Socratic-method help that won't give away answers. Use it before asking Claude — it has lesson-specific context Claude lacks.
- **Projects**: The build-along projects (Asteroids, Maze Solver) are the most valuable parts for a game dev. Don't rush through them.

### The Platform's Gaps

- **No game engine content**: Supplement with Godot/Unity tutorials after the "Can Structure" gate
- **Backend-heavy second half**: The Go/TypeScript backend track is valuable for career but not for the game. Don't feel obligated to complete the entire path sequentially if game dev is the priority.
- **Linear curriculum**: boot.dev enforces sequential order. If you're blocked on a course that's not game-relevant, it's okay to pause and do game-engine learning instead.

---

## Learning Integration

### boot.dev + Game Dev Sessions

A productive week might look like:

| Day | Activity | Why |
|-----|----------|-----|
| Weekday evenings | boot.dev course progress (30-60min) | Consistent skill building |
| Weekend session | Apply boot.dev concepts to game project | Reinforce by building |
| Stuck day | Training Grounds practice | Low-effort progress |

This follows learning-planner's LearnBuildCycle: learn on boot.dev, build in the game project, hit a wall, learn what the wall requires.

### Sprint Integration

boot.dev progress maps to sprint-manager tickets:

```
Title: Complete boot.dev OOP chapters 5-8
Type: Learning
Size: M
Energy: Medium
Domain: Learning
Acceptance: Chapters complete, Training Grounds score >80% on OOP topics
```

---

## Constraints

- Don't skip Tier 1 courses to get to "more interesting" Tier 2 content
- Don't treat boot.dev completion as a prerequisite for starting game dev — start engine learning after the "Can Structure" gate
- Don't abandon boot.dev when game dev gets exciting — the CS fundamentals compound over time
- Don't use boot.dev course order as the only learning sequence — supplement with game-specific learning in parallel after basics are solid

---

## For AI Assistants

When the user mentions boot.dev:

1. **Check their current progress**: Which courses are complete? Which gate have they passed?
2. **Suggest next relevant course**: Based on the relevance map and their game dev needs
3. **Connect to game project**: "The DSA concepts from your current course are directly useful for [specific game feature]"
4. **Flag when to supplement**: If they're past "Can Structure" and haven't started engine learning, suggest it

When the user is stuck on a boot.dev course:
- Check if it's a game-relevant course (Tier 1-2). If yes, help them push through.
- If it's not game-relevant (Tier 3 or lower), suggest pausing it for game-specific learning instead.
- Remind them about Training Grounds for low-effort practice days.

---

## Deeper

- The `learning-planner` skill — Overall learning path structure
- The `adhd-coach` skill — Energy management for learning sessions
- The `game-research` skill — Identifying what skills are needed for the game
- boot.dev course catalog: https://www.boot.dev/courses
- boot.dev backend path: https://www.boot.dev/tracks/backend

---

*boot.dev teaches you to think like a programmer. The game teaches you to think like a game developer. You need both.*
