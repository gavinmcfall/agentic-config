# Universal Claude Rules

These rules apply to ALL repositories and conversations.

## Core Rules

1. **Ask, Don't Assume** — When requirements are ambiguous, ask clarifying questions rather than guessing.
2. **Admit Ignorance, Then Investigate** — If you don't know something, say so clearly—then go find out. Never fabricate answers.
3. **No Invented URLs or Values** — Never fabricate URLs, secrets, API keys, or configuration values. Ask if needed.
4. **Verify Versions and Digests** — Never assume image tags, versions, or SHA digests. Fetch current values from the source.
5. **Respect Existing Conventions** — Match the style, naming, and patterns already in the codebase.
6. **Complete Tasks Fully** — Don't stop mid-task or claim something is "too large." Continue until done or explicitly stopped.
7. **Never Leak Secrets** — Always use variables/substitution instead of hardcoded values. Check diffs before committing.
8. **Verify Before Committing** — Run tests/validation if available. Check git status and diff for leaked secrets.
9. **No Glob Scanning** — Never use the Glob tool for broad file scanning. Use targeted reads, Grep, or RepoQL instead.
10. **Fix the Code, Not the Tests** — NEVER modify tests to make them pass. Fix the implementation to satisfy the existing test expectations.
11. **Clean Up After Yourself** — When replacing or refactoring code, remove the old implementation entirely. No dead code, no commented-out blocks, no unused imports.
12. **Verify Before Declaring Done** — After making changes, confirm they actually work (run the build, run the tests, check the output). Never claim success without evidence.
13. **No Suppression Comments** — Never add `@ts-ignore`, `eslint-disable`, `noqa`, or equivalent. Fix the underlying issue instead.
14. **Stop Looping, Start Asking** — If you hit the same error 3 times, stop and ask for guidance instead of burning tokens on retry loops.
15. **Know the Time** - Check the current time using the time MCP server before starting any task or responding to a new message. Use NZ timezone (Pacific/Auckland) as the default.
16. **Commit Before Each Change** — Before starting a new feature or change, commit current staged/unstaged changes with semantic commit messages (feat:, fix:, chore:, refactor:, docs:, style:, test:). Keeps git history clean and makes work trackable across compactions.
17. **Maintain the Session Journal** — After completing significant work, update `.claude/session-journal.md` with current focus, changes made, decisions, and context that must survive compaction.
18. **Use CLOUDFLARE_API_TOKEN** — Always use `CLOUDFLARE_API_TOKEN` for Cloudflare/Wrangler operations. `CF_API_TOKEN` does NOT exist in this environment — never reference it, never check for it, never fall back to it. Before running ANY wrangler command, run `source ~/.secrets` to load `CLOUDFLARE_API_TOKEN` into the shell. This applies to all wrangler commands, API calls, and environment variable references.

## Session Journal

The file `.claude/session-journal.md` persists across compactions. Hooks handle timestamps and trimming automatically — your job is to keep the content sections useful.

### When to Update
- After completing a significant task (commit, deployment, investigation)
- After making a key decision worth remembering
- When you've accumulated context a fresh Claude would need

### What to Write

| Section | Content | Example |
|---------|---------|---------|
| **Current Focus** | What's actively being worked on | "Debugging wings-cert-sync SSH key format" |
| **Recent Changes** | Files changed, features added, bugs fixed | "- Fixed PEM reconstruction in wings-cert-sync CronJob" |
| **Key Decisions** | Choices made and why | "- Using 1Password CLI instead of ExternalSecrets for Wings certs (Pelican needs SSH format)" |
| **Important Context** | Anything a fresh Claude needs to continue | "- PR #42 is open, waiting on CI" |

### How to Update
- **Replace** section content — don't append endlessly
- Keep each section to **3-5 bullet points max**
- Remove stale items that are no longer relevant
- The journal is a snapshot of NOW, not a history log

## Subagent Model Selection

When spawning subagents or handling tasks requiring different context windows, choose the appropriate method:

### Standard Context (≤200K tokens)
Use the **Task tool** with the `model` parameter:
- `model: "haiku"` — Fast, cheap, good for simple queries
- `model: "sonnet"` — Balanced, default choice
- `model: "opus"` — Most capable, for complex analysis

**Example:**
```
Task tool with:
- subagent_type: "Explore"
- model: "haiku"
- prompt: "Find all authentication files"
```

### Extended Context (200K-1M tokens)
When tasks require **>200K context** (massive codebases, very long documents, extensive research), use **direct Bedrock API calls via Bash** instead of the Task tool.

**AWS Bedrock Credentials (Your_Provider):**
- Access Key: `$AWS_ACCESS_KEY_ID_YOUR_PROVIDER_BEDROCK`
- Secret Key: `$AWS_SECRET_ACCESS_KEY_YOUR_PROVIDER_BEDROCK`
- Region: `$AWS_REGION_YOUR_PROVIDER_BEDROCK` (us-west-2)
- Model ID: `global.anthropic.claude-opus-4-6-v1` (1M context)

**Template for Bedrock API calls:**
```bash
# 1. Create request JSON
cat > /tmp/bedrock-large-context-request.json << 'EOF'
{
  "anthropic_version": "bedrock-2023-05-31",
  "max_tokens": 4096,
  "messages": [
    {
      "role": "user",
      "content": "YOUR_PROMPT_HERE"
    }
  ]
}
EOF

# 2. Call Bedrock API
AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID_YOUR_PROVIDER_BEDROCK \
AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY_YOUR_PROVIDER_BEDROCK \
AWS_DEFAULT_REGION=us-west-2 \
aws bedrock-runtime invoke-model \
  --model-id global.anthropic.claude-opus-4-6-v1 \
  --region us-west-2 \
  --cli-binary-format raw-in-base64-out \
  --body file:///tmp/bedrock-large-context-request.json \
  /tmp/bedrock-large-context-response.json

# 3. Parse response
cat /tmp/bedrock-large-context-response.json | jq -r '.content[0].text'
```

**When to use extended context:**
- Analyzing entire large codebases (>50 files)
- Processing very long documents or logs
- Deep research requiring extensive context
- Tasks where losing context would require multiple back-and-forth iterations

**Cost consideration:** Extended context is significantly more expensive. Only use when the task genuinely requires >200K tokens.
