#!/usr/bin/env bash
# config-packager: Audit, sanitize, and package ~/.claude/ config
# Usage: package.sh [--audit|--diff|--package] [--auto] [--repo PATH]
#
# Modes:
#   --audit    Inventory ~/.claude/ and classify files
#   --diff     Compare current state against last packaged version
#   --package  Sanitize and copy files to distribution repo
#   --auto     Skip interactive prompts (for CI or trusted runs)
#   --repo     Path to distribution repo (default: ~/my_other_repos/agentic-config)
#
# Output: Structured status lines parseable by Claude
# Exit codes: 0 = success, 1 = error, 2 = validation failure

set -euo pipefail

# --- Configuration ---
CLAUDE_DIR="${HOME}/.claude"
DEFAULT_REPO="${HOME}/my_other_repos/agentic-config"
REPO_DIR="${DEFAULT_REPO}"
AUTO_MODE=false
MODE=""

# --- Sanitization patterns ---
# Format: "pattern|replacement|description"
# CUSTOMIZE THESE: Replace example values with your own personal data
SANITIZE_PATTERNS=(
  '/home/youruser|$HOME|Personal home path'
  '/Users/youruser|$HOME|macOS home path'
  '/mnt/c/Users/youruser|/mnt/c/Users/$USER|WSL Windows path'
  'you@yourdomain.com|your-email@example.com|Personal email'
  'Your Full Name|Your Name|Full name'
  'your-gh-username|your-github-username|GitHub username'
  'yourdomain\.com|yourdomain.com|Personal domain'
  'yourhandle|your-handle|Personal handle'
  'YourSurname|YourSurname|Surname'
  'EMPLOYER_UPPER|YOUR_PROVIDER|Employer (uppercase)'
  'EmployerCamel|YourPlatform|Employer (camelCase)'
  'Employer_Title|Your_Provider|Employer (titlecase)'
  'employer_lower|your_provider|Employer (lowercase)'
  'AWS_ACCESS_KEY_ID_EMPLOYER_BEDROCK|AWS_ACCESS_KEY_ID_BEDROCK|Employer env var'
  'AWS_SECRET_ACCESS_KEY_EMPLOYER_BEDROCK|AWS_SECRET_ACCESS_KEY_BEDROCK|Employer env var'
  'AWS_REGION_EMPLOYER_BEDROCK|AWS_REGION_BEDROCK|Employer env var'
  'MyCluster|your-cluster|Cluster name (capitalized)'
  'mycluster|your-cluster|Cluster name (lowercase)'
  'op://Personal/|op://YourVault/|1Password vault'
)

# Files/dirs to always exclude
EXCLUDE_FILES=(
  ".credentials.json"
  ".claude.json"
  ".claude.zip"
  "settings.local.json"
  "history.jsonl"
  "stats-cache.json"
  "mcp-needs-auth-cache.json"
  "load-mcp-env.sh"
)

EXCLUDE_DIRS=(
  "projects"
  "plans"
  "tasks"
  "teams"
  "ide"
  "file-history"
  "image-cache"
  "paste-cache"
  "session-env"
  "shell-snapshots"
  "debug"
  "cache"
  "statsig"
  "telemetry"
  "backups"
  "plugins"
  "scripts"
  "memory"
)

# Skill tier assignments
declare -A SKILL_TIERS
# Core
for s in using-skills skill-builder writing-documents code-review review-responder research mermaid-diagrams domain-expert; do
  SKILL_TIERS[$s]="core"
done
# Game Dev
for s in adhd-coach session-planner sprint-manager scope-guardian decision-journal learning-planner boot-dev-companion game-research gdd-writer prototype-coach art-pipeline sound-designer playtest-coordinator steam-publisher; do
  SKILL_TIERS[$s]="game-dev"
done
# Infra
for s in home-ops-deployer k8s-operator n8n-workflow-builder; do
  SKILL_TIERS[$s]="infra"
done
# Templates
SKILL_TIERS[inner-ally]="templates"
# The config-packager skill itself is not distributed
SKILL_TIERS[config-packager]="exclude"

# --- Parse arguments ---
while [[ $# -gt 0 ]]; do
  case $1 in
    --audit)   MODE="audit"; shift ;;
    --diff)    MODE="diff"; shift ;;
    --package) MODE="package"; shift ;;
    --auto)    AUTO_MODE=true; shift ;;
    --repo)    REPO_DIR="$2"; shift 2 ;;
    *)         echo "Unknown option: $1"; exit 1 ;;
  esac
