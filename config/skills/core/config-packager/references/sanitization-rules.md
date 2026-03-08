# Sanitization Rules

Two-pass approach: pattern replacement, then validation sweep.

> **Customize this file.** Replace the example patterns below with your own personal data. The structure shows what KIND of patterns to catch — fill in YOUR values.

---

## Pass 1: Pattern Replacements

Apply these in order during file copying. Case-sensitive unless noted.

### Identity Patterns

| Pattern | Replacement | Scope |
|---------|-------------|-------|
| `/home/youruser` | `$HOME` | All files |
| `/home/youruser/` | `$HOME/` | All files |
| `/Users/youruser` | `$HOME` | All files |
| `/mnt/c/Users/youruser` | `/mnt/c/Users/$USER` | All files |
| `you@yourdomain.com` | `your-email@example.com` | All files |
| `youruser` (in git author context) | `your-name` | Commit conventions only |
| `Your Full Name` | `Your Name` | All files |
| `Your First Name` (as person reference) | `the user` | Context-dependent, manual review |
| `your-github-username` (GitHub username) | `your-github-username` | All files |
| `yourdomain.com` | `yourdomain.com` | All files |

### Employer / Provider Patterns

| Pattern | Replacement | Scope |
|---------|-------------|-------|
| `YOUR_EMPLOYER` (all case variants) | `YOUR_PROVIDER` | All files (case-insensitive) |
| `AWS_ACCESS_KEY_ID_EMPLOYER_BEDROCK` | `AWS_ACCESS_KEY_ID_BEDROCK` | CLAUDE.md |
| `AWS_SECRET_ACCESS_KEY_EMPLOYER_BEDROCK` | `AWS_SECRET_ACCESS_KEY_BEDROCK` | CLAUDE.md |
| `AWS_REGION_EMPLOYER_BEDROCK` | `AWS_REGION_BEDROCK` | CLAUDE.md |

### Infrastructure Patterns

| Pattern | Replacement | Scope |
|---------|-------------|-------|
| Your cluster name | `your-cluster` | Infra skills |
| `op://Personal/` | `op://YourVault/` | All files |
| `op://` followed by vault path | `op://YourVault/item/field` | Review each |

### Secret Patterns

| Pattern | Replacement | Scope |
|---------|-------------|-------|
| `sk-ant-*` (Anthropic API key) | Remove entirely | All files |
| API key variable values | Keep var name, remove value | Scripts |
| `source ~/.secrets` | `source ~/.secrets  # Load your API keys here` | Keep pattern, add comment |

### Path Patterns (Personal Data)

| Pattern | Replacement | Scope |
|---------|-------------|-------|
| Personal project paths | Remove entire line/block | Settings permissions |
| Any path containing personal project names | Remove from permissions | Settings only |

---

## Pass 2: Validation Sweep

Run these regex patterns against the ENTIRE output directory. Must return **zero matches**.

### Must-Not-Contain Patterns

```regex
/(yourname|yoursurname|yourdomain\.com|youremployer)/i
```
Catches: name, surname, personal domain, employer name (case-insensitive)

```regex
/\/home\/[a-z][a-z0-9_-]+[^\/\$]/
```
Catches: hardcoded home paths that weren't replaced with $HOME

```regex
/(sk-ant-|op:\/\/Personal)/
```
Catches: API keys and personal 1Password vault references

```regex
/\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}\b/
```
Catches: email addresses — review each match (some may be legitimate examples like `user@example.com`)

### Allowlisted Exceptions

These patterns are expected in output and should not trigger violations:
- `your-email@example.com` — the replacement placeholder
- `$HOME` — the path placeholder
- `yourdomain.com` — the domain placeholder
- `your-name` / `your-github-username` — identity placeholders

---

## Block-Level Handling

Some content needs block-level replacement, not line-by-line pattern matching.

### CLAUDE.md: Extended Context Section

The entire "Extended Context (200K-1M tokens)" block including cloud credentials must be replaced with:

```markdown
### Extended Context (200K-1M tokens)
When tasks require >200K context, use direct API calls instead of the Task tool.

Replace the values below with your own cloud provider credentials:

- Access Key: `$YOUR_ACCESS_KEY_ENV_VAR`
- Secret Key: `$YOUR_SECRET_KEY_ENV_VAR`
- Region: `$YOUR_REGION_ENV_VAR`
- Model ID: `your-model-id`
```

### settings.json: Permissions Array

Replace the entire `permissions.allow` array with:

```json
"permissions": {
  "allow": [],
  "defaultMode": "bypassPermissions"
}
```

### settings.json: Hook Command Paths

Replace hardcoded paths in hook commands:
- `/home/youruser/.claude/hooks/` -> `$HOME/.claude/hooks/`

### inner-ally: Full Replacement

Replace entire SKILL.md and all references/ with template content. See `distribution-repo.md` for the skeleton structure.

---

## Adding New Patterns

When a new PII pattern is discovered during packaging:

1. Add it to the appropriate section in this file
2. Add the regex to the validation sweep
3. Re-run validation on the current output
4. Document why it was added (what leaked, where)
