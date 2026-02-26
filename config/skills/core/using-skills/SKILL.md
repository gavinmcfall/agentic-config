---
name: using-skills
description: Check and invoke available skills before starting work. Invoke at the start of any task to ensure relevant skills are loaded.
---

# Using Skills

Before starting any task, check your available skills. Skills encode proven practices—ignoring them means reinventing wheels or missing important patterns.

## Process

1. **List available skills** — Check what's available in your current context
2. **Match to task** — Which skills might apply, even partially?
3. **Invoke relevant skills** — Load them before starting work
4. **Apply their guidance** — Follow the patterns they establish

## When in Doubt, Invoke

If there's even a small chance a skill applies, invoke it. The cost of loading an irrelevant skill is low. The cost of missing relevant guidance is high.

Skills compose. One skill may tell you to invoke another.

## Available Skills Quick Reference

| Skill | Use When |
|-------|----------|
| `writing-documents` | Writing any documentation, READMEs, designs, plans |
| `code-review` | Reviewing code with fresh eyes, generating multi-AI review prompts |
| `review-responder` | Processing and responding to code review feedback |
| `research` | Gathering evidence for decisions, investigation tasks |
| `mermaid-diagrams` | Creating diagrams in markdown documents |
| `skill-builder` | Creating or improving Claude Code skills |

## Skill Composition Patterns

```
task → using-skills → identify relevant skills → invoke them → work

writing task → writing-documents → [document type guidance]
code review → disconnected-code-review → writing-documents (for findings)
review feedback → review-responder → apply/skip each item
new skill → skill-builder → writing-documents (skills are agent docs)
```

---

*Check skills first. Missing relevant guidance costs more than loading unused skills.*
