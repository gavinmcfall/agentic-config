---
name: config-packager
description: Audit, sanitize, and package ~/.claude/ configuration into a distributable repository with versioned releases. Use when updating the public agentic-config repo, syncing local changes, creating releases, or auditing for PII. Handles cross-platform install scripts and semantic versioning.
zones: { knowledge: 25, process: 40, constraint: 30, wisdom: 5 }
---

# config-packager

A config is only useful if someone else can adopt it. This skill makes yours shareable.

---

## Capsule: DistributableConfig

**Invariant**
A distributable config must work on a fresh machine with zero knowledge of the original author's environment.

**Example**
A settings.json with `/home/username/.claude/hooks/git-safety.sh` hardcoded fails on every other machine. The distributable version uses `$HOME/.claude/hooks/git-safety.sh`.
//BOUNDARY: Stripping personal details does not mean stripping opinion. An opinionated config is the entire point. Personal details are not.

**Depth**
- Distinction: "generic" means platform-agnostic and identity-free, not bland
- NotThis: replacing all specific tool recommendations with "choose your own" — that removes the value
- Trade-off: over-sanitization defeats the purpose; under-sanitization leaks PII
- SeeAlso: `references/sanitization-rules.md`

---

## Capsule: SanitizationIsNotOptional

**Invariant**
Every file passing through the packager is sanitized. No exceptions. A missed API key in a published config is a security incident.

**Example**
The two-pass approach: first, pattern-based replacement on each file. Second, regex validation sweep across the entire output. Both must pass before commit.
//BOUNDARY: Sanitization is about secrets and identity. It is not about removing tool-specific or domain-specific content that makes the config useful.

**Depth**
- The validation pass catches what the replacement pass misses
- New PII patterns discovered during packaging must be added to `references/sanitization-rules.md` immediately
- SeeAlso: `references/sanitization-rules.md`

---

## Hard Constraints

1. **Never package**: `.credentials.json`, `history.jsonl`, `stats-cache.json`, `mcp-needs-auth-cache.json`, `session-journal.md`, `projects/`, `settings.local.json`, `plugins/`, `file-history/`, `telemetry/`, `statsig/`, `cache/`, `debug/`, `image-cache/`, `paste-cache/`, `session-env/`, `shell-snapshots/`, `ide/`, `plans/`, `tasks/`, `teams/`, `backups/`, `.claude.zip`
2. **Never ship** actual API keys, secrets, or credential values
3. **Never ship** personal paths — replace `/home/<username>` with `$HOME`
4. **Never ship** accumulated permission allowlists (machine-specific artifacts)
5. **Never ship** `inner-ally` with real content — template skeleton only
6. **Never ship** `meta/` directories from any skill (authoring artifacts, not consumer content)
7. **Always validate** output against sanitization regex set before committing
8. **Always generate** a diff report showing what changed since last packaging run
9. **Always run** interactive mode by default — never auto-commit without review

---

## Packaging Process

> Steps must execute in this order. Skipping or reordering causes data leaks or broken output.

### 1. Audit

Run `scripts/package.sh --audit` to inventory `~/.claude/`.

-> Verify: Output lists every file with classification (include / sanitize-then-include / exclude)
-> If failed: Check file permissions, ensure `~/.claude/` is readable

### 2. Diff

Compare current state against last packaged version.

-> Verify: Output shows new, changed, and deleted files since last run
-> If failed: If no previous run exists, treat everything as "new"

### 3. Review

Present the diff to the user. Pause for confirmation before proceeding.

-> Verify: User explicitly approves the file list
-> If failed: Adjust inclusion/exclusion list per user feedback, re-audit

### 4. Sanitize and Copy

Run `scripts/package.sh --package` to process each file through the sanitization pipeline and copy to the distribution repo.

-> Verify: All files copied, sanitization patterns applied
-> If failed: Check sanitization rules for regex errors

### 5. Validate

Run `scripts/validate.sh` on the output directory.

-> Verify: Zero PII violations detected
-> If failed: Fix the source sanitization rules, re-run steps 4-5

### 6. Generate Artifacts

Run `scripts/generate-readme.sh` to update README, verify install scripts are current.

-> Verify: README reflects current skill inventory and tier structure
-> If failed: Check skill frontmatter parsing

### 7. Commit

Stage changes, review diff, commit with descriptive message.

-> Verify: `git diff --staged` shows only sanitized content
-> If failed: Do NOT commit. Return to step 4.

---

## Skill Tiers

| Tier | Category | Install Default |
|------|----------|----------------|
| Core | Generic skills useful for everyone | Always installed |
| Game Dev | Solo game dev + ADHD workflow skills | Optional |
| Infra | Kubernetes homelab skills | Optional |
| Templates | Skeleton skills for personal customization | Optional |

Full tier assignments: `references/file-inventory.md`

---

## Cross-Platform

The distribution repo must work on Linux, macOS, and Windows. See `references/cross-platform.md` for platform-specific handling of paths, permissions, line endings, and hook scripts.

---

## Distribution Repo

Target: `your-github-username/agentic-config` (public GitHub repo)
Local path: `$HOME/repos/agentic-config/`
Structure: `references/distribution-repo.md`

---

## Sync & Release

> Extends the packaging process with versioned GitHub releases. One command: detect changes, package, validate, commit, tag, push, release.

### Quick Use

```bash
# Interactive (recommended)
scripts/sync-release.sh

# Force a specific version bump
scripts/sync-release.sh --minor

# Preview without executing
scripts/sync-release.sh --dry-run

# Fully automated
scripts/sync-release.sh --auto
```

### Process

> Steps must execute in this order. The script enforces this automatically.

1. **Pre-flight** — Verify gh CLI, git repo, main branch, sibling scripts
2. **Package** — Run `package.sh --package --auto` to sanitize and copy
3. **Detect** — Use `git diff` on the repo to find what actually changed
4. **Validate** — Run `validate.sh` — zero PII violations required. Release blocked if this fails.
5. **Regenerate README** — Run `generate-readme.sh`
6. **Classify** — Categorize changes for semver bump
7. **Determine version** — Apply heuristics or user override
8. **Generate release notes** — Auto-generate from change types
9. **Preview** — Show summary, pause for confirmation
10. **Commit, tag, push** — Create release commit and version tag
11. **GitHub release** — Create release via `gh release create`

### Version Rules

Changes are classified for semantic versioning:
- **Major**: Skills removed, structure changed, breaking install changes
- **Minor**: New skills, new config types, new references, new hooks
- **Patch**: Content updates, typo fixes, improved wording

Full rules: `references/semver-rules.md`