done

if [[ -z "$MODE" ]]; then
  echo "Usage: package.sh [--audit|--diff|--package] [--auto] [--repo PATH]"
  exit 1
fi

# --- Helper functions ---

is_excluded_file() {
  local filename="$1"
  for f in "${EXCLUDE_FILES[@]}"; do
    [[ "$filename" == "$f" ]] && return 0
  done
  return 1
}

is_excluded_dir() {
  local dirname="$1"
  for d in "${EXCLUDE_DIRS[@]}"; do
    [[ "$dirname" == "$d" ]] && return 0
  done
  return 1
}

sanitize_file() {
  local src="$1"
  local dst="$2"

  mkdir -p "$(dirname "$dst")"
  cp "$src" "$dst"

  for pattern_entry in "${SANITIZE_PATTERNS[@]}"; do
    IFS='|' read -r pattern replacement description <<< "$pattern_entry"
    # Use sed with | delimiter to avoid conflicts with paths
    if [[ "$(uname)" == "Darwin" ]]; then
      sed -i '' "s|${pattern}|${replacement}|g" "$dst" 2>/dev/null || true
    else
      sed -i "s|${pattern}|${replacement}|g" "$dst" 2>/dev/null || true
    fi
  done
}

sanitize_name_in_context() {
  # Handle standalone first-name references (person context, not part of paths)
  # CUSTOMIZE: Replace "YourName" with your actual first name in the sed patterns below
  local name="YourName"  # <-- CHANGE THIS to your first name
  local file="$1"
  if [[ "$(uname)" == "Darwin" ]]; then
    sed -i '' "s/\bfor ${name}\b/for the user/g; s/\babout ${name}\b/about the user/g; s/\b${name} is\b/The user is/g; s/\b${name}'s\b/The user's/g; s/\bknows ${name}\b/knows the user/g; s/\b${name} needs\b/The user needs/g; s/\b${name} was\b/The user was/g; s/\b${name} can\b/The user can/g; s/\b${name} will\b/The user will/g" "$file" 2>/dev/null || true
    sed -i '' "s/ ${name} / the user /g; s/^${name} /The user /g" "$file" 2>/dev/null || true
  else
    sed -i "s/\bfor ${name}\b/for the user/g; s/\babout ${name}\b/about the user/g; s/\b${name} is\b/The user is/g; s/\b${name}'s\b/The user's/g; s/\bknows ${name}\b/knows the user/g; s/\b${name} needs\b/The user needs/g; s/\b${name} was\b/The user was/g; s/\b${name} can\b/The user can/g; s/\b${name} will\b/The user will/g" "$file" 2>/dev/null || true
    sed -i "s/ ${name} / the user /g; s/^${name} /The user /g" "$file" 2>/dev/null || true
  fi
}

