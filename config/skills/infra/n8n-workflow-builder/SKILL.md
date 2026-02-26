---
name: n8n-workflow-builder
description: Build automation workflows with n8n for game dev tasks. Use when automating repetitive processes, setting up notifications, scheduling backups, or connecting services. Reduces manual overhead that ADHD brains find hardest to maintain.
zones: { knowledge: 50, process: 30, constraint: 15, wisdom: 5 }
---

# n8n-workflow-builder

If you have to remember to do it regularly, automate it. You won't remember.

---

## n8n on This Cluster

n8n is deployed on the k8s cluster via home-ops GitOps. To find the current deployment:

```bash
kubectl get helmrelease -A | grep n8n
kubectl get httproute -A | grep n8n
```

n8n provides a visual workflow editor accessible through a web browser. Workflows connect nodes (triggers, actions, transformations) to automate tasks.

---

## When to Automate

### The 5-Minute Rule

**Automate if**: you do it more than once a week AND it takes more than 5 minutes AND the automation takes less than 1 hour to build.

**Don't automate if**: you do it once a month, or the automation is more complex than the task, or it's creative work that changes each time.

### Solo Dev Automations Worth Building

| Category | Workflow | Trigger | Complexity |
|----------|----------|---------|------------|
| **Backups** | Backup game project to MinIO/S3 | Schedule (daily) | Simple |
| **Notifications** | Alert on failed GitHub Actions | Webhook | Simple |
| **Community** | Post devlog to Discord | Manual trigger | Simple |
| **Monitoring** | Alert on low disk space | Schedule (hourly) | Medium |
| **Assets** | Resize screenshots for Steam capsule | File watcher | Medium |
| **Steam** | Track wishlist count weekly | Schedule (weekly) | Medium |
| **Build** | Trigger export on commit to main | Webhook from GitHub | Complex |

Start with Simple. Move to Medium when Simple is working. Complex workflows need more n8n experience.

---

## Workflow Building Process

### 1. Define the Trigger

Every workflow starts with: what event causes this to run?

| Trigger Type | Use When | n8n Node |
|-------------|----------|----------|
| Schedule | Time-based (daily backup, weekly report) | Schedule Trigger |
| Webhook | External event (GitHub push, form submit) | Webhook |
| Manual | User-initiated (run when I click) | Manual Trigger |
| File change | New or modified file | varies by storage |

### 2. Define the Actions

What happens when the trigger fires? Keep the chain short.

**Good**: Trigger → Action → Notification (3 nodes)
**Risky**: Trigger → Transform → Filter → Action → Transform → Action → Notification (7 nodes)

Each additional node is a potential failure point. Solo devs don't have time to debug complex workflow failures.

### 3. Handle Errors

Every workflow should have an error path. At minimum:

- **Error trigger**: n8n can catch workflow failures
- **Notification**: Send yourself a message when something breaks
- **Retry logic**: For transient failures (network timeouts), add a retry

### 4. Test Before Deploying

- Use n8n's "Execute Workflow" button to test manually
- Check output at each node
- Verify error paths by intentionally causing failures
- Only enable the trigger after testing passes

---

## Credential Management

### Hard Rules

- **Never** hardcode API keys or passwords in workflow nodes
- **Always** use n8n's built-in credential system
- Credentials are encrypted at rest by n8n
- If a credential is for a service on the k8s cluster, use the internal service URL

### Setting Up Credentials

1. Go to n8n Settings → Credentials
2. Add new credential for the service
3. Test the connection
4. Reference the credential in workflow nodes

---

## Common Patterns

### Backup to MinIO

```
Schedule Trigger (daily, 2am)
  → Execute Command: tar project directory
  → S3: Upload to MinIO bucket
  → Discord: Post "Backup complete" (optional)
```

MinIO is already on the cluster. Use the internal service URL.

**Exclude build artifacts**: For Godot projects, exclude `.godot/` (cached/generated files) from the tar. For other engines, check their equivalent of `.gitignore` — only back up source files, not generated output.

### GitHub to Discord

```
Webhook: Receive GitHub push event
  → Filter: Only main branch
  → Discord: Post commit message to #devlog channel
```

Requires: GitHub webhook configured, Discord webhook URL in credentials.

### Weekly Progress Summary

```
Schedule Trigger (Friday 5pm)
  → HTTP Request: Get Plane tickets completed this week (API)
  → Transform: Format as summary
  → Discord: Post to #progress channel
```

This pairs with sprint-manager's end-of-week review.

---

## Workflow Maintenance

### Export and Version Control

n8n workflows can be exported as JSON. Do this:

1. Export workflow from n8n UI (Settings → Export)
2. Save to a `workflows/` directory in your project repo
3. Commit with the workflow's purpose in the message

This provides backup and version history. If n8n is redeployed, import the JSON.

### Monitoring

Check workflow health periodically:
- n8n dashboard shows execution history
- Failed executions are highlighted
- Set up an error-notification workflow that alerts you on any failure

---

## Constraints

- Workflows should be simple: under 7 nodes unless there's a strong reason
- Never store credentials in workflow JSON — use n8n's credential system
- Test manually before enabling triggers
- Export workflows to git for backup
- Don't automate creative work or decisions — only repetitive tasks

---

## For AI Assistants

When the user wants to automate something:

1. **Apply the 5-minute rule**: Is this worth automating?
2. **Identify the trigger**: What event starts this?
3. **Keep it simple**: Can you do it in 3-5 nodes?
4. **Suggest credentials setup**: What services need authentication?
5. **Remind about testing**: "Test this manually before enabling the trigger"

When suggesting automation proactively:
- If the user does something manually that they'll need to repeat: "This could be an n8n workflow. Want me to help set it up?"
- If a sprint-manager ticket involves repetitive work: "Could this be automated instead of done manually each time?"

---

## Deeper

- The `k8s-operator` skill — Finding n8n and other services on the cluster
- The `home-ops-deployer` skill — n8n deployment configuration
- n8n documentation: https://docs.n8n.io/

---

*If you have to remember to do it, automate it. You won't remember.*
