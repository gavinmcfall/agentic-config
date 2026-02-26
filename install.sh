#!/usr/bin/env bash
# agentic-config installer for Linux / macOS / WSL
# Usage: ./install.sh [--force] [--dry-run] [--all]
#
# Options:
#   --force    Skip confirmation prompts
#   --dry-run  Show what would happen without making changes
#   --all      Install all tiers (core + game-dev + infra + templates)

set -euo pipefail

# --- Configuration ---
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CONFIG_SRC="${SCRIPT_DIR}/config"
CLAUDE_DIR="${HOME}/.claude"
FORCE=false
DRY_RUN=false
INSTALL_ALL=false

# Colors (if terminal supports them)
if [[ -t 1 ]]; then
  GREEN='\033[0;32m'
  YELLOW='\033[1;33m'
  RED='\033[0;31m'
  BLUE='\033[0;34m'
  BOLD='\033[1m'
  NC='\033[0m'
else
  GREEN='' YELLOW='' RED='' BLUE='' BOLD='' NC=''
fi

# --- Parse arguments ---
while [[ $# -gt 0 ]]; do
  case $1 in
    --force)   FORCE=true; shift ;;
    --dry-run) DRY_RUN=true; shift ;;
    --all)     INSTALL_ALL=true; shift ;;
    -h|--help)
      echo "Usage: ./install.sh [--force] [--dry-run] [--all]"
      echo ""
      echo "Options:"
      echo "  --force    Skip confirmation prompts"
      echo "  --dry-run  Show what would happen without making changes"
      echo "  --all      Install all tiers (core + game-dev + infra + templates)"
      exit 0
      ;;
    *) echo "Unknown option: $1"; exit 1 ;;
  esac
done

# --- Helper functions ---
info()  { echo -e "${BLUE}[INFO]${NC} $1"; }
ok()    { echo -e "${GREEN}[OK]${NC} $1"; }
warn()  { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; }

ask_yes_no() {
  if $FORCE; then return 0; fi
  local prompt="$1"
  echo -en "${BOLD}${prompt}${NC} [y/N] "
  read -r answer
  [[ "$answer" =~ ^[Yy] ]]
}

ask_tier() {
  if $INSTALL_ALL; then return 0; fi
  local tier="$1"
  local desc="$2"
  local count="$3"
  echo -en "  Install ${BOLD}${tier}${NC} tier? (${count} skills — ${desc}) [y/N] "
  read -r answer
  [[ "$answer" =~ ^[Yy] ]]
}

do_copy() {
  local src="$1"
  local dst="$2"
  if $DRY_RUN; then
    echo "  [DRY RUN] Would copy: $src -> $dst"
  else
    mkdir -p "$(dirname "$dst")"
    cp "$src" "$dst"
  fi
}

do_copy_dir() {
  local src="$1"
  local dst="$2"
  if $DRY_RUN; then
    echo "  [DRY RUN] Would copy directory: $src -> $dst"
  else
    mkdir -p "$dst"
    cp -r "$src"/* "$dst"/ 2>/dev/null || true
  fi
}

# --- Detect platform ---
PLATFORM="unknown"
case "$(uname -s)" in
  Linux*)
    if grep -qi microsoft /proc/version 2>/dev/null; then
      PLATFORM="wsl"
    else
      PLATFORM="linux"
    fi
    ;;
  Darwin*) PLATFORM="macos" ;;
esac

echo ""
echo -e "${BOLD}agentic-config installer${NC}"
echo "========================"
echo ""
info "Platform detected: ${PLATFORM}"
info "Source: ${CONFIG_SRC}"
info "Target: ${CLAUDE_DIR}"
echo ""

# --- Check source exists ---
if [[ ! -d "$CONFIG_SRC" ]]; then
  error "Config source directory not found at ${CONFIG_SRC}"
  exit 1
fi

# --- Backup existing config ---
if [[ -d "$CLAUDE_DIR" ]]; then
  warn "Existing Claude config found at ${CLAUDE_DIR}"

  if $DRY_RUN; then
    echo "  [DRY RUN] Would back up to ${CLAUDE_DIR}.backup.$(date +%s)/"
  elif ask_yes_no "Back up existing config before installing?"; then
    BACKUP_DIR="${CLAUDE_DIR}.backup.$(date +%s)"
    info "Backing up to ${BACKUP_DIR}/"

    # Only backup the files we'll overwrite, not the entire directory
    mkdir -p "$BACKUP_DIR"
    for item in CLAUDE.md settings.json rules hooks skills; do
      if [[ -e "${CLAUDE_DIR}/${item}" ]]; then
        cp -r "${CLAUDE_DIR}/${item}" "${BACKUP_DIR}/"
      fi
    done
    ok "Backup complete"
  fi
else
  info "No existing config found. Creating ${CLAUDE_DIR}/"
  if ! $DRY_RUN; then
    mkdir -p "$CLAUDE_DIR"
  fi
fi

echo ""

# --- Install CLAUDE.md ---
info "Installing CLAUDE.md (global instructions)..."
do_copy "${CONFIG_SRC}/CLAUDE.md" "${CLAUDE_DIR}/CLAUDE.md"
ok "CLAUDE.md installed"

# --- Install settings ---
info "Installing settings template..."
if [[ -f "${CLAUDE_DIR}/settings.json" ]] && ! $FORCE; then
  warn "settings.json already exists"
  if ask_yes_no "Overwrite with template? (Your permissions will be reset)"; then
    do_copy "${CONFIG_SRC}/settings.template.json" "${CLAUDE_DIR}/settings.json"
    ok "settings.json installed"
  else
    info "Keeping existing settings.json"
  fi
else
  do_copy "${CONFIG_SRC}/settings.template.json" "${CLAUDE_DIR}/settings.json"
  ok "settings.json installed"
fi

# --- Fix paths in settings.json ---
if ! $DRY_RUN && [[ -f "${CLAUDE_DIR}/settings.json" ]]; then
  if [[ "$(uname)" == "Darwin" ]]; then
    sed -i '' "s|\\\$HOME|${HOME}|g" "${CLAUDE_DIR}/settings.json"
  else
    sed -i "s|\\\$HOME|${HOME}|g" "${CLAUDE_DIR}/settings.json"
  fi
  ok "Paths resolved in settings.json"
fi

# --- Install rules ---
info "Installing rules..."
if ! $DRY_RUN; then
  mkdir -p "${CLAUDE_DIR}/rules"
fi
for rule_file in "${CONFIG_SRC}/rules"/*.md; do
  [[ ! -f "$rule_file" ]] && continue
  do_copy "$rule_file" "${CLAUDE_DIR}/rules/$(basename "$rule_file")"
done
ok "Rules installed"

# --- Install hooks ---
info "Installing hooks..."
if ! $DRY_RUN; then
  mkdir -p "${CLAUDE_DIR}/hooks"
fi
for hook_file in "${CONFIG_SRC}/hooks"/*.sh; do
  [[ ! -f "$hook_file" ]] && continue
  do_copy "$hook_file" "${CLAUDE_DIR}/hooks/$(basename "$hook_file")"
  if ! $DRY_RUN; then
    chmod +x "${CLAUDE_DIR}/hooks/$(basename "$hook_file")"
  fi
done
ok "Hooks installed (executable)"

# --- Install skills by tier ---
echo ""
echo -e "${BOLD}Skill Tiers${NC}"
echo ""

# Core (always installed)
CORE_COUNT=$(ls -d "${CONFIG_SRC}/skills/core"/*/ 2>/dev/null | wc -l)
info "Installing core skills (${CORE_COUNT} skills — always included)..."
if ! $DRY_RUN; then
  mkdir -p "${CLAUDE_DIR}/skills"
