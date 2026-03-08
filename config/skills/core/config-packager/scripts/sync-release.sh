#!/usr/bin/env bash
# config-packager: Sync local changes and create a versioned GitHub release
# Usage: sync-release.sh [--major|--minor|--patch] [--auto] [--dry-run] [--repo PATH]
#
# Orchestrates: package → validate → readme → classify → commit → tag → push → release
#
# Flags:
#   --major    Force major version bump
#   --minor    Force minor version bump
#   --patch    Force patch version bump
#   --auto     Skip interactive prompts
#   --dry-run  Show what would happen without executing
#   --repo     Path to distribution repo (default: ~/my_other_repos/agentic-config)
#
# Exit codes: 0 = released, 1 = error, 2 = validation failure, 3 = no changes

set -euo pipefail

# --- Configuration ---
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEFAULT_REPO="${HOME}/my_other_repos/agentic-config"
REPO_DIR="${DEFAULT_REPO}"
AUTO_MODE=false
DRY_RUN=false
FORCE_BUMP=""

# --- Colors ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

log_info()  { echo -e "${BLUE}[INFO]${NC}  $*"; }
log_ok()    { echo -e "${GREEN}[OK]${NC}    $*"; }
log_warn()  { echo -e "${YELLOW}[WARN]${NC}  $*"; }
log_error() { echo -e "${RED}[ERROR]${NC} $*"; }
log_step()  { echo -e "${CYAN}[STEP]${NC}  $*"; }

# --- Parse arguments ---
while [[ $# -gt 0 ]]; do
  case $1 in
    --major)   FORCE_BUMP="major"; shift ;;
    --minor)   FORCE_BUMP="minor"; shift ;;
    --patch)   FORCE_BUMP="patch"; shift ;;
    --auto)    AUTO_MODE=true; shift ;;
    --dry-run) DRY_RUN=true; shift ;;
    --repo)    REPO_DIR="$2"; shift 2 ;;
    *)         echo "Unknown option: $1"; exit 1 ;;
  esac
done

# --- Helper: prompt for confirmation ---
confirm() {
  if [[ "$AUTO_MODE" == true ]]; then
    return 0
  fi
  local msg="${1:-Continue?}"
  echo ""
  read -rp "${msg} [Y/n] " response
  case "$response" in
    [nN]*) return 1 ;;
    *)     return 0 ;;
  esac
}

# --- Helper: parse semver from tag ---
parse_version() {
  local tag="$1"
  tag="${tag#v}"  # strip leading v
  echo "$tag"
}

bump_version() {
  local version="$1"
  local bump_type="$2"

  IFS='.' read -r major minor patch <<< "$version"

  case "$bump_type" in
    major) major=$((major + 1)); minor=0; patch=0 ;;
    minor) minor=$((minor + 1)); patch=0 ;;
    patch) patch=$((patch + 1)) ;;
  esac

  echo "${major}.${minor}.${patch}"
}

# =========================================================
# STEP 1: Pre-flight checks
# =========================================================
preflight() {
  log_step "1/11 Pre-flight checks"

  local errors=0

  # Check gh CLI
  if ! command -v gh &>/dev/null; then
    log_error "gh CLI not installed (needed for GitHub releases)"
    errors=$((errors + 1))
  fi

  # Check git repo
  if [[ ! -d "${REPO_DIR}/.git" ]]; then
    log_error "No git repo at ${REPO_DIR}"
    errors=$((errors + 1))
  fi

  # Check on main branch
  local branch
  branch=$(git -C "$REPO_DIR" branch --show-current 2>/dev/null || echo "")
  if [[ "$branch" != "main" ]]; then
    log_error "Not on main branch (on: ${branch:-unknown})"
    errors=$((errors + 1))
  fi

  # Check clean working tree
  if [[ -n "$(git -C "$REPO_DIR" status --porcelain 2>/dev/null)" ]]; then
    log_warn "Working tree has uncommitted changes — they will be included in this release"
  fi

  # Check sibling scripts exist
  for script in package.sh validate.sh generate-readme.sh; do
    if [[ ! -x "${SCRIPT_DIR}/${script}" ]]; then
      log_error "Missing required script: ${SCRIPT_DIR}/${script}"
      errors=$((errors + 1))
    fi
  done

  if [[ $errors -gt 0 ]]; then
    log_error "Pre-flight failed with ${errors} error(s)"
    exit 1
  fi

  log_ok "Pre-flight passed"
}

