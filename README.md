# agentic-config

An opinionated Claude Code configuration with **skills**, **hooks**, **rules**, and **settings** designed for productive agentic workflows.

This config is built for people who use Claude Code as a daily driver and want:
- **Skills** that encode proven patterns for code review, documentation, research, and more
- **Hooks** that prevent destructive git operations and maintain session context
- **Rules** that shape Claude's behavior across all projects
- **Settings** tuned for autonomous operation with safety guardrails

## Quick Start

### Linux / macOS / WSL

```bash
git clone https://github.com/gavinmcfall/agentic-config.git
cd agentic-config
chmod +x install.sh
./install.sh
```

### Windows (PowerShell)

```powershell
git clone https://github.com/gavinmcfall/agentic-config.git
cd agentic-config
.\install.ps1
```

The installer will:
1. Back up your existing `~/.claude/` config (if any)
2. Ask which skill tiers you want to install
3. Copy files and configure hooks
4. Print next steps for customization

## What's Included

**26 skills** across 4 tiers, **3 hooks**, **2 rule files**, **1 output style**, **1 custom agent**, an **Ethos** document, and a pre-configured settings template.

### Hooks

| Hook | Trigger | Purpose |
|------|---------|---------|
| `git-safety.sh` | Before any Bash command | Blocks destructive git operations (`--force`, `--amend`, `reset --hard`, etc.) |
| `init-project.sh` | Session start | Creates `.claude/` directory and session journal in new projects |
| `session-journal.sh` | Before context compaction | Saves session state so context survives compaction |

### Rules

| Rule File | Purpose |
|-----------|---------|
| `review-patterns.md` | Review priority ordering (correctness > security > architecture > performance > tests > style) and document type taxonomy |
| `skills.md` | Master skill registry with invocation patterns and composition flows |

### Settings

The `settings.template.json` provides:
- Model defaults (Sonnet for speed, Opus for depth)
- Hook wiring for all 3 hooks
- Environment variables for experimental features (tool search, agent teams)
- Always-thinking mode enabled
- Empty permissions array (builds up as you use Claude Code)

### Ethos

A layered priority system that guides all agent behavior:
1. **Hard Rules** — never violate (VerifiedOnly, OmitWhenUncertain, NoSecrets)
2. **Guidance** — follow unless you have good reason (TemporalStability, ShapeNotDetail, WhyNotWhat, PatternsNotInstances)
3. **Values** — understand why (BridgingSilos, TrailsNotDestinations, NonObviousTruths)

### Output Styles

| Style | Purpose |
|-------|---------|
| `thinking-partner.md` | Reasoning partner mode — gestalt over encyclopedia, cite sources, acknowledge gaps |

### Custom Agents

| Agent | Purpose |
|-------|---------|
| `researcher.md` | Evidence-first research with citation requirements and confidence tiers |

---

## Skills

### Core (8 skills) — Always installed

These are universally useful regardless of what you're building.

| Skill | Description |
|-------|-------------|
| `code-review` | Review code with fresh eyes for correctness, security, and maintainability. Generate standalone prompts for Claude, G... |
| `domain-expert` | Find, evaluate, and recommend domain names. Use when brainstorming domains, checking availability, evaluating names f... |
| `mermaid-diagrams` | Effective Mermaid diagrams. Use when creating markdown documents with human audiences. |
| `research` | Evidence-first research mode with mandatory citations. Invoke at the START of research, not when writing up results. |
| `review-responder` | Process and respond to code review feedback. Use after receiving PR comments from GitHub, feedback from disconnected-... |
| `skill-builder` | This skill guides intentional skill design. Use when creating, improving, or reviewing Claude Code skills. Requires a... |
| `using-skills` | Check and invoke available skills before starting work. Invoke at the start of any task to ensure relevant skills are... |
| `writing-documents` | Guides effective documentation creation. Activates relevant guidance for north-star, gestalt, reference, research, de... |

### Game Dev (14 skills) — Optional