# --- Audit Mode ---
audit() {
  echo "Status: AUDIT_START"
  echo "Source: ${CLAUDE_DIR}"
  echo "Target: ${REPO_DIR}"
  echo ""

  local total=0
  local include=0
  local sanitize=0
  local exclude=0

  echo "=== Top-Level Files ==="
  for f in "${CLAUDE_DIR}"/*; do
    [[ ! -e "$f" ]] && continue
    [[ -d "$f" ]] && continue
    local name=$(basename "$f")
    total=$((total + 1))

    if is_excluded_file "$name"; then
      echo "  EXCLUDE  $name"
      exclude=$((exclude + 1))
    elif [[ "$name" == "CLAUDE.md" ]]; then
      echo "  SANITIZE $name"
      sanitize=$((sanitize + 1))
    elif [[ "$name" == "settings.json" ]]; then
      echo "  TEMPLATE $name -> settings.template.json"
      sanitize=$((sanitize + 1))
    else
      echo "  EXCLUDE  $name (not in inclusion list)"
      exclude=$((exclude + 1))
    fi
  done

  echo ""
  echo "=== Directories ==="
  for d in "${CLAUDE_DIR}"/*/; do
    [[ ! -d "$d" ]] && continue
    local name=$(basename "$d")

    if is_excluded_dir "$name"; then
      echo "  EXCLUDE  $name/"
      local count=$(find "$d" -type f 2>/dev/null | wc -l)
      exclude=$((exclude + count))
      total=$((total + count))
    elif [[ "$name" == "rules" ]]; then
      echo "  SANITIZE $name/"
      local count=$(find "$d" -type f 2>/dev/null | wc -l)
      sanitize=$((sanitize + count))
      total=$((total + count))
    elif [[ "$name" == "hooks" ]]; then
      echo "  INCLUDE  $name/"
      local count=$(find "$d" -type f 2>/dev/null | wc -l)
      include=$((include + count))
      total=$((total + count))
    elif [[ "$name" == "skills" ]]; then
      echo "  PER-SKILL $name/"
      for skill_dir in "$d"/*/; do
        [[ ! -d "$skill_dir" ]] && continue
        local skill_name=$(basename "$skill_dir")
        local tier="${SKILL_TIERS[$skill_name]:-unknown}"

        if [[ "$tier" == "exclude" ]]; then
          echo "    EXCLUDE  $skill_name (not distributed)"
          local count=$(find "$skill_dir" -type f 2>/dev/null | wc -l)
          exclude=$((exclude + count))
          total=$((total + count))
        elif [[ "$tier" == "templates" ]]; then
          echo "    SKELETON $skill_name -> templates/$skill_name"
          local count=$(find "$skill_dir" -type f 2>/dev/null | wc -l)
          sanitize=$((sanitize + count))
          total=$((total + count))
        elif [[ "$tier" == "unknown" ]]; then
          echo "    WARNING  $skill_name (no tier assigned!)"
          exclude=$((exclude + 1))
          total=$((total + 1))
        else
          # Count files excluding meta/
          local skill_files=$(find "$skill_dir" -type f -not -path "*/meta/*" 2>/dev/null | wc -l)
          local meta_files=$(find "$skill_dir" -path "*/meta/*" -type f 2>/dev/null | wc -l)
          echo "    TIER:${tier} $skill_name (${skill_files} files, ${meta_files} meta excluded)"
          sanitize=$((sanitize + skill_files))
          exclude=$((exclude + meta_files))
          total=$((total + skill_files + meta_files))
        fi
      done
    else
      echo "  EXCLUDE  $name/ (not in inclusion list)"
      local count=$(find "$d" -type f 2>/dev/null | wc -l)
      exclude=$((exclude + count))
      total=$((total + count))
    fi
  done

  echo ""
  echo "Status: AUDIT_COMPLETE"
  echo "Files found: ${total}"
  echo "Files to include: ${include}"
  echo "Files to sanitize: ${sanitize}"
  echo "Files to exclude: ${exclude}"
}

# --- Diff Mode ---
diff_check() {
  echo "Status: DIFF_START"

  local metadata_file="${REPO_DIR}/.packager/last-packaged.json"

  if [[ ! -f "$metadata_file" ]]; then
    echo "No previous packaging found. All files will be treated as new."
    echo "Status: DIFF_COMPLETE"
    echo "Result: FIRST_RUN"
    return
  fi

  local new_files=0
  local changed_files=0
  local deleted_files=0

  # Compare current skills against packaged
  echo "=== Changes Since Last Package ==="

  # Check for new or modified skills
  for skill_dir in "${CLAUDE_DIR}/skills"/*/; do
    [[ ! -d "$skill_dir" ]] && continue
    local skill_name=$(basename "$skill_dir")
    local tier="${SKILL_TIERS[$skill_name]:-unknown}"
    [[ "$tier" == "exclude" || "$tier" == "unknown" ]] && continue

    local target_dir="${REPO_DIR}/config/skills/${tier}/${skill_name}"
    if [[ ! -d "$target_dir" ]]; then
      echo "  NEW     skill: ${skill_name} (tier: ${tier})"
      new_files=$((new_files + 1))
    else
      # Check if SKILL.md changed
      if [[ -f "$skill_dir/SKILL.md" ]] && [[ -f "$target_dir/SKILL.md" ]]; then
        if ! diff -q "$skill_dir/SKILL.md" "$target_dir/SKILL.md" > /dev/null 2>&1; then
          echo "  CHANGED skill: ${skill_name}/SKILL.md"
          changed_files=$((changed_files + 1))
        fi
      fi
    fi
  done

  # Check top-level files
  for check_file in CLAUDE.md; do
    if [[ -f "${CLAUDE_DIR}/${check_file}" ]] && [[ -f "${REPO_DIR}/config/${check_file}" ]]; then
      if ! diff -q "${CLAUDE_DIR}/${check_file}" "${REPO_DIR}/config/${check_file}" > /dev/null 2>&1; then
        echo "  CHANGED ${check_file} (source differs from packaged)"
        changed_files=$((changed_files + 1))
      fi
    fi
  done

  echo ""
  echo "Status: DIFF_COMPLETE"
  echo "New files: ${new_files}"
  echo "Changed files: ${changed_files}"
  echo "Deleted files: ${deleted_files}"
}

