#!/usr/bin/env bash
# config-packager: Generate README.md for the distribution repo
# Usage: generate-readme.sh [--repo PATH]
#
# Parses SKILL.md frontmatter to build skill inventory table.
# Output: Writes README.md to repo root.

set -euo pipefail

REPO_DIR="${HOME}/my_other_repos/agentic-config"

while [[ $# -gt 0 ]]; do
  case $1 in
    --repo) REPO_DIR="$2"; shift 2 ;;
    *)      echo "Unknown option: $1"; exit 1 ;;
  esac
done

SKILLS_DIR="${REPO_DIR}/config/skills"
OUTPUT="${REPO_DIR}/README.md"

# --- Parse skill frontmatter ---
get_skill_description() {
  local skill_md="$1"
  if [[ -f "$skill_md" ]]; then
    # Extract description from YAML frontmatter
    sed -n '/^---$/,/^---$/p' "$skill_md" | grep '^description:' | sed 's/^description: *//'
  fi
}

count_skills_in_tier() {
  local tier_dir="$1"
  if [[ -d "$tier_dir" ]]; then
    ls -d "$tier_dir"/*/ 2>/dev/null | wc -l
  else
    echo "0"
  fi
}

# --- Generate skills table for a tier ---
generate_tier_table() {
  local tier_dir="$1"

  if [[ ! -d "$tier_dir" ]]; then
    echo "No skills in this tier."
    return
  fi

  echo "| Skill | Description |"
  echo "|-------|-------------|"

  for skill_dir in "$tier_dir"/*/; do
    [[ ! -d "$skill_dir" ]] && continue
    local skill_name=$(basename "$skill_dir")
    local desc=$(get_skill_description "${skill_dir}/SKILL.md")
    [[ -z "$desc" ]] && desc="No description available"
    # Truncate long descriptions
    if [[ ${#desc} -gt 120 ]]; then
      desc="${desc:0:117}..."
    fi
    echo "| \`${skill_name}\` | ${desc} |"
  done
}

# --- Build README ---
core_count=$(count_skills_in_tier "${SKILLS_DIR}/core")
gamedev_count=$(count_skills_in_tier "${SKILLS_DIR}/game-dev")
infra_count=$(count_skills_in_tier "${SKILLS_DIR}/infra")
template_count=$(count_skills_in_tier "${SKILLS_DIR}/templates")
total_count=$((core_count + gamedev_count + infra_count + template_count))

cat > "$OUTPUT" << 'HEADER'
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
git clone https://github.com/your-github-username/agentic-config.git
cd agentic-config
chmod +x install.sh
./install.sh
```

### Windows (PowerShell)

```powershell
git clone https://github.com/your-github-username/agentic-config.git
cd agentic-config
.\install.ps1
```

The installer will:
1. Back up your existing `~/.claude/` config (if any)
2. Ask which skill tiers you want to install
3. Copy files and configure hooks
4. Print next steps for customization

HEADER

cat >> "$OUTPUT" << EOF
## What's Included

**${total_count} skills** across 4 tiers, **3 hooks**, **2 rule files**, and a pre-configured settings template.

### Hooks

| Hook | Trigger | Purpose |
|------|---------|---------|
| \`git-safety.sh\` | Before any Bash command | Blocks destructive git operations (\`--force\`, \`--amend\`, \`reset --hard\`, etc.) |
| \`init-project.sh\` | Session start | Creates \`.claude/\` directory and session journal in new projects |
| \`session-journal.sh\` | Before context compaction | Saves session state so context survives compaction |

### Rules

| Rule File | Purpose |
|-----------|---------|
| \`review-patterns.md\` | Review priority ordering (correctness > security > architecture > performance > tests > style) and document type taxonomy |
| \`skills.md\` | Master skill registry with invocation patterns and composition flows |

### Settings

The \`settings.template.json\` provides:
- Model defaults (Sonnet for speed, Opus for depth)
- Hook wiring for all 3 hooks
- Environment variables for experimental features (tool search, agent teams)
- Always-thinking mode enabled
- Empty permissions array (builds up as you use Claude Code)

---

## Skills

### Core (${core_count} skills) — Always installed

These are universally useful regardless of what you're building.

EOF

generate_tier_table "${SKILLS_DIR}/core" >> "$OUTPUT"

cat >> "$OUTPUT" << EOF

### Game Dev (${gamedev_count} skills) — Optional

Solo game development workflows with ADHD-adapted productivity patterns. These encode universal patterns, not personal data.

EOF

generate_tier_table "${SKILLS_DIR}/game-dev" >> "$OUTPUT"

cat >> "$OUTPUT" << EOF

### Infrastructure (${infra_count} skills) — Optional

Kubernetes homelab management with GitOps workflows. Useful for anyone running a similar stack (Talos, Ceph, Cilium, Flux).

EOF

generate_tier_table "${SKILLS_DIR}/infra" >> "$OUTPUT"

cat >> "$OUTPUT" << EOF

### Templates (${template_count} skill template(s)) — Optional

Skeleton skills for deeply personal customization. These provide the structure and guidance to build your own version.

EOF

generate_tier_table "${SKILLS_DIR}/templates" >> "$OUTPUT"

cat >> "$OUTPUT" << 'FOOTER'

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
FOOTER

echo "Generated: ${OUTPUT}"
echo "Skills documented: ${total_count} (${core_count} core, ${gamedev_count} game-dev, ${infra_count} infra, ${template_count} templates)"