# =========================================================
# STEP 2-3: Package, then detect changes via git diff
# =========================================================
package_and_detect() {
  log_step "2/11 Packaging local config"
  "${SCRIPT_DIR}/package.sh" --package --auto --repo "$REPO_DIR"
  echo ""

  log_step "3/11 Detecting changes"

  # Stage everything so git diff --cached works
  git -C "$REPO_DIR" add -A

  # Get the diff summary
  DIFF_STAT=$(git -C "$REPO_DIR" diff --cached --stat 2>/dev/null || echo "")
  DIFF_NAMES=$(git -C "$REPO_DIR" diff --cached --name-status 2>/dev/null || echo "")

  if [[ -z "$DIFF_NAMES" ]]; then
    # Unstage
    git -C "$REPO_DIR" reset HEAD --quiet 2>/dev/null || true
    log_info "No changes detected since last release"
    exit 3
  fi

  # Parse changes into arrays
  NEW_FILES=()
  MODIFIED_FILES=()
  DELETED_FILES=()

  while IFS=$'\t' read -r status filepath; do
    case "$status" in
      A)  NEW_FILES+=("$filepath") ;;
      M)  MODIFIED_FILES+=("$filepath") ;;
      D)  DELETED_FILES+=("$filepath") ;;
      R*) MODIFIED_FILES+=("$filepath") ;;  # Rename treated as modification
    esac
  done <<< "$DIFF_NAMES"

  # Unstage for now (we'll re-stage at commit time)
  git -C "$REPO_DIR" reset HEAD --quiet 2>/dev/null || true

  log_ok "Changes detected: ${#NEW_FILES[@]} new, ${#MODIFIED_FILES[@]} modified, ${#DELETED_FILES[@]} deleted"

  # Show summary
  echo ""
  if [[ ${#NEW_FILES[@]} -gt 0 ]]; then
    echo -e "${GREEN}New files:${NC}"
    for f in "${NEW_FILES[@]}"; do
      echo "  + $f"
    done
  fi
  if [[ ${#MODIFIED_FILES[@]} -gt 0 ]]; then
    echo -e "${YELLOW}Modified files:${NC}"
    for f in "${MODIFIED_FILES[@]}"; do
      echo "  ~ $f"
    done
  fi
  if [[ ${#DELETED_FILES[@]} -gt 0 ]]; then
    echo -e "${RED}Deleted files:${NC}"
    for f in "${DELETED_FILES[@]}"; do
      echo "  - $f"
    done
  fi
  echo ""

  if ! confirm "Proceed with these changes?"; then
    log_info "Aborted by user"
    exit 0
  fi
}

# =========================================================
# STEP 4: Validate
# =========================================================
validate() {
  log_step "4/11 Validating for PII"
  if ! "${SCRIPT_DIR}/validate.sh" --repo "$REPO_DIR"; then
    log_error "Validation failed — cannot release with PII violations"
    exit 2
  fi
  echo ""
  log_ok "Validation passed"
}

# =========================================================
# STEP 5: Regenerate README
# =========================================================
regenerate_readme() {
  log_step "5/11 Regenerating README"
  "${SCRIPT_DIR}/generate-readme.sh" --repo "$REPO_DIR"
  log_ok "README updated"
}

# =========================================================
# STEP 6: Classify changes for semver
# =========================================================
classify_changes() {
  log_step "6/11 Classifying changes for version bump"

  SUGGESTED_BUMP="patch"

  # Check for deleted skills (major)
  for f in "${DELETED_FILES[@]}"; do
    if [[ "$f" == config/skills/*/SKILL.md ]]; then
      local skill_path="${f%/SKILL.md}"
      local skill_name="${skill_path##*/}"
      log_warn "Deleted skill detected: ${skill_name} → suggests MAJOR bump"
      SUGGESTED_BUMP="major"
    fi
  done

  # Check for new skills (minor, unless already major)
  if [[ "$SUGGESTED_BUMP" != "major" ]]; then
    for f in "${NEW_FILES[@]}"; do
      if [[ "$f" == config/skills/*/*/SKILL.md ]]; then
        local skill_path="${f%/SKILL.md}"
        local skill_name="${skill_path##*/}"
        log_info "New skill detected: ${skill_name} → suggests MINOR bump"
        SUGGESTED_BUMP="minor"
      elif [[ "$f" == config/*.md && "$f" != config/skills/* ]]; then
        log_info "New config file: ${f} → suggests MINOR bump"
        SUGGESTED_BUMP="minor"
      elif [[ "$f" == config/output-styles/* || "$f" == config/agents/* ]]; then
        log_info "New config type: ${f} → suggests MINOR bump"
        SUGGESTED_BUMP="minor"
      elif [[ "$f" == config/hooks/* ]]; then
        log_info "New hook: ${f} → suggests MINOR bump"
        SUGGESTED_BUMP="minor"
      fi
    done
  fi

  # Check for new references in existing skills (minor)
  if [[ "$SUGGESTED_BUMP" == "patch" ]]; then
    for f in "${NEW_FILES[@]}"; do
      if [[ "$f" == config/skills/*/references/* ]]; then
        log_info "New reference: ${f} → suggests MINOR bump"
        SUGGESTED_BUMP="minor"
        break
      fi
    done
  fi

  log_info "Suggested bump: ${SUGGESTED_BUMP}"
}

# =========================================================
# STEP 7: Determine version
# =========================================================
determine_version() {
  log_step "7/11 Determining version"

  # Get current version from latest tag
  local latest_tag
  latest_tag=$(git -C "$REPO_DIR" describe --tags --abbrev=0 2>/dev/null || echo "v0.0.0")
  CURRENT_VERSION=$(parse_version "$latest_tag")

  # Apply bump
  local bump_type="${FORCE_BUMP:-$SUGGESTED_BUMP}"

  if [[ -n "$FORCE_BUMP" ]]; then
    log_info "Using forced bump: ${FORCE_BUMP}"
  fi

  NEW_VERSION=$(bump_version "$CURRENT_VERSION" "$bump_type")
  BUMP_TYPE="$bump_type"

  log_info "Current: v${CURRENT_VERSION} → New: v${NEW_VERSION} (${bump_type})"

  if ! confirm "Release as v${NEW_VERSION}?"; then
    echo ""
    read -rp "Enter version (without v prefix): " custom_version
    if [[ -n "$custom_version" ]]; then
      NEW_VERSION="$custom_version"
      log_info "Using custom version: v${NEW_VERSION}"
    else
      log_info "Aborted by user"
      exit 0
    fi
  fi
}

# =========================================================
# STEP 8: Generate release notes
# =========================================================
generate_release_notes() {
  log_step "8/11 Generating release notes"

  RELEASE_NOTES=""

  if [[ ${#NEW_FILES[@]} -gt 0 ]]; then
    RELEASE_NOTES+="## What's New"$'\n'
    for f in "${NEW_FILES[@]}"; do
      # Skip packager metadata and generated files
      [[ "$f" == .packager/* ]] && continue
      [[ "$f" == README.md ]] && continue

      if [[ "$f" == config/skills/*/*/SKILL.md ]]; then
        local skill_path="${f%/SKILL.md}"
        local skill_name="${skill_path##*/}"
        local tier="${skill_path%/*}"
        tier="${tier##*/}"
        RELEASE_NOTES+="- Added \`${skill_name}\` skill (${tier} tier)"$'\n'
      elif [[ "$f" == config/skills/*/references/* ]]; then
        local ref_name="${f##*/}"
        local skill_part="${f#config/skills/*/}"
        skill_part="${skill_part%%/*}"
        RELEASE_NOTES+="- Added reference: ${f#config/}"$'\n'
      elif [[ "$f" == config/*.md ]]; then
        local filename="${f##*/}"
        RELEASE_NOTES+="- Added ${filename}"$'\n'
      elif [[ "$f" == config/output-styles/* || "$f" == config/agents/* ]]; then
        RELEASE_NOTES+="- Added ${f#config/}"$'\n'
      elif [[ "$f" == docs/* ]]; then
        RELEASE_NOTES+="- Added documentation: ${f#docs/}"$'\n'
      else
        RELEASE_NOTES+="- Added ${f}"$'\n'
      fi
    done
    RELEASE_NOTES+=$'\n'
  fi

  if [[ ${#MODIFIED_FILES[@]} -gt 0 ]]; then
    RELEASE_NOTES+="## Changes"$'\n'
    for f in "${MODIFIED_FILES[@]}"; do
      [[ "$f" == .packager/* ]] && continue
      [[ "$f" == README.md ]] && continue

      if [[ "$f" == config/skills/*/*/SKILL.md ]]; then
        local skill_path="${f%/SKILL.md}"
        local skill_name="${skill_path##*/}"
        RELEASE_NOTES+="- Updated \`${skill_name}\` skill"$'\n'
      elif [[ "$f" == config/skills/*/references/* ]]; then
        RELEASE_NOTES+="- Updated ${f#config/}"$'\n'
      else
        RELEASE_NOTES+="- Updated ${f}"$'\n'
      fi
    done
    RELEASE_NOTES+=$'\n'
  fi

  if [[ ${#DELETED_FILES[@]} -gt 0 ]]; then
    RELEASE_NOTES+="## Removed"$'\n'
    for f in "${DELETED_FILES[@]}"; do
      [[ "$f" == .packager/* ]] && continue
      RELEASE_NOTES+="- Removed ${f}"$'\n'
    done
    RELEASE_NOTES+=$'\n'
  fi

  # Add footer
  RELEASE_NOTES+="---"$'\n'
  RELEASE_NOTES+="Full changelog: https://github.com/your-github-username/agentic-config/compare/v${CURRENT_VERSION}...v${NEW_VERSION}"

  echo ""
  echo "=== Release Notes Preview ==="
  echo "$RELEASE_NOTES"
  echo "=============================="
  echo ""
}

# =========================================================
# STEP 9: Show preview (dry-run stops here)
# =========================================================
preview_and_confirm() {
  log_step "9/11 Release preview"

  echo ""
  echo "  Version: v${CURRENT_VERSION} → v${NEW_VERSION} (${BUMP_TYPE})"
  echo "  Changes: ${#NEW_FILES[@]} new, ${#MODIFIED_FILES[@]} modified, ${#DELETED_FILES[@]} deleted"
  echo "  Repo:    ${REPO_DIR}"
  echo ""

  if [[ "$DRY_RUN" == true ]]; then
    log_info "Dry run complete — no changes made"
    exit 0
  fi

  if ! confirm "Commit, tag, push, and create GitHub release?"; then
    log_info "Aborted by user"
    exit 0
  fi
}

# =========================================================
# STEP 10: Commit
# =========================================================
do_commit() {
  log_step "10/11 Committing"

  cd "$REPO_DIR"
  git add -A

  # Build commit summary
  local summary_parts=()
  if [[ ${#NEW_FILES[@]} -gt 0 ]]; then
    summary_parts+=("${#NEW_FILES[@]} new")
  fi
  if [[ ${#MODIFIED_FILES[@]} -gt 0 ]]; then
    summary_parts+=("${#MODIFIED_FILES[@]} updated")
  fi
  if [[ ${#DELETED_FILES[@]} -gt 0 ]]; then
    summary_parts+=("${#DELETED_FILES[@]} removed")
  fi
  local summary
  summary=$(IFS=', '; echo "${summary_parts[*]}")

  git commit -m "$(cat <<EOF
release: v${NEW_VERSION} — ${summary}

Co-Authored-By: Claude Opus 4.6 <noreply@anthropic.com>
EOF
)"

  log_ok "Committed: release v${NEW_VERSION}"
}

# =========================================================
# STEP 11: Tag, push, and release
# =========================================================
do_release() {
  log_step "11/11 Tagging, pushing, and creating release"

  cd "$REPO_DIR"

  # Tag
  git tag "v${NEW_VERSION}"
  log_ok "Tagged: v${NEW_VERSION}"

  # Push
  git push origin main
  git push origin "v${NEW_VERSION}"
  log_ok "Pushed to origin"

  # Create GitHub release
  local release_url
  release_url=$(gh release create "v${NEW_VERSION}" \
    --title "v${NEW_VERSION}" \
    --notes "$RELEASE_NOTES" 2>&1)

  log_ok "Release created: ${release_url}"

  # Update packager metadata
  mkdir -p "${REPO_DIR}/.packager"
  cat > "${REPO_DIR}/.packager/last-release.json" << EOF
{
  "version": "v${NEW_VERSION}",
  "previous_version": "v${CURRENT_VERSION}",
  "bump_type": "${BUMP_TYPE}",
  "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "new_files": ${#NEW_FILES[@]},
  "modified_files": ${#MODIFIED_FILES[@]},
  "deleted_files": ${#DELETED_FILES[@]}
}
EOF

  echo ""
  echo "============================================"
  log_ok "Released v${NEW_VERSION}"
  echo "  URL: ${release_url}"
  echo "============================================"
}

# =========================================================
# MAIN
# =========================================================
echo ""
echo "=== config-packager: Sync & Release ==="
echo ""

preflight
package_and_detect
validate
regenerate_readme
classify_changes
determine_version
generate_release_notes
preview_and_confirm
do_commit
do_release
