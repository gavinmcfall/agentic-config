---
description: Structured output formats for different types of research findings
audience: { human: 20, agent: 80 }
purpose: { knowledge: 50, process: 30, constraint: 20 }
---

# Output Formats

Research output should match the question asked. Not every investigation needs a full report.

---

## Quick Answer (Quick Mode)

For simple research questions that need evidence backing, not just an opinion.

```markdown
## [Question]

**Answer**: [Direct answer with confidence level]

**Evidence**:
- [Claim 1] [source-type: source]
- [Claim 2] [source-type: source]
- [Claim 3] [source-type: source]

**Gaps**: [What you didn't find or aren't sure about]
```

---

## Findings Report (Standard Mode)

For research that informs a decision or builds understanding.

```markdown
## Research: [Question]

### Summary
[2-3 sentence answer with confidence level and key caveats]

### Findings

#### [Sub-question 1]
[Evidence and analysis with inline citations]

#### [Sub-question 2]
[Evidence and analysis with inline citations]

#### [Sub-question 3]
[Evidence and analysis with inline citations]

### Synthesis
[Your analysis connecting the findings — labeled as synthesis]

### Gaps and Uncertainties
- [What you didn't find]
- [Where sources disagree]
- [What you're not confident about]

### Sources
| # | Source | Type | Credibility | Date |
|---|--------|------|-------------|------|
| 1 | [URL/reference] | [docs/web/paper/code] | [high/med/low] | [date] |
| 2 | ... | ... | ... | ... |
```

---

## Comparison Report (Standard/Deep Mode)

For "X vs Y" questions.

```markdown
## Comparison: [X] vs [Y]

### Summary
[Which is better for what, with confidence level]

### Evaluation Criteria
[What dimensions matter and why — derived from the user's context]

### Comparison

| Criterion | [X] | [Y] | Evidence |
|-----------|-----|-----|----------|
| [Criterion 1] | [Assessment] | [Assessment] | [Sources] |
| [Criterion 2] | [Assessment] | [Assessment] | [Sources] |

### Detailed Analysis

#### [Criterion 1]: [Title]
[Evidence for X] [citations]
[Evidence for Y] [citations]
[Synthesis: which is stronger and why]

#### [Criterion 2]: [Title]
...

### Recommendation
[For your context, X/Y because... — labeled as synthesis]

### Caveats
- [When this recommendation wouldn't hold]
- [What could change the picture]

### Sources
[Full source table]
```

---

## Deep Investigation Report (Deep Mode)

For important decisions with high reversibility cost.

```markdown
## Investigation: [Topic]

### Executive Summary
[3-5 sentences: what was investigated, key findings, recommendation, confidence]

### Background
[Why this investigation was needed — the context and stakes]

### Methodology
[What was searched, how many sources, what angles, what modes]

### Findings

#### Finding 1: [Title]
[Detailed evidence with inline citations, covering multiple sub-points]

#### Finding 2: [Title]
...

### Synthesis and Patterns
[Cross-cutting insights that emerge from the findings as a whole]

### Counterevidence and Risks
[Evidence that contradicts the main conclusions]
[Risks if the conclusions are wrong]

### Gaps
[What wasn't found, what couldn't be verified, what needs more investigation]

### Recommendations
[Specific, actionable next steps — labeled by confidence level]

### Sources
[Full source table with credibility scores]

### Appendix: Search Log
[What was searched and what was found — for reproducibility]
```

---

## Choosing the Right Format

| Question Type | Format | Example |
|--------------|--------|---------|
| "What is the current state of X?" | Quick answer or Findings | "What's the latest on Bun compatibility?" |
| "Should we use X or Y?" | Comparison | "Redis vs DragonflyDB for our use case" |
| "Is X the right approach?" | Findings | "Is event sourcing appropriate for this service?" |
| "Help me understand X deeply" | Deep investigation | "How does Cloudflare Workers KV consistency work?" |
| "What are the risks of X?" | Findings (with emphasis on counterevidence) | "What are the risks of migrating to Workers?" |

---

## Output Quality Checklist

Before delivering any research output:

- [ ] Every factual claim has an inline citation
- [ ] Sources are listed with credibility assessment
- [ ] Gaps and uncertainties are explicit
- [ ] Synthesis is labeled as synthesis (not presented as sourced fact)
- [ ] The confidence level is stated
- [ ] The reader can trace any claim back to a specific source

---

*The format serves the reader. Choose the lightest format that answers the question completely.*
