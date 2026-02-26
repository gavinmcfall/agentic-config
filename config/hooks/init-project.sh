#!/bin/bash

PROJECT_DIR="${CLAUDE_PROJECT_DIR:-.}"
CLAUDE_DIR="$PROJECT_DIR/.claude"

# Note: We don't create .mcp.json anymore
# An empty mcpServers object is invalid per Claude Code schema
# Only create .mcp.json when you actually need project-specific MCP servers

# Create .claude directory if it doesn't exist
if [ ! -d "$CLAUDE_DIR" ]; then
    mkdir -p "$CLAUDE_DIR"
    echo "📁 Created .claude directory"
fi

# Create empty session journal if it doesn't exist
if [ ! -f "$CLAUDE_DIR/session-journal.md" ]; then
    cat > "$CLAUDE_DIR/session-journal.md" << 'EOF'
# Session Journal

This file maintains running context across compactions.

## Current Focus


## Recent Changes


## Key Decisions


## Important Context

EOF
    echo "📝 Initialized session journal"
fi

exit 0
