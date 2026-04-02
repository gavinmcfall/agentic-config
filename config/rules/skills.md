# Skills

**Always invoke `using-skills` first.** Skills encode proven practices.

## Core Skills (Always Available)

| Skill | Purpose | Invoke When |
|-------|---------|-------------|
| `using-skills` | Check available skills | Start of any task |
| `writing-documents` | Documentation guidance | Writing READMEs, guides, designs, plans, runbooks |
| `outcome-driven-agentic-design` | Declare intent before code | New features, redesigns, significant changes needing a declaration of intent |
| `code-review` | Fresh-eyes code review + multi-model prompts | Reviewing PRs, commits, staged changes. Generates Claude/Gemini/Codex prompts |
| `review-responder` | Process review feedback | After receiving PR comments or code review findings |
| `research` | Evidence-first investigation | Gathering information for decisions |
| `mermaid-diagrams` | Effective diagrams | Creating diagrams in markdown documents |
| `skill-builder` | Skill creation | Creating or improving Claude Code skills |
| `domain-expert` | Domain name evaluation | Brainstorming, checking availability, choosing registrars |
| `config-packager` | Package config for distribution | Updating agentic-config repo, auditing for PII, packaging skills |
| `red-team` | Adversarial security testing | Testing code, services, or infrastructure for vulnerabilities |
| `qa-engineer` | QA thinking + multi-model verification | Building features, reviewing work, validating output. Generates Codex/Gemini QA prompts |
| `human-profile` | Psychological profile builder | Building personality profiles through interviews or document ingestion |

## Grouped Skills

### Game Dev → `game-dev`

Parent router for the full game dev lifecycle. Invoke `game-dev` to find the right sub-skill.

| Sub-Skill | Purpose |
|-----------|---------|
| `session-planner` | Start/end work sessions. Bridges ADHD energy with sprint tickets. |
| `sprint-manager` | Solo dev sprint planning with Plane. ADHD-adapted workflow. |
| `scope-guardian` | Protect scope at feature/sprint/project level. |
| `decision-journal` | Record decisions with context. Prevents re-evaluation loops. |
| `learning-planner` | Structure learning paths. Prevents tutorial hell. |
| `boot-dev-companion` | Navigate boot.dev courses for game dev readiness. |
| `gdd-writer` | Lean, living Game Design Documents. |
| `prototype-coach` | Scope and evaluate prototypes. Kill or commit. |
| `game-research` | Research with solo-dev feasibility filtering. |
| `art-pipeline` | Organize sprites, source files, folder structure. |
| `sound-designer` | Audio sourcing, organization, format specs, licensing. |
| `steam-publisher` | Steamworks through post-launch. |
| `playtest-coordinator` | Playtests, feedback, Next Fest prep. |
| `plane` | Plane project management operations. |

### Wellbeing → `wellbeing`

Personal support. Invoke `wellbeing` to route to the right help.

| Sub-Skill | Purpose |
|-----------|---------|
| `adhd-coach` | Meta-cognitive ADHD+OCD support during any work. |
| `inner-ally` | Personal mentor who knows your psychology. For struggling moments. |

### Infrastructure → `infrastructure`

Homelab and cluster operations. Invoke `infrastructure` to route.

| Sub-Skill | Purpose |
|-----------|---------|
| `home-ops-deployer` | Deploy to home k8s cluster via GitOps. |
| `k8s-operator` | Query and diagnose cluster (Talos, Ceph, Cilium). |
| `n8n-workflow-builder` | Build automation workflows to reduce manual overhead. |

## Skill Composition Patterns

### Game Dev Workflow
```
game dev work → game-dev → (routes to right sub-skill)
session start → session-planner → adhd-coach (energy check)
sprint planning → sprint-manager → scope-guardian (prevent overcommit)
struggling emotionally → inner-ally → (may hand off to other skills)
learning path → learning-planner → boot-dev-companion (course selection)
design question → gdd-writer ↔ prototype-coach (validate via prototype)
release planning → steam-publisher → playtest-coordinator (Next Fest)
```

### Design & Build
```
new feature → outcome-driven-agentic-design → writing-documents (for each layer)
                                             → research (for findings layer)
                                             → code-review (verify implementation)
                                             → qa-engineer (verify truth statements)
redesign → outcome-driven-agentic-design (start with findings to establish current truth)
simple fix → outcome-driven-agentic-design (abbreviated: findings + plans only)
```

### Code & Review
```
code review → code-review → writing-documents (for findings)
                           → generates Claude/Gemini/Codex prompts in .codereview/
review feedback → review-responder → apply/skip each item
security testing → red-team → review-responder (for remediation)
building features → qa-engineer (QA thinking throughout, not just at the end)
verifying work → qa-engineer → verification checklist
                              → generates Codex/Gemini QA prompts in .codereview/
multi-model review → code-review + qa-engineer (code quality + user workflows)
personality profiling → human-profile → (interview or document ingestion mode)
```

### System Building
```
new skill → skill-builder → writing-documents (skills are agent docs)
research → research skill → writing-documents (for synthesis)
cluster work → infrastructure → (routes to right sub-skill)
new cluster app → home-ops-deployer → k8s-operator (verify deployment)
automation need → n8n-workflow-builder
```

## When to Invoke What

**New feature or significant change?** `outcome-driven-agentic-design`
**Redesigning something that exists?** `outcome-driven-agentic-design` (findings first)
**Want external models to review code?** `code-review` (generates Claude/Gemini/Codex prompts)
**Want external models to verify QA?** `qa-engineer` (generates Codex/Gemini QA prompts)
**Starting game dev work?** `game-dev`
**Can't start / stuck?** `wellbeing` → `adhd-coach`
**Emotionally overwhelmed?** `wellbeing` → `inner-ally`
**Too many ideas?** `game-dev` → `scope-guardian`
**Making a big decision?** `game-dev` → `decision-journal`
**Need to learn something?** `game-dev` → `learning-planner`
**Designing the game?** `game-dev` → `gdd-writer`
**Should I prototype this?** `game-dev` → `prototype-coach`
**Asset organization?** `game-dev` → `art-pipeline` or `sound-designer`
**Steam stuff?** `game-dev` → `steam-publisher`
**Testing with people?** `game-dev` → `playtest-coordinator`
**Cluster work?** `infrastructure`
**Automate something?** `infrastructure` → `n8n-workflow-builder`
**Package config for sharing?** `config-packager`
**Security testing?** `red-team`
**Building / verifying work?** `qa-engineer`
**Personality profiling?** `human-profile`
