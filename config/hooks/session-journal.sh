#!/bin/bash
# Session journal maintenance — runs on PreCompact
# Does NOT append markers. Just trims if the journal is too long.
# Claude is responsible for writing meaningful entries (per CLAUDE.md).

PROJECT_DIR="${CLAUDE_PROJECT_DIR:-.}"
JOURNAL="$PROJECT_DIR/.claude/session-journal.md"

# Nothing to do if journal doesn't exist
[ -f "$JOURNAL" ] || exit 0

# Trim strategy: keep the header (everything up to and including "## Log")
# plus the newest entries. Oldest entries at the bottom get dropped.
TOTAL=$(wc -l < "$JOURNAL")
MAX_LINES=300

if [ "$TOTAL" -gt "$MAX_LINES" ]; then
    # Find the "## Log" line — entries below it are chronological (newest first)
    LOG_LINE=$(grep -n '^## Log' "$JOURNAL" | head -1 | cut -d: -f1)
    if [ -n "$LOG_LINE" ]; then
        HEADER_LINES=$((LOG_LINE + 1))
        # Keep header + first N entries after it (newest are at top)
        KEEP_ENTRIES=$((MAX_LINES - HEADER_LINES))
        { head -n "$HEADER_LINES" "$JOURNAL"; head -n "$((HEADER_LINES + KEEP_ENTRIES))" "$JOURNAL" | tail -n "$KEEP_ENTRIES"; } > "$JOURNAL.tmp"
        mv "$JOURNAL.tmp" "$JOURNAL"
    else
        # Fallback: no ## Log section found, keep first 300 lines
        head -n "$MAX_LINES" "$JOURNAL" > "$JOURNAL.tmp"
        mv "$JOURNAL.tmp" "$JOURNAL"
    fi
fi

exit 0
