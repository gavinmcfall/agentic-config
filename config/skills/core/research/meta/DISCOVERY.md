# Discovery Notes: research

## Source Material
- Stanford STORM methodology — perspective-guided question decomposition for multi-source research
- 199-biotechnologies/claude-deep-research-skill — 8-phase deep research pipeline with parallel retrieval
- Context-driven testing school (evidence-first thinking adapted to research)
- Academic research methodology — triangulation, source evaluation, evidence hierarchies

## Key Insights
1. **Evidence hierarchy is the foundation.** Without tiered evidence classification, agents present inference as fact. The 4-tier system (primary → secondary → synthesis → inference) forces honest labeling.
2. **Triangulation ≠ repetition.** Three blogs citing the same Stack Overflow answer is one source, not three. Independent confirmation through different evidence paths is the standard.
3. **Inline citations prevent drift.** Citing at the end of a section lets unsourced claims hide in the middle. Same-sentence citation is a hard constraint.
4. **Parallel search, sequential follow-up.** Launch 5-8 independent searches simultaneously, then follow up on promising leads. This is the biggest speed multiplier.
5. **Perspective-guided decomposition prevents tunnel vision.** Generating queries from advocate, critic, operator, architect, and newcomer perspectives ensures balanced coverage.
6. **Documented gaps are findings.** "I found no evidence for X" is valuable. Silence on gaps is deception.

## Zone Assessment
- Knowledge (10): Research methodology is well-understood — Claude knows how to search and cite
- Process (30): The 7-phase pipeline has genuine ordering requirements and quality gates
- Constraint (25): Hard rules about citation, fabrication, and transparency carry the most weight
- Wisdom (35): The core value is changing how the agent thinks about evidence and uncertainty

## Design Decisions
- Adapted from 199-biotechnologies' 8-phase pipeline but reduced to 7 phases (merged REFINE into CRITIQUE)
- Removed Python scripts, HTML/PDF generation, and source_evaluator.py — kept methodology pure
- Three research modes (Quick/Standard/Deep) scale the process to the stakes
- Stanford STORM's perspective-guided decomposition integrated into Phase 2 and the search strategies reference
- Source credibility scoring uses a 100-point scale across 5 dimensions (Authority, Currency, Independence, Methodology, Corroboration)
- Output formats are separate templates, not embedded in the main skill — keeps SKILL.md focused on process and thinking
- Search strategies reference covers query decomposition, subagent patterns, and saturation recognition
- Anti-patterns table is the most actionable part — agents can pattern-match against their own behavior
