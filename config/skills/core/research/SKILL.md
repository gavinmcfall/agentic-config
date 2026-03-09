---
name: research
description: Evidence-first research with mandatory citations and source evaluation. Use when gathering information for decisions, comparing approaches, investigating unknowns, or any task requiring verified evidence from multiple sources. Invoke at the START of research, not when writing up results.
zones: { knowledge: 10, process: 30, constraint: 25, wisdom: 35 }
---

# research

Evidence first. Citations always. Uncertainty admitted.

---

## Capsule: EvidenceHierarchy

**Invariant**
Not all evidence is equal. A claim backed by three independent primary sources is stronger than a claim repeated by thirty blogs citing the same original. Know what tier your evidence is and label it.

**Example**
Tier 1 (primary): API documentation says max payload is 6MB. Tier 2 (secondary): Blog post says "the limit is about 6MB." Tier 3 (synthesis): "Based on the docs and observed behavior, 6MB is the hard limit." Tier 4 (inference): "Given similar services cap at 5-10MB, likely around 6MB."
//BOUNDARY: Tier 4 is not worthless — it's honest. Presenting Tier 4 as Tier 1 is the problem.

**Depth**
- Primary sources: official docs, source code, API responses, academic papers, direct measurements
- Secondary sources: blog posts, articles, forum answers that reference primary sources
- Synthesis: your own analysis combining multiple sources
- Inference: reasoning from analogies or patterns when direct evidence is unavailable
- Always label which tier. Never present inference as established fact.
- SeeAlso: `references/source-evaluation.md`

---

## Capsule: TriangulationNotRepetition

**Invariant**
Three sources saying the same thing is not triangulation if they all cite the same original. Triangulation requires independent sources that confirm through different evidence paths.

**Example**
Bad: Three blog posts all quoting the same Stack Overflow answer. Good: The official docs, a benchmark you ran, and an independent blog post all arrive at the same conclusion through different means.
//BOUNDARY: When triangulation is impossible (novel topic, single authoritative source), say so. "Single source: official documentation" is valid.

---

## Capsule: CitationsInline

**Invariant**
Every factual claim must have its source cited in the same sentence. "Research shows X" without attribution is not research — it's assertion.

**Example**
Bad: "Redis is faster than PostgreSQL for caching." Good: "Redis outperforms PostgreSQL for cache workloads by 10-100x for simple key-value reads [1]."
//BOUNDARY: Your own synthesis doesn't need a citation — but it must be labeled as synthesis, not presented as established fact.

**Depth**
- Citation format: `[source-type: location]` — e.g., `[docs: Redis benchmarks]`, `[web: InfoQ article, 2025]`, `[code: src/cache.ts:42]`
- Source types: `code`, `docs`, `web`, `paper`, `synth` (your analysis), `infer` (your reasoning)
- Inline citation goes in the same sentence as the claim, not at the end of the paragraph
- Never use "Research suggests..." or "Studies show..." without naming the specific source

---

## Hard Constraints

1. **Never fabricate citations.** If you can't find a source, say "no source found" — never invent one.
2. **Never present inference as fact.** Label your tiers. Synthesis and inference are valuable — when labeled.
3. **Always cite inline.** The source goes in the same sentence as the claim. Not at the end. Not in a footnote.
4. **Admit what you don't know.** "I found no evidence for X" is a finding. Silence on gaps is deception.
5. **Distinguish fact from synthesis.** FACT: sourced and cited. SYNTHESIS: your analysis combining sources. INFERENCE: your reasoning without direct evidence.
6. **Never stop searching because you have an answer.** Search until you have evidence — or until you've exhausted available sources and can document the gap.

---

## The Research Process

> The phases are ordered. Understanding what you're looking for before searching prevents both scope creep and tunnel vision.

### Phase 1: Frame the Question
What are you actually trying to find out? Decompose the question into components. Define what's in scope and out.

-> Verify: Can you state the research question in one sentence?
-> Verify: Have you identified 3-5 sub-questions that cover the topic?
-> If failed: The question is too vague. Narrow it or ask for clarification.

### Phase 2: Plan the Search
What sources exist? What search angles will you pursue? Plan before executing.

Activities:
- Identify 5-8 independent search angles (different perspectives on the same question)
- Determine source types needed (docs, code, papers, industry, community)
- Identify what "good enough" looks like (how many sources, what confidence level)
- Map knowledge dependencies (what must you understand first?)

-> Verify: Your search plan covers multiple perspectives, not just the obvious angle.

### Phase 3: Retrieve (Parallel)
Execute searches. Use parallel execution — launch multiple searches in a single message, not sequentially.

**Search decomposition pattern:**
1. Core concept (semantic) — what is this thing?
2. Technical specifics (keyword) — exact terms, APIs, implementations
3. Recent developments (time-filtered) — what's changed in the last 1-2 years?
4. Alternative perspectives (comparison) — competing approaches, criticisms
5. Practical evidence (implementations) — who's actually using this and how?

**Execution:**
- Launch all independent searches simultaneously (parallel tool calls)
- Spawn subagents for deep-dive investigations that need multi-step retrieval
- Track source metadata as you go: URL, date, author/org, credibility assessment
- Follow promising leads with targeted follow-up searches

