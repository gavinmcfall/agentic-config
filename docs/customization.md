# Customization Guide

After installing agentic-config, you'll want to personalize it for your workflow.

## What to Customize First

### 1. CLAUDE.md (Global Instructions)

Edit `~/.claude/CLAUDE.md` to match your workflow:

- **Core Rules**: Review each rule. Remove any that don't apply to you, add your own.
- **Session Journal**: Keep this section if you want context to survive compaction. Adjust the format if needed.
- **Extended Context**: If you have access to a cloud provider with extended context models, fill in your credentials. Otherwise, remove this section.

### 2. Settings

The `settings.json` starts with an empty permissions array. As you use Claude Code, you'll be prompted to approve tool usage. Approved patterns accumulate in this file automatically.

Settings you might want to change:
- `model` / `defaultModel`: Change the default models
- `defaultMode`: Set to `"default"` if you want permission prompts (safer but slower)
- `alwaysThinkingEnabled`: Set to `false` if you prefer faster responses

### 3. Rules

The `rules/` directory contains files that are always injected into Claude's context:

- **review-patterns.md**: Defines review priority order and document type taxonomy. Adjust if your priorities differ.
- **skills.md**: The master skill registry. Update this when you add or remove skills. Claude uses this to know what skills are available.

### 4. Hooks

Three hooks are included:

- **git-safety.sh**: Blocks dangerous git operations. You can customize the blocked patterns list.
- **init-project.sh**: Creates `.claude/` directory and session journal on session start. Generally no changes needed.
- **session-journal.sh**: Manages the session journal on compaction. Adjust line limits if needed.

### 5. Output Styles

Output styles live in `~/.claude/output-styles/` and shape how Claude behaves in specific contexts. The included `thinking-partner.md` defines a reasoning-first approach.

You can create additional output styles for different work modes — e.g., a "teacher" style that explains everything, a "terse" style for rapid iteration, or a project-specific style.

### 6. Custom Agents

Custom agents live in `~/.claude/agents/` and define specialized agent behaviors with specific tools and constraints. The included `researcher.md` defines an evidence-first research agent with citation requirements.

Create your own agents for repeated workflows — e.g., a "reviewer" agent for code review, a "deployer" agent for infrastructure tasks.

### 7. AGENTS.md Symlink

For multi-tool compatibility, create an `AGENTS.md` symlink in your project root pointing to your `CLAUDE.md`:

```bash
ln -s CLAUDE.md AGENTS.md
```

This ensures both Claude Code (which reads `CLAUDE.md`) and other agent frameworks (which may look for `AGENTS.md`) find your project instructions.

### 8. Skills

Each skill lives in `~/.claude/skills/<name>/SKILL.md`. You can:
- Edit any skill's content to match your terminology and workflow
- Delete skills you don't use
- Create new skills following the skill-builder patterns

## Creating Your Own Skills

The `skill-builder` skill (in core tier) defines the canonical skill structure:

```
skill-name/
├── SKILL.md           # YAML frontmatter + markdown content
└── references/        # Supporting reference material
    └── *.md
```

To create a new skill:
1. Create the directory under `~/.claude/skills/`
2. Write a `SKILL.md` with YAML frontmatter (name, description)
3. Add reference files if the skill needs supporting material
4. Update `~/.claude/rules/skills.md` to include it in the registry

## Adding MCP Servers

MCP servers extend Claude Code with additional tools. Add them to your project's `.mcp.json`:

```json
{
  "mcpServers": {
    "server-name": {
      "command": "npx",
      "args": ["-y", "package-name"],
      "env": {
        "API_KEY": "your-key"
      }
    }
  }
}
```

## Platform-Specific Notes

### Windows
- Hook scripts require Git Bash or PowerShell equivalents
- The installer attempts to detect Git Bash and configure hooks accordingly
- If hooks don't work, check that `bash` is in your PATH

### macOS
- You may need to allow the hook scripts through Gatekeeper on first run
- Use `xattr -d com.apple.quarantine ~/.claude/hooks/*.sh` if they're blocked

### WSL
- Everything works as on native Linux
- The config lives in the WSL filesystem, not the Windows side