Solo game development workflows with ADHD-adapted productivity patterns. These encode universal patterns, not personal data.

| Skill | Description |
|-------|-------------|
| `adhd-coach` | Meta-cognitive support for ADHD+OCD during game development. Invoke when the user is stuck, looping, overwhelmed, par... |
| `art-pipeline` | Manage game art assets from creation to in-engine. Use when organizing sprites, choosing art tools, setting up folder... |
| `boot-dev-companion` | Navigate boot.dev courses for game development. Use when planning learning paths, mapping boot.dev progress to game-d... |
| `decision-journal` | Record project decisions with context, rationale, and confidence. Use when making or revisiting decisions about game ... |
| `game-research` | Structured game development research with solo-dev feasibility filtering. Use when investigating engines, genres, art... |
| `gdd-writer` | Write and maintain Game Design Documents for solo dev projects. Use when starting a new game concept, after prototypi... |
| `learning-planner` | Structure learning paths for game development. Use when planning what to learn, choosing courses, tracking learning p... |
| `playtest-coordinator` | Plan and run playtests for a solo dev game. Use when deciding when to test, finding testers, structuring sessions, co... |
| `prototype-coach` | Guide prototyping for solo game dev. Use when deciding what to prototype, scoping a prototype, evaluating results, or... |
| `scope-guardian` | Protect project scope at every level — feature, sprint, and project. Use when evaluating new ideas, reviewing the bac... |
| `session-planner` | Start-of-session and end-of-session rituals. Use at the beginning or end of any game dev work session. Bridges adhd-c... |
| `sound-designer` | Manage game audio from sourcing to in-engine integration. Use when planning sound effects, sourcing music, organizing... |
| `sprint-manager` | Solo dev sprint planning and task management with Plane. Use when planning sprints, sizing tasks, managing the backlo... |
| `steam-publisher` | Navigate the Steam publishing pipeline from Steamworks registration to post-launch. Use when setting up a store page,... |

### Infrastructure (3 skills) — Optional

Kubernetes homelab management with GitOps workflows. Useful for anyone running a similar stack (Talos, Ceph, Cilium, Flux).

| Skill | Description |
|-------|-------------|
| `home-ops-deployer` | Deploy and manage applications in the home-ops Kubernetes cluster via GitOps. Use when deploying new apps, modifying ... |
| `k8s-operator` | Query and diagnose the home Kubernetes cluster. Use when checking cluster health, troubleshooting pods/services/route... |
| `n8n-workflow-builder` | Build automation workflows with n8n for game dev tasks. Use when automating repetitive processes, setting up notifica... |

### Templates (1 skill template(s)) — Optional

Skeleton skills for deeply personal customization. These provide the structure and guidance to build your own version.

| Skill | Description |
|-------|-------------|
| `inner-ally` | Deeply personal mentor and guide. Use when struggling, wanting to quit, feeling overwhelmed, or doubting yourself. Em... |

---

## Customization

After installing, you'll want to personalize:

1. **`~/.claude/CLAUDE.md`** — Add your own core rules, remove any that don't fit
2. **`~/.claude/rules/skills.md`** — Update the skill registry if you add/remove skills
3. **Settings** — The permissions array builds up naturally as you approve tool usage
4. **Skills** — Edit any skill's `SKILL.md` to match your workflow

See [docs/customization.md](docs/customization.md) for detailed guidance.

## Cross-Platform Support

| Platform | Installer | Hooks | Status |
|----------|-----------|-------|--------|
| Linux | `install.sh` | Native bash | Full support |
| macOS | `install.sh` | Native bash | Full support |
| WSL | `install.sh` | Native bash | Full support |
| Windows | `install.ps1` | Git Bash or PowerShell wrappers | Full support |

## Contributing

Found a bug or want to improve a skill? PRs welcome. The skill structure follows the [skill-builder](config/skills/core/skill-builder/SKILL.md) conventions.

## License

MIT
