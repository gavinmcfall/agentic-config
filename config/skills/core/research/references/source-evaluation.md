---
description: How to evaluate source credibility and assign evidence tiers
audience: { human: 20, agent: 80 }
purpose: { knowledge: 40, constraint: 35, wisdom: 25 }
---

# Source Evaluation

Not all sources are equal. This reference provides a framework for assessing credibility and assigning evidence tiers.

---

## Evidence Tiers

Every piece of evidence in your research should be tagged with its tier.

### Tier 1: Primary Sources
Direct, authoritative evidence from the source of truth.

| Example | Why Primary |
|---------|-------------|
| Official API documentation | Written by the maintainers |
| Source code | The actual implementation |
| API response you received | Direct observation |
| Peer-reviewed paper (methods/results) | Original research |
| Official changelog / release notes | From the project itself |
| Benchmark you ran yourself | Direct measurement |

**Citation format**: `[docs: source]`, `[code: file:line]`, `[paper: author (year)]`

### Tier 2: Secondary Sources
Reliable reporting or analysis of primary sources.

| Example | Why Secondary |
|---------|---------------|
| Technical blog post citing docs | Interpreting primary source |
| Conference talk by practitioners | Sharing experience, not primary research |
| Book chapter on the topic | Curated and edited, but not original |
| Reputable news reporting on research | Summarizing primary sources |

**Citation format**: `[web: source, date]`, `[book: author (year)]`

### Tier 3: Synthesis
Your own analysis combining multiple sources.

| Example | Why Synthesis |
|---------|---------------|
| "Based on [1] and [2], the pattern suggests..." | Connecting evidence |
| Comparison table you built from multiple sources | Your organization of facts |
| "The consensus across 5 sources is..." | Aggregation with attribution |

**Citation format**: `[synth: based on sources N, M]`

### Tier 4: Inference
Reasoning without direct evidence.

| Example | Why Inference |
|---------|---------------|
| "Given that X is true, Y likely follows" | Logical deduction |
| "Similar systems typically..." | Analogical reasoning |
| "In the absence of documentation, the behavior suggests..." | Educated guess |

**Citation format**: `[infer: reasoning basis]`

---

## Credibility Scoring

When evaluating a source, consider these factors:

### Authority (0-30 points)
- **30**: Official docs, maintainer, recognized domain expert
- **20**: Experienced practitioner with track record
- **10**: General tech writer, community contributor
- **0**: Anonymous, unknown, or AI-generated without verification

### Currency (0-20 points)
- **20**: Published within last 6 months, or topic is stable
- **15**: Published within last 1-2 years
- **10**: Published 2-5 years ago
- **0**: Published 5+ years ago on a fast-moving topic

### Independence (0-20 points)
- **20**: No commercial interest, no relationship to subject
- **10**: Some commercial interest but transparent
- **0**: Marketing material, vendor comparison by the vendor

### Methodology (0-15 points)
- **15**: Shows work, reproducible, cites sources
- **10**: Some evidence but not fully documented
- **0**: Claims without evidence, "trust me"

### Corroboration (0-15 points)
- **15**: Multiple independent sources confirm
- **10**: One other source confirms
- **0**: Single source, no confirmation found

**Score interpretation:**
- 80-100: High confidence — use for core claims
- 60-79: Moderate confidence — use with attribution
- 40-59: Low confidence — use only if no better source; flag uncertainty
- 0-39: Unreliable — do not use for factual claims; note as "claimed by [source] but unverified"

---

## Common Traps

### The Echo Chamber
Ten articles all saying the same thing — but they all cite the same original source. This is one source, not ten.

**Counter**: Trace claims back to their origin. How many truly independent origins exist?

### The Outdated Authority
A highly authoritative source from 3 years ago that's been superseded by new developments.

**Counter**: Check when the source was published AND when the topic last changed significantly.

### The Plausible Fabrication
AI-generated content that reads convincingly but contains invented facts, fake citations, or subtly wrong technical details.

**Counter**: Verify specific claims against primary sources. If a citation doesn't resolve to a real document, discard it.

### The Vendor Benchmark
Performance comparisons published by the vendor of one of the compared products.

**Counter**: Look for independent benchmarks. If only vendor benchmarks exist, note the bias explicitly.

### The Anecdotal Generalization
"We use X and it works great for us" presented as "X is the best choice."

**Counter**: One team's success is not universal evidence. Look for multiple independent experience reports.

---

## When You Can't Evaluate

Sometimes you can't determine credibility:
- Source is behind a paywall you can't access
- The topic is too novel for multiple sources to exist
- You lack domain expertise to judge methodology

In these cases: **say so.** "I found one source for this claim but cannot independently verify it" is a valid research finding.

---

*The strength of your research is determined by your weakest unchallenged source.*
