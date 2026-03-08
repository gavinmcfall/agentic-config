#!/usr/bin/env bash
# config-packager: Validate distribution repo for PII leaks
# Usage: validate.sh [--repo PATH]
#
# Runs regex patterns against entire output directory.
# Exit codes: 0 = clean, 2 = violations found

set -euo pipefail

REPO_DIR="${HOME}/my_other_repos/agentic-config"
VIOLATIONS=0
VIOLATION_DETAILS=()

while [[ $# -gt 0 ]]; do
  case $1 in
    --repo) REPO_DIR="$2"; shift 2 ;;
    *)      echo "Unknown option: $1"; exit 1 ;;
  esac
done

if [[ ! -d "${REPO_DIR}/config" ]]; then
  echo "Error: No config directory found at ${REPO_DIR}/config"
  echo "Run package.sh --package first."
  exit 1
fi

echo "Status: VALIDATION_START"
echo "Target: ${REPO_DIR}/config"
echo ""

# --- Validation patterns ---
# Each pattern: "regex|description|allowlist_regex"

check_pattern() {
  local pattern="$1"
  local description="$2"
  local allowlist="${3:-}"

  local matches
  matches=$(grep -rn -P "$pattern" "${REPO_DIR}/config" "${REPO_DIR}/docs" "${REPO_DIR}/install.sh" "${REPO_DIR}/install.ps1" 2>/dev/null || true)

  # Filter out allowlisted matches
  if [[ -n "$allowlist" ]] && [[ -n "$matches" ]]; then
    matches=$(echo "$matches" | grep -v -P "$allowlist" || true)
  fi

  if [[ -n "$matches" ]]; then
    local count
    count=$(echo "$matches" | wc -l)
    echo "FAIL [${description}] - ${count} violation(s):"
    echo "$matches" | head -20 | while read -r line; do
      echo "  $line"
      VIOLATION_DETAILS+=("$line")
    done
    if [[ $count -gt 20 ]]; then
      echo "  ... and $((count - 20)) more"
    fi
    VIOLATIONS=$((VIOLATIONS + count))
    echo ""
  else
    echo "PASS [${description}]"
  fi
}

# --- Run checks ---

echo "=== Identity Checks ==="
# CUSTOMIZE THESE: Replace with your own name, domain, and employer patterns
check_pattern '(?i)(yourfirstname|yoursurname)' \
  "Personal name/surname" \
  '(your-github-username|your-name|your-email|YourSurname|\$HOME|the user)'

check_pattern 'yourdomain\.com' \
  "Personal domain" \
  'yourdomain\.com'

check_pattern '(?i)youremployer' \
  "Employer reference" \
  '(YOUR_PROVIDER|Your_Provider|your_provider)'

echo ""
echo "=== Path Checks ==="
check_pattern '/home/[a-z][a-z0-9_-]+/' \
  "Hardcoded home paths" \
  '(\$HOME|/home/username|/home/\$USER|/home/your)'

check_pattern '/Users/[a-z][a-z0-9_-]+/' \
  "Hardcoded macOS paths" \
  '(\$HOME|/Users/\$USER|/Users/username)'

check_pattern '/mnt/c/Users/[a-zA-Z]' \
  "Hardcoded WSL paths" \
  '/mnt/c/Users/\$USER'

echo ""
echo "=== Secret Checks ==="
check_pattern 'sk-ant-' \
  "Anthropic API key patterns" \
  ''

check_pattern 'op://Personal/' \
  "1Password personal vault references" \
  'op://YourVault'

echo ""
echo "=== Email Checks ==="
# Check for email addresses (excluding known safe ones)
check_pattern '[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}' \
  "Email addresses (review each)" \
  '(your-email@example\.com|user@example\.com|noreply@anthropic\.com|example\.com|placeholder|simulator\.amazonses\.com)'

echo ""
echo "=== Infrastructure Checks ==="
# CUSTOMIZE THESE: Replace with your own infrastructure and project names
check_pattern '(?i)\byourcluster\b' \
  "Cluster name" \
  'your-cluster'

check_pattern 'Your Personal Project' \
  "Personal project references" \
  ''

echo ""
echo "=== Results ==="
if [[ $VIOLATIONS -eq 0 ]]; then
  echo "Status: VALIDATION_COMPLETE"
  echo "Result: PASS (0 violations)"

  # Save report
  cat > "${REPO_DIR}/.packager/sanitization-report.txt" << EOF
Validation: PASS
Timestamp: $(date -u +%Y-%m-%dT%H:%M:%SZ)
Violations: 0
EOF
  exit 0
else
  echo "Status: VALIDATION_FAILED"
  echo "Violations: ${VIOLATIONS}"

  # Save report
  cat > "${REPO_DIR}/.packager/sanitization-report.txt" << EOF
Validation: FAIL
Timestamp: $(date -u +%Y-%m-%dT%H:%M:%SZ)
Violations: ${VIOLATIONS}
EOF
  exit 2
fi