# --- Package Mode ---
package() {
  echo "Status: PACKAGE_START"
  echo "Source: ${CLAUDE_DIR}"
  echo "Target: ${REPO_DIR}"

  # Create repo structure
  mkdir -p "${REPO_DIR}/config/rules"
  mkdir -p "${REPO_DIR}/config/hooks"
  mkdir -p "${REPO_DIR}/config/skills/core"
  mkdir -p "${REPO_DIR}/config/skills/game-dev"
  mkdir -p "${REPO_DIR}/config/skills/infra"
  mkdir -p "${REPO_DIR}/config/skills/templates"
  mkdir -p "${REPO_DIR}/docs"
  mkdir -p "${REPO_DIR}/.packager"

  local replacements=0

  # --- CLAUDE.md ---
  echo "Packaging: CLAUDE.md"
  sanitize_file "${CLAUDE_DIR}/CLAUDE.md" "${REPO_DIR}/config/CLAUDE.md"
  sanitize_name_in_context "${REPO_DIR}/config/CLAUDE.md"
  replacements=$((replacements + 1))

  # --- Rules ---
  echo "Packaging: rules/"
  for rule_file in "${CLAUDE_DIR}/rules"/*.md; do
    [[ ! -f "$rule_file" ]] && continue
    local name=$(basename "$rule_file")
    sanitize_file "$rule_file" "${REPO_DIR}/config/rules/${name}"
    sanitize_name_in_context "${REPO_DIR}/config/rules/${name}"
    echo "  Sanitized: rules/${name}"
    replacements=$((replacements + 1))
  done

  # --- Hooks ---
  echo "Packaging: hooks/"
  for hook_file in "${CLAUDE_DIR}/hooks"/*.sh; do
    [[ ! -f "$hook_file" ]] && continue
    local name=$(basename "$hook_file")
    cp "$hook_file" "${REPO_DIR}/config/hooks/${name}"
    chmod +x "${REPO_DIR}/config/hooks/${name}"
    echo "  Copied: hooks/${name}"
  done

  # --- Ethos ---
  if [[ -f "${CLAUDE_DIR}/Ethos.md" ]]; then
    echo "Packaging: Ethos.md"
    sanitize_file "${CLAUDE_DIR}/Ethos.md" "${REPO_DIR}/config/Ethos.md"
    sanitize_name_in_context "${REPO_DIR}/config/Ethos.md"
    replacements=$((replacements + 1))
  fi

  # --- Output styles ---
  if [[ -d "${CLAUDE_DIR}/output-styles" ]]; then
    echo "Packaging: output-styles/"
    mkdir -p "${REPO_DIR}/config/output-styles"
    for style_file in "${CLAUDE_DIR}/output-styles"/*.md; do
      [[ ! -f "$style_file" ]] && continue
      local name=$(basename "$style_file")
      sanitize_file "$style_file" "${REPO_DIR}/config/output-styles/${name}"
      sanitize_name_in_context "${REPO_DIR}/config/output-styles/${name}"
      echo "  Sanitized: output-styles/${name}"
      replacements=$((replacements + 1))
    done
  fi

  # --- Agents ---
  if [[ -d "${CLAUDE_DIR}/agents" ]]; then
    echo "Packaging: agents/"
    mkdir -p "${REPO_DIR}/config/agents"
    for agent_file in "${CLAUDE_DIR}/agents"/*.md; do
      [[ ! -f "$agent_file" ]] && continue
      local name=$(basename "$agent_file")
      sanitize_file "$agent_file" "${REPO_DIR}/config/agents/${name}"
      sanitize_name_in_context "${REPO_DIR}/config/agents/${name}"
      echo "  Sanitized: agents/${name}"
      replacements=$((replacements + 1))
    done
  fi

  # --- Settings template ---
  echo "Packaging: settings.template.json"
  generate_settings_template
  replacements=$((replacements + 1))

  # --- Skills ---
  echo "Packaging: skills/"
  for skill_dir in "${CLAUDE_DIR}/skills"/*/; do
    [[ ! -d "$skill_dir" ]] && continue
    local skill_name=$(basename "$skill_dir")
    local tier="${SKILL_TIERS[$skill_name]:-unknown}"

    if [[ "$tier" == "exclude" || "$tier" == "unknown" ]]; then
      echo "  Skipping: ${skill_name} (${tier})"
      continue
    fi

    local target_base="${REPO_DIR}/config/skills/${tier}/${skill_name}"

    if [[ "$tier" == "templates" ]]; then
      echo "  Skeleton: ${skill_name} -> templates/${skill_name}"
      # inner-ally gets the skeleton treatment - handled separately during repo setup
      mkdir -p "${target_base}"
      # Don't copy anything - the skeleton is generated during repo setup
      continue
    fi

    mkdir -p "${target_base}"

    # Copy SKILL.md (sanitized)
    if [[ -f "${skill_dir}/SKILL.md" ]]; then
      sanitize_file "${skill_dir}/SKILL.md" "${target_base}/SKILL.md"
      sanitize_name_in_context "${target_base}/SKILL.md"
      echo "  Sanitized: ${skill_name}/SKILL.md"
      replacements=$((replacements + 1))
    fi

    # Copy references/ (sanitized, skip meta/)
    if [[ -d "${skill_dir}/references" ]]; then
      mkdir -p "${target_base}/references"
      find "${skill_dir}/references" -type f | while read -r ref_file; do
        local rel_path="${ref_file#${skill_dir}/references/}"
        local target_file="${target_base}/references/${rel_path}"
        mkdir -p "$(dirname "$target_file")"
        sanitize_file "$ref_file" "$target_file"
        sanitize_name_in_context "$target_file"
        replacements=$((replacements + 1))
      done
      echo "  Sanitized: ${skill_name}/references/"
    fi

    # Copy scripts/ if present (sanitized)
    if [[ -d "${skill_dir}/scripts" ]]; then
      mkdir -p "${target_base}/scripts"
      for script_file in "${skill_dir}/scripts"/*; do
        [[ ! -f "$script_file" ]] && continue
        local script_name=$(basename "$script_file")
        sanitize_file "$script_file" "${target_base}/scripts/${script_name}"
        chmod +x "${target_base}/scripts/${script_name}"
        replacements=$((replacements + 1))
      done
      echo "  Sanitized: ${skill_name}/scripts/"
    fi
  done

  # Save packaging metadata
  cat > "${REPO_DIR}/.packager/last-packaged.json" << EOF
{
  "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "source": "${CLAUDE_DIR}",
  "skills_packaged": $(ls -d "${CLAUDE_DIR}/skills"/*/ 2>/dev/null | wc -l),
  "patterns_applied": ${#SANITIZE_PATTERNS[@]}
}
EOF

  echo ""
  echo "Status: PACKAGE_COMPLETE"
  echo "Patterns applied: ${#SANITIZE_PATTERNS[@]}"
  echo "Replacements made: ${replacements}"
}