fi
for skill_dir in "${CONFIG_SRC}/skills/core"/*/; do
  [[ ! -d "$skill_dir" ]] && continue
  local_name=$(basename "$skill_dir")
  do_copy_dir "$skill_dir" "${CLAUDE_DIR}/skills/${local_name}"
done
ok "Core skills installed"

# Game Dev (optional)
GAMEDEV_COUNT=$(ls -d "${CONFIG_SRC}/skills/game-dev"/*/ 2>/dev/null | wc -l)
if [[ $GAMEDEV_COUNT -gt 0 ]]; then
  if ask_tier "game-dev" "solo game dev + ADHD workflows" "$GAMEDEV_COUNT"; then
    info "Installing game-dev skills..."
    for skill_dir in "${CONFIG_SRC}/skills/game-dev"/*/; do
      [[ ! -d "$skill_dir" ]] && continue
      local_name=$(basename "$skill_dir")
      do_copy_dir "$skill_dir" "${CLAUDE_DIR}/skills/${local_name}"
    done
    ok "Game-dev skills installed"
  fi
fi

# Infra (optional)
INFRA_COUNT=$(ls -d "${CONFIG_SRC}/skills/infra"/*/ 2>/dev/null | wc -l)
if [[ $INFRA_COUNT -gt 0 ]]; then
  if ask_tier "infra" "Kubernetes homelab management" "$INFRA_COUNT"; then
    info "Installing infra skills..."
    for skill_dir in "${CONFIG_SRC}/skills/infra"/*/; do
      [[ ! -d "$skill_dir" ]] && continue
      local_name=$(basename "$skill_dir")
      do_copy_dir "$skill_dir" "${CLAUDE_DIR}/skills/${local_name}"
    done
    ok "Infra skills installed"
  fi
fi

# Templates (optional)
TEMPLATE_COUNT=$(ls -d "${CONFIG_SRC}/skills/templates"/*/ 2>/dev/null | wc -l)
if [[ $TEMPLATE_COUNT -gt 0 ]]; then
  if ask_tier "templates" "skeleton skills for personal customization" "$TEMPLATE_COUNT"; then
    info "Installing template skills..."
    for skill_dir in "${CONFIG_SRC}/skills/templates"/*/; do
      [[ ! -d "$skill_dir" ]] && continue
      local_name=$(basename "$skill_dir")
      do_copy_dir "$skill_dir" "${CLAUDE_DIR}/skills/${local_name}"
    done
    ok "Template skills installed"
  fi
fi

# --- Summary ---
echo ""
echo -e "${BOLD}Installation Complete${NC}"
echo "====================="
echo ""
ok "Config installed to ${CLAUDE_DIR}/"
echo ""
echo -e "${BOLD}Next Steps:${NC}"
echo "  1. Review and customize ~/.claude/CLAUDE.md with your own rules"
echo "  2. Review ~/.claude/rules/skills.md to see available skills"
echo "  3. Start a Claude Code session — hooks will activate automatically"
echo "  4. Permissions will build up as you approve tool usage"
echo ""
echo "  For customization help, see: docs/customization.md"
echo ""
