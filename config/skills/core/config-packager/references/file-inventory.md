# File Inventory

Complete inventory of `~/.claude/` with distribution classification.

## Action Legend

| Action | Meaning |
|--------|---------|
| **Include** | Copy as-is, no changes needed |
| **Sanitize** | Apply pattern replacements before copying |
| **Template** | Generate a clean version from scratch, keeping structure |
| **Skeleton** | Replace all content with instructions/placeholders |
| **Exclude** | Never distribute |

---

## Top-Level Files

| File | Action | Notes |
|------|--------|-------|
| `CLAUDE.md` | Sanitize | Strip Bedrock credentials, generalize personal rules, replace paths |
| `settings.json` | Template | Keep hooks/env/model structure. Empty permissions array. Replace paths in hook commands. |
| `settings.local.json` | Exclude | Machine-specific overrides |
| `.credentials.json` | Exclude | Auth credentials |
| `.claude.json` | Exclude | Machine state (startup count, tips, feature gates) |
| `.claude.zip` | Exclude | Backup archive |
| `load-mcp-env.sh` | Template | Replace specific 1Password paths with generic secret-loader pattern |
| `history.jsonl` | Exclude | Conversation history |
| `stats-cache.json` | Exclude | Usage statistics |
| `mcp-needs-auth-cache.json` | Exclude | Auth cache |

## Directories

| Directory | Action | Notes |
|-----------|--------|-------|
| `rules/` | Sanitize | Both files are mostly generic, scrub any personal refs |
| `hooks/` | Include | All 3 scripts are fully generic |
| `skills/` | Per-skill (see below) | Apply tier-based policy |
| `scripts/` | Exclude | MCP server wrappers with secret sourcing |
| `plugins/` | Exclude | Installed plugin cache, machine-specific |
| `projects/` | Exclude | Per-project session data |
| `plans/` | Exclude | Active plan files |
| `tasks/` | Exclude | Team task files |
| `teams/` | Exclude | Team config files |
| `ide/` | Exclude | IDE lock files |
| `file-history/` | Exclude | Edit history |
| `image-cache/` | Exclude | Cached images |
| `paste-cache/` | Exclude | Clipboard data |
| `session-env/` | Exclude | Environment snapshots |
| `shell-snapshots/` | Exclude | Shell state |
| `debug/` | Exclude | Debug output |
| `cache/` | Exclude | General cache |
| `statsig/` | Exclude | Feature flags |
| `telemetry/` | Exclude | Telemetry data |
| `backups/` | Exclude | Backups |
| `memory/` | Exclude | Auto-memory (project-specific) |

## Skills by Tier

### Tier 1: Core (always installed)

| Skill | Action | Notes |
|-------|--------|-------|
| `using-skills` | Include | Fully generic |
| `skill-builder` | Include | Fully generic |
| `writing-documents` | Include | Fully generic, extensive references/ |
| `code-review` | Sanitize | Check prompts/ for personal refs |
| `review-responder` | Include | Fully generic |
| `research` | Include | Fully generic |
| `mermaid-diagrams` | Include | Fully generic |
| `domain-expert` | Include | Fully generic |

### Tier 2: Game Dev (optional)

| Skill | Action | Notes |
|-------|--------|-------|
| `adhd-coach` | Sanitize | Generic ADHD patterns, check references for personal examples |
| `session-planner` | Sanitize | Check for personal tool/service references |
| `sprint-manager` | Sanitize | References Plane (tool-specific but not personal) |
| `scope-guardian` | Include | Fully generic |
| `decision-journal` | Include | Fully generic |
| `learning-planner` | Include | Fully generic |
| `boot-dev-companion` | Include | Platform-specific (boot.dev) but no PII |
| `game-research` | Include | Fully generic |
| `gdd-writer` | Include | Fully generic |
| `prototype-coach` | Include | Fully generic |
| `art-pipeline` | Include | Fully generic |
| `sound-designer` | Include | Fully generic |
| `playtest-coordinator` | Include | Fully generic |
| `steam-publisher` | Include | Fully generic |

### Tier 3: Infrastructure (optional)

| Skill | Action | Notes |
|-------|--------|-------|
| `home-ops-deployer` | Sanitize | Replace cluster names, personal email in commit convention, namespace inventory |
| `k8s-operator` | Sanitize | Replace cluster name, node names, service inventory |
| `n8n-workflow-builder` | Sanitize | Replace personal URLs |

### Tier 4: Personal Templates (optional)

| Skill | Action | Notes |
|-------|--------|-------|
| `inner-ally` | Skeleton | Replace ALL content with template instructions. The structure (capsules, response patterns, non-negotiables) becomes a guide for building your own. |

## What Ships Per Skill

For each skill that is included:
- `SKILL.md` — Always (sanitized as needed)
- `references/` — Always (sanitized as needed)
- `meta/` — Never (authoring artifacts)
- `scripts/` — Include if present and generic
