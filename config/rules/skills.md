# Skills

**Always invoke `using-skills` first.** Skills encode proven practices.

## Core Skills (Always Available)

| Skill | Purpose | Invoke When |
|-------|---------|-------------|
| `using-skills` | Check available skills | Start of any task |
| `writing-documents` | Documentation guidance | Writing READMEs, guides, designs, plans, runbooks |
| `code-review` | Fresh-eyes code review | Reviewing PRs, commits, staged changes, auditing code |
| `review-responder` | Process review feedback | After receiving PR comments or code review findings |
| `research` | Evidence-first investigation | Gathering information for decisions |
| `mermaid-diagrams` | Effective diagrams | Creating diagrams in markdown documents |
| `skill-builder` | Skill creation | Creating or improving Claude Code skills |

## Game Dev Skills (Custom Suite)

### Session & Planning
- `session-planner` — Start/end work sessions. Bridges ADHD energy with sprint tickets.
- `sprint-manager` — Solo dev sprint planning with Plane. Not Agile — ADHD-adapted workflow.
- `scope-guardian` — Protect scope at feature/sprint/project level. The external "no" ADHD needs.
- `decision-journal` — Record decisions with context. Prevents decision amnesia and re-evaluation loops.

### Learning & Growth
- `boot-dev-companion` — Navigate boot.dev courses for game dev readiness gates.
- `learning-planner` — Structure learning paths. Prevents tutorial hell.
- `adhd-coach` — Meta-cognitive ADHD+OCD support during creative work.
- `inner-ally` — Personal mentor who knows your psychology. For struggling moments.

### Game Design & Production
- `gdd-writer` — Lean, living Game Design Documents. Grows with the game, not before it.
- `prototype-coach` — Scope and evaluate prototypes. Knows when to kill, when to commit.
- `game-research` — Game dev research with solo-dev feasibility filtering.

### Asset Pipeline
- `art-pipeline` — Organize sprites, source files, folder structure, asset production.
- `sound-designer` — Audio sourcing, organization, format specs, licensing.

### Publishing & Testing
- `steam-publisher` — Steamworks setup through post-launch. Store pages, builds, pricing, EA.
- `playtest-coordinator` — Run playtests, process feedback, Next Fest prep. ADHD-aware.

### Infrastructure
- `home-ops-deployer` — Deploy to home k8s cluster via GitOps.
- `k8s-operator` — Query and diagnose cluster (Talos, Ceph, Cilium).
- `n8n-workflow-builder` — Build automation workflows to reduce manual overhead.

## Skill Composition Patterns

### Game Dev Workflow
```
session start → session-planner → adhd-coach (energy check)
sprint planning → sprint-manager → scope-guardian (prevent overcommit)
struggling emotionally → inner-ally → (may hand off to other skills)
learning path → learning-planner → boot-dev-companion (course selection)
design question → gdd-writer ↔ prototype-coach (validate via prototype)
release planning → steam-publisher → playtest-coordinator (Next Fest)
```

### Code & Review
```
code review → code-review → writing-documents (for findings)
review feedback → review-responder → apply/skip each item
```

### System Building
```
new skill → skill-builder → writing-documents (skills are agent docs)
research → research skill → writing-documents (for synthesis)
new cluster app → home-ops-deployer → k8s-operator (verify deployment)
automation need → n8n-workflow-builder
```

## When to Invoke What

**Starting work?** `session-planner`
**Can't start / stuck?** `adhd-coach` → `session-planner`
**Emotionally overwhelmed?** `inner-ally`
**Too many ideas?** `scope-guardian`
**Making a big decision?** `decision-journal`
**Need to learn something?** `learning-planner` or `boot-dev-companion`
**Designing the game?** `gdd-writer`
**Should I prototype this?** `prototype-coach`
**Asset organization?** `art-pipeline` or `sound-designer`
**Steam stuff?** `steam-publisher`
**Testing with people?** `playtest-coordinator`
**Cluster work?** `k8s-operator` or `home-ops-deployer`
**Automate something?** `n8n-workflow-builder`
