---
name: using-skills
description: Check and invoke available skills before starting work. Invoke at the start of any task to ensure relevant skills are loaded.
---

# Using Skills

Before starting any task, check your available skills. Skills encode proven practices — ignoring them means reinventing wheels or missing important patterns.

## Process

1. **List available skills** — Check what's available in your current context
2. **Match to task** — Which skills might apply, even partially?
3. **Invoke relevant skills** — Load them before starting work
4. **Apply their guidance** — Follow the patterns they establish

## When in Doubt, Invoke

If there's even a small chance a skill applies, invoke it. The cost of loading an irrelevant skill is low. The cost of missing relevant guidance is high.

Skills compose. One skill may tell you to invoke another.

## Skill Groups

### Core Skills (Always Available)

| Skill | Use When |
|-------|----------|
| `using-skills` | Start of any task |
| `writing-documents` | Writing any documentation, READMEs, designs, plans |
| `code-review` | Reviewing PRs, commits, staged changes, auditing code |
| `review-responder` | Processing and responding to code review feedback |
| `mermaid-diagrams` | Creating diagrams in markdown documents |
| `skill-builder` | Creating or improving Claude Code skills |
| `domain-expert` | Brainstorming, checking availability, choosing registrars |
| `config-packager` | Updating agentic-config repo, auditing for PII, packaging skills |
| `red-team` | Testing code, services, or infrastructure for vulnerabilities |
| `qa-engineer` | Building features, reviewing work, validating output, anything that feels "done" |

### Game Dev → `game-dev`

Parent router for 14 sub-skills covering the full game dev lifecycle. Invoke `game-dev` to find the right sub-skill.

Sub-skills: `session-planner`, `sprint-manager`, `scope-guardian`, `decision-journal`, `learning-planner`, `boot-dev-companion`, `gdd-writer`, `prototype-coach`, `game-research`, `art-pipeline`, `sound-designer`, `steam-publisher`, `playtest-coordinator`, `plane`

### Wellbeing → `wellbeing`

Personal support for ADHD, emotional regulation, and self-doubt. Invoke `wellbeing` to route to the right help.

Sub-skills: `adhd-coach`, `inner-ally`

### Infrastructure → `infrastructure`

Homelab cluster operations, deployments, and automation. Invoke `infrastructure` to route to the right tool.

Sub-skills: `home-ops-deployer`, `k8s-operator`, `n8n-workflow-builder`

## Skill Composition Patterns

```
task → using-skills → identify relevant skills → invoke them → work

game dev work → game-dev → (routes to sub-skill)
struggling / stuck → wellbeing → adhd-coach or inner-ally
cluster / deploy → infrastructure → (routes to sub-skill)

writing task → writing-documents → [document type guidance]
code review → code-review → writing-documents (for findings)
review feedback → review-responder → apply/skip each item
new skill → skill-builder → writing-documents (skills are agent docs)
security testing → red-team → review-responder (for remediation)
building features → qa-engineer (wear the QA hat throughout)
validating work → qa-engineer → verification checklist
```

## Quick "What Do I Invoke?"

| Situation | Invoke |
|-----------|--------|
| Starting game dev work | `game-dev` |
| Can't start / stuck / ADHD | `wellbeing` |
| Emotionally overwhelmed | `wellbeing` |
| Cluster / deploy / automation | `infrastructure` |
| Writing docs | `writing-documents` |
| Code review | `code-review` |
| Making a big decision | `game-dev` → `decision-journal` |
| Security testing | `red-team` |
| Building / verifying work | `qa-engineer` |
| Packaging config | `config-packager` |
| Domain names | `domain-expert` |
| New skill | `skill-builder` |

---

*Check skills first. Missing relevant guidance costs more than loading unused skills.*
