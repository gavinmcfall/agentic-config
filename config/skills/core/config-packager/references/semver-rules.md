---
description: Semantic versioning rules for the agentic-config distribution repo
tags: [semver, versioning, release, classification]
audience: { human: 30, agent: 70 }
purpose: { reference: 60, high-agency-process: 40 }
---

# Semver Rules for Config Releases

Semantic versioning applied to a Claude Code configuration repo. The unit of change is the consumer's installed config — what breaks their setup, what adds capability, what refines existing content.

---

## Classification

| Change Type | Bump | Signal to Consumers |
|-------------|------|---------------------|
| Skill removed or renamed | **Major** | Their workflow references may break |
| CLAUDE.md structure changed | **Major** | Their extensions may reference sections |
| Hook interface changed | **Major** | Their settings.json hook config may break |
| Install script breaking changes | **Major** | Re-install required with different steps |
| New skill added | **Minor** | New capability available, nothing breaks |
| New config type added | **Minor** | New file category (Ethos, output-styles, agents) |
| New reference in existing skill | **Minor** | Existing skill gains depth |
| New hook or doc added | **Minor** | New functionality, opt-in |
| Existing file content updated | **Patch** | Better wording, examples, fixes |
| Sanitization improvements | **Patch** | Internal packaging quality |
| README regeneration | **Patch** | Documentation refresh |

---

## Determination Logic

The sync-release script classifies each changed file and applies the **highest applicable bump**.

### Priority (highest wins)

1. Any DELETED_SKILL or DELETED_CONFIG → **major**
2. Any NEW_SKILL or NEW_CONFIG → **minor**
3. Only MODIFIED files → **patch**

### Override

User can force any bump level with `--major`, `--minor`, or `--patch`. The script suggests but does not dictate.

---

## What Counts as Each Change Type

### Skill Changes
- **NEW_SKILL**: Skill directory exists locally but not in distribution repo
- **MODIFIED_SKILL**: Skill exists in both, but SKILL.md or references differ
- **DELETED_SKILL**: Skill exists in repo but not locally (and not in exclude tier)

### Config Changes
- **NEW_CONFIG**: File exists in local `~/.claude/` (non-skill) but not in repo's `config/`
- **MODIFIED_CONFIG**: File exists in both but content differs (after sanitization)
- **DELETED_CONFIG**: File exists in repo's `config/` but not locally

### Ignored Changes
- Files in excluded directories (projects, plans, tasks, etc.) — never compared
- `meta/` directories — authoring artifacts, not distributed
- `config-packager` skill itself — not distributed
- `.packager/` metadata — internal tracking

---

## Edge Cases

| Scenario | Classification | Rationale |
|----------|---------------|-----------|
| Skill moved between tiers | Patch | Same content, different install grouping |
| Reference file renamed within skill | Patch | Internal reorganization |
| New skill + deleted skill in same release | Major | Deletion takes precedence |
| Only README changed | Patch | Generated artifact |
| Install script gains new flag | Patch | Additive, non-breaking |
| Install script changes target paths | Major | Breaks existing installs |
