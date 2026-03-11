#!/bin/bash

PROJECT_DIR="${CLAUDE_PROJECT_DIR:-.}"
CLAUDE_DIR="$PROJECT_DIR/.claude"

# Create .claude directory if it doesn't exist
if [ ! -d "$CLAUDE_DIR" ]; then
    mkdir -p "$CLAUDE_DIR"
fi

# Create session journal if it doesn't exist — single source of truth for the template
if [ ! -f "$CLAUDE_DIR/session-journal.md" ]; then
    cat > "$CLAUDE_DIR/session-journal.md" << 'EOF'
# Session Journal

A living journal that persists across compactions. Captures decisions, progress, and context.

## Current State
- **Focus:** (what's being worked on right now)
- **Blocked:** (anything blocking progress, or "nothing")

## Log
<!-- Newest entries at top. Format: ### YYYY-MM-DD HH:MM — Event type: brief description -->
EOF
fi

exit 0