**Quality gate — move to Phase 4 when:**
- 10+ sources gathered with reasonable diversity
- Multiple source types represented (not all from the same kind of source)
- Core sub-questions have at least some coverage

### Phase 4: Evaluate and Triangulate
Not all sources are equal. Evaluate what you've found.

For each major claim:
- How many independent sources confirm it?
- What tier is the evidence? (primary, secondary, synthesis, inference)
- Are there contradictions? What do the contradictions tell you?
- Is the source current? Has the landscape changed since publication?
- What biases might the source have?

-> Verify: Core claims have 3+ independent sources OR you've documented why fewer exist.
-> Verify: You've identified and documented contradictions, not just confirming evidence.

### Phase 5: Synthesize
Connect the dots. What patterns emerge across sources? What insights go beyond what any single source says?

- Identify patterns across sources
- Note where consensus exists and where debate exists
- Generate insights that combine evidence from multiple sources
- Flag areas where evidence is thin or contradictory
- Distinguish clearly between what the sources say (FACT) and what you conclude (SYNTHESIS)

### Phase 6: Critique (for important research)
Red-team your own findings before presenting them.

- What's missing from this picture?
- What alternative explanations exist?
- What biases might be present in your sources — or in your synthesis?
- What would someone who disagrees with your conclusion point to?
- What confidence level should the reader have?

### Phase 7: Report
Present findings with full transparency about evidence quality.

Structure:
1. **Summary** — The answer, in brief, with confidence level
2. **Findings** — Evidence organized by sub-question, with inline citations
3. **Synthesis** — Your analysis connecting the findings (labeled as synthesis)
4. **Gaps and uncertainties** — What you didn't find, what you're not sure about
5. **Sources** — Full list with credibility notes

-> Verify: A reader can trace every factual claim back to a specific source.
-> Verify: Gaps and uncertainties are explicit, not hidden.

---

## Research Modes

Scale the process to the stakes.

| Mode | When | Phases | Sources | Time |
|------|------|--------|---------|------|
| **Quick** | Exploration, low stakes | 1, 3, 7 | 5-10 | 2-5 min |
| **Standard** | Most research tasks | 1-5, 7 | 10-20 | 5-15 min |
| **Deep** | Important decisions | 1-7 | 20-30 | 15-30 min |

Default to **standard**. Escalate to deep when the decision is expensive to reverse.

---

## When to Invoke This Skill

| Situation | What Research Does |
|-----------|-------------------|
| Technical decision (X vs Y) | Gather evidence from multiple angles before recommending |
| Investigating an unknown | Systematic search with documented findings |
| Validating an assumption | Find evidence for AND against |
| Understanding a new domain | Multi-perspective exploration with source mapping |
| Debugging a complex issue | Evidence-first investigation, not guess-and-check |
| Preparing a recommendation | Build the evidence base before writing the recommendation |

---

## Anti-Patterns to Actively Call Out

| Pattern | What to Say |
|---------|-------------|
| Searching for confirmation | "I'm only finding evidence that supports X. Let me search for counterarguments." |
| Single-source dependency | "This claim relies on one source. Let me look for independent confirmation." |
| Presenting inference as fact | "I believe X based on [reasoning], but I haven't found direct evidence." |
| Vague attribution | Never say "research shows" or "experts believe" — name the source. |
| Stopping early | "I have a plausible answer but haven't verified it. Let me check." |
| Ignoring contradictions | "Sources disagree on X. [Source A] says Y, [Source B] says Z." |

---

## Perspective-Guided Decomposition

Before searching, identify the different perspectives that would illuminate the topic. This prevents tunnel vision and ensures balanced coverage.

For a technical decision:
- The **advocate** — why would someone choose this?
- The **critic** — why would someone avoid this?
- The **operator** — what's the day-to-day reality?
- The **architect** — how does this fit the bigger picture?
- The **newcomer** — what's the learning curve?

For each perspective, generate 2-3 questions that perspective would ask. These become your search queries.

*Inspired by Stanford STORM's perspective-guided research methodology.*

---

## Source Credibility Quick Guide

| Source Type | Default Credibility | Watch For |
|-------------|-------------------|-----------|
| Official documentation | High | May be outdated or incomplete |
| Source code / API responses | Very high | Is this the version you're using? |
| Academic papers (peer-reviewed) | High | May not apply to your context |
| Reputable tech blogs (individual) | Medium | Author expertise varies |
| Stack Overflow answers | Medium | Upvotes ≠ correctness; check the date |
| AI-generated content | Low | May be plausible but wrong |
| Marketing materials | Low | Biased by design |
| Forums / social media | Low | Signal-to-noise ratio poor |

When credibility is uncertain, triangulate. When triangulation is impossible, label the uncertainty.

---

## Deeper

- `references/source-evaluation.md` — Detailed source credibility scoring
- `references/search-strategies.md` — Search query patterns and decomposition techniques
- `references/output-formats.md` — Structured formats for different research outputs

---

*Research is not finding what you expect. It is discovering what is actually true — and being honest about what you still don't know.*
