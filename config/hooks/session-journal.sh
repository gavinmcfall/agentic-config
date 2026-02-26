#!/bin/bash

PROJECT_DIR="${CLAUDE_PROJECT_DIR:-.}"
JOURNAL="$PROJECT_DIR/.claude/session-journal.md"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Initialize journal if it doesn't exist
if [ ! -f "$JOURNAL" ]; then
    mkdir -p "$(dirname "$JOURNAL")"
    cat > "$JOURNAL" << 'EOF'
# Session Journal

This file maintains running context across compactions.

## Current Focus


## Recent Changes


## Key Decisions


## Important Context

EOF
fi

# Append session marker
echo "" >> "$JOURNAL"
echo "---" >> "$JOURNAL"
echo "**Session compacted at:** $TIMESTAMP" >> "$JOURNAL"
echo "" >> "$JOURNAL"

# Keep journal under 500 lines (trim oldest entries if needed)
if [ $(wc -l < "$JOURNAL") -gt 500 ]; then
    tail -n 400 "$JOURNAL" > "$JOURNAL.tmp"
    mv "$JOURNAL.tmp" "$JOURNAL"
fi

exit 0
