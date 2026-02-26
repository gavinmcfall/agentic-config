#!/bin/bash
# Git safety hook - block destructive git operations
# Location: ~/.claude/hooks/git-safety.sh (global, all projects)

INPUT=$(cat /dev/stdin)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty')

# Skip non-git commands immediately
echo "$COMMAND" | grep -q "git " || exit 0

# Block patterns:
#   --amend        destroys previous commit after pre-commit hook failures
#   --no-verify    bypasses pre-commit hooks
#   --force / -f   force push destroys remote history
#   reset --hard   discards all uncommitted changes
#   checkout .     discards all working tree changes
#   restore .      discards all working tree changes
#   clean -f       deletes untracked files permanently
#   branch -D      force-deletes branches without merge check

if echo "$COMMAND" | grep -qE 'git\s+(commit\s+.*--(amend|no-verify)|push\s+.*--(force|force-with-lease)|\bpush\s+-f\b|reset\s+--hard|checkout\s+\.|restore\s+\.|clean\s+-f|branch\s+-D)'; then
  MATCHED=$(echo "$COMMAND" | grep -oE '(--(amend|no-verify|force|force-with-lease|hard)|checkout \.|restore \.|clean -f|branch -D|-f)' | head -1)
  echo "BLOCKED: dangerous git operation '${MATCHED}'. Ask the user for explicit permission first." >&2
  exit 2
fi

exit 0
