# Cross-Platform Considerations

The distribution must work on Linux, macOS, and Windows.

---

## Path Differences

| Platform | Config Location | Path Separator | Shell |
|----------|----------------|----------------|-------|
| Linux | `~/.claude/` | `/` | bash/zsh |
| macOS | `~/.claude/` | `/` | bash/zsh |
| Windows (native) | `%USERPROFILE%\.claude\` | `\` | PowerShell |
| WSL | `~/.claude/` | `/` | bash/zsh (same as Linux) |

## Install Script Requirements

### install.sh (Linux / macOS / WSL)

Target: `$HOME/.claude/`

Must handle:
- Platform detection (`uname -s` for Linux vs Darwin)
- Existing config backup (`$HOME/.claude.backup.$(date +%s)/`)
- Tier selection prompt (core always, game-dev/infra/templates optional)
- File copying with directory structure preservation
- `chmod +x` on all hook scripts
- Path substitution in `settings.template.json` (replace `$HOME` placeholder with actual home)
- Summary of what was installed
- Next-steps guidance

### install.ps1 (Windows PowerShell)

Target: `$env:USERPROFILE\.claude\`

Must handle:
- Existing config backup
- Tier selection prompt
- File copying (PowerShell `Copy-Item -Recurse`)
- No `chmod` needed (Windows doesn't use Unix permissions)
- Path substitution in settings template
- Hook script handling (see below)

### Hook Scripts on Windows

Shell scripts (`.sh`) don't run natively on Windows. Options:

1. **Git Bash** (recommended): Most Claude Code Windows users have Git installed, which includes Git Bash. Hook commands can use `bash -c` to invoke .sh scripts.
2. **PowerShell wrappers**: Create `.ps1` equivalents that replicate the hook logic.
3. **WSL**: If using WSL, hooks work as-is.

The install.ps1 should:
- Check if Git Bash is available (`where.exe bash`)
- If yes: configure hook commands as `bash $HOME/.claude/hooks/script-name.sh`
- If no: create PowerShell wrapper scripts in `hooks/` alongside the .sh files

### PowerShell Hook Equivalents

If creating PowerShell wrappers, each hook needs:

**git-safety.ps1**: Read stdin JSON, parse `tool_input.command`, match against blocked patterns, exit with code 2 to block.

**init-project.ps1**: Create `.claude/` directory and `session-journal.md` in project root if missing.

**session-journal.ps1**: Append compaction timestamp to session journal, trim if over 500 lines.

## Line Endings

The repo must use `.gitattributes` to enforce correct line endings:

```
*.sh    text eol=lf
*.ps1   text eol=crlf
*.md    text eol=lf
*.json  text eol=lf
```

This ensures:
- Shell scripts always use LF (required for bash)
- PowerShell scripts use CRLF (PowerShell convention)
- Markdown and JSON use LF (universal)

## File Permissions

- Git preserves the executable bit for tracked `.sh` files
- The install script must `chmod +x` after copying (in case permissions are lost)
- Windows ignores Unix permissions entirely

## Settings Template: Platform Awareness

The `settings.template.json` uses `$HOME` as a placeholder. The install script replaces it:

- Linux/macOS/WSL: Replaced with actual `$HOME` value (e.g., `/home/username`)
- Windows: Replaced with `$env:USERPROFILE` resolved value (e.g., `C:\Users\username`)

Hook command paths in settings must use the platform-appropriate path:
- Unix: `"/home/username/.claude/hooks/git-safety.sh"`
- Windows with Git Bash: `"bash C:\\Users\\username\\.claude\\hooks\\git-safety.sh"`