generate_settings_template() {
  cat > "${REPO_DIR}/config/settings.template.json" << 'SETTINGS_EOF'
{
  "env": {
    "ENABLE_TOOL_SEARCH": "true",
    "CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS": "1"
  },
  "permissions": {
    "allow": [],
    "defaultMode": "bypassPermissions"
  },
  "model": "sonnet",
  "defaultModel": "opus",
  "hooks": {
    "PreCompact": [
      {
        "matcher": "auto",
        "hooks": [
          {
            "type": "command",
            "command": "$HOME/.claude/hooks/session-journal.sh",
            "timeout": 30,
            "async": true
          }
        ]
      }
    ],
    "SessionStart": [
      {
        "matcher": "",
        "hooks": [
          {
            "type": "command",
            "command": "$HOME/.claude/hooks/init-project.sh"
          }
        ]
      },
      {
        "matcher": "compact",
        "hooks": [
          {
            "type": "command",
            "command": "cat .claude/session-journal.md 2>/dev/null || true"
          }
        ]
      }
    ],
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "$HOME/.claude/hooks/git-safety.sh"
          }
        ]
      }
    ]
  },
  "enabledPlugins": {},
  "alwaysThinkingEnabled": true,
  "skipDangerousModePermissionPrompt": true
}
SETTINGS_EOF
}

# --- Main ---
case "$MODE" in
  audit)   audit ;;
  diff)    diff_check ;;
  package) package ;;
esac
