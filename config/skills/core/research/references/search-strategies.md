---
description: Search query patterns and decomposition techniques for effective evidence gathering
audience: { human: 10, agent: 90 }
purpose: { process: 50, knowledge: 30, wisdom: 20 }
---

# Search Strategies

Effective research starts with effective searching. This reference covers how to decompose questions into search queries and execute them efficiently.

---

## Query Decomposition

### The 5-Angle Pattern

For any research question, generate queries from at least 5 independent angles:

| Angle | Purpose | Example (for "Should we use Redis or DragonflyDB?") |
|-------|---------|------------------------------------------------------|
| **What is it?** | Core concept understanding | "DragonflyDB architecture overview" |
| **How does it compare?** | Direct comparisons | "Redis vs DragonflyDB benchmark 2025" |
| **What are the problems?** | Failure modes, limitations | "DragonflyDB production issues limitations" |
| **Who's using it?** | Real-world experience | "DragonflyDB production deployment experience" |
| **What's changed recently?** | Current state | "DragonflyDB changelog 2025" |

### Perspective-Guided Queries

Generate queries from different stakeholder perspectives:

| Perspective | Query Pattern | Example |
|-------------|--------------|---------|
| **Advocate** | "[topic] benefits advantages" | "DragonflyDB advantages over Redis" |
| **Critic** | "[topic] problems drawbacks criticism" | "DragonflyDB drawbacks criticism" |
| **Operator** | "[topic] production operations monitoring" | "DragonflyDB production monitoring setup" |
| **Migrator** | "[topic] migration from [alternative]" | "migrate Redis to DragonflyDB guide" |
| **Newcomer** | "[topic] getting started tutorial" | "DragonflyDB vs Redis which to choose beginner" |

---

## Search Execution

### Parallel First, Sequential Follow-Up

**Phase 1 — Parallel breadth (single message, all at once):**
Launch 5-8 searches simultaneously covering different angles. Never search sequentially when queries are independent.

**Phase 2 — Sequential depth (based on results):**
Follow up on promising leads. Each follow-up is informed by what you found in Phase 1.

### Source Type Targeting

Different sources answer different questions:

| Question Type | Best Sources | Search Strategy |
|---------------|-------------|-----------------|
| "How does X work?" | Official docs, source code | Search official site, GitHub repo |
| "Is X better than Y?" | Benchmarks, comparisons | Search for independent benchmarks, add "vs" |
| "Has anyone used X?" | Blog posts, forums, case studies | Search for "production", "experience", "postmortem" |
| "What's new in X?" | Changelogs, release notes, tech news | Filter by date, search official blog |
| "What are X's problems?" | Issue trackers, forums, criticism | Search GitHub issues, add "problem", "issue", "limitation" |

### Search Refinement Techniques

**Narrowing:**
- Add year filter: "topic 2025"
- Add domain: "topic site:github.com"
- Add specifics: "topic production kubernetes"
- Exclude noise: "topic -tutorial -beginner"

**Broadening:**
- Use synonyms: "caching" → "in-memory store"
- Remove qualifiers: "Redis DragonflyDB benchmark" → "DragonflyDB performance"
- Try different source types: docs → blog posts → GitHub issues

**Validating:**
- Search for counter-evidence: "topic criticism", "topic problems"
- Search for corrections: "topic myth", "topic misconception"
- Search for updates: "topic update 2025", "topic deprecated"

---

## Subagent Deployment

For research requiring depth, spawn subagents with focused missions:

### When to Use Subagents

| Situation | Approach |
|-----------|----------|
| Simple lookup (1-2 searches) | Direct search, no subagent |
| Multi-angle research (5+ searches) | Parallel searches + 1-2 subagents for deep dives |
| Complex investigation (10+ searches) | Parallel searches + 3-5 subagents with distinct missions |

### Effective Subagent Prompts

**Good subagent mission** (focused, specific):
> "Search for production deployment experiences with DragonflyDB. Find 3-5 independent case studies or experience reports. For each, note: scale, use case, problems encountered, outcome. Return findings with source URLs."

**Bad subagent mission** (vague, open-ended):
> "Research DragonflyDB and tell me what you find."

### Subagent Patterns

| Pattern | Use When |
|---------|----------|
| **Deep-dive agent** | One topic needs multi-step investigation (read docs → check issues → follow links) |
| **Comparison agent** | Parallel comparison of two alternatives on the same criteria |
| **Verification agent** | Cross-check a specific claim against independent sources |
| **Counter-evidence agent** | Specifically search for evidence against a preliminary conclusion |

---

## Recognizing Search Saturation

Stop searching when:
- New searches return sources you've already seen
- You're finding the same 2-3 original sources cited everywhere
- The topic genuinely has limited coverage (document this as a finding)
- You have sufficient evidence to answer the question with appropriate confidence

Do NOT stop searching because:
- You found one good source (insufficient triangulation)
- The first result confirms your expectation (confirmation bias)
- You're running low on patience (not a valid research reason)

---

## Gap Documentation

When searches fail to find evidence, document the gap:

```
**Gap: [What you looked for]**
Searches attempted:
- "[query 1]" — 0 relevant results
- "[query 2]" — results about different topic
- "[query 3]" — only vendor marketing found

Assessment: No independent evidence found. This is either undocumented,
too new for coverage, or a gap in publicly available information.
```

A documented gap is a valid research finding. An undocumented gap is a hidden risk.

---

*The quality of your research is determined by the quality of your questions, not the quantity of your searches.*
