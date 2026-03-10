# Creation Notes: Human Profile Builder

## Source Material
Built from 10 real personality assessments covering MBTI (16Personalities), Big Five (Truity), DISC, Enneagram (Truity), Schwartz Values (Gyfted + idrlabs), VARK Learning Styles, EQ (Truity), and Strengths (Personality Quizzes).

The key insight from source analysis: individual assessments are useful but their real power is in **cross-framework synthesis** — finding convergence, paradox, gaps, and amplification patterns across frameworks.

## What Worked
- Processing real assessment data first (DISCOVERY.md) before writing the skill gave concrete understanding of what each framework actually reveals vs what it claims
- Writing a real profile as the exemplar made the synthesis process tangible — abstract framework knowledge became concrete when applied to real data
- The AI Working Context section emerged as the most practically valuable part — it transforms academic personality insights into actionable AI behavior
- Parallel research agents for all 16 types produced rich diagnostic material — the agents found nuances (like the 80% INFJ mistyping rate, gender bias effects on T/F, and dom-tert loop confusion) that significantly improved the type-differentiation guide
- QA testing via subagent identified concrete gaps (session management, executive function, attachment, instinctual variants) that the authoring process missed

## What Was Hard
- PDF extraction: Multiple formats, encrypted PDFs, image-based PDFs — required pymupdf rendering to images. Document ingestion guide now includes format handling notes.
- Making questions diagnostic vs confirmatory: The initial question set was designed by looking at one person's results, which naturally biases toward confirming those patterns. Had to consciously redesign for differentiation. QA testing caught several Phase 1-3 questions that were still "surface level" despite the differentiation guide warning against this.
- Cross-framework paradoxes are under-documented — most resources treat each framework in isolation. Rare combinations have limited reference material.
- Balancing precision claims: The original framing ("replaces $200-500 in tests") was oversold. Had to reframe honestly — the skill produces deep qualitative synthesis that no single instrument provides, but it cannot replicate the statistical precision of validated forced-choice instruments.

## Improvements Made (QA Round)
- Added session management guidance (opening script, session splitting, between-session continuity, early stops)
- Upgraded four surface-level interview questions (Q7, Q10, Q14, Q35) to scenario-based diagnostic format
- Added executive function probes (Phase 3) — distinguishing disorganization as preference vs capacity constraint
- Added attachment style probes (Phase 4) — fundamental relationship pattern missing from original
- Added Enneagram instinctual variant probes (Phase 7) — sp/so/sx stacking
- Created worked example (fictional "Sam Chen" — INFJ 9w2 sp) showing full pipeline
- Added rapid differentiator matrices for NT/NF/SP/SJ groups
- Added mistyping patterns, gender bias, and loop/grip confusion sections
- Toned down precision claims to honest framing
- Added OCR/image-PDF handling notes to document ingestion

## What Would Still Improve the Skill
- Real testing with people who are NOT INFJs — the question set needs validation across multiple types
- More worked examples for different configurations (an ESTP, an ISTJ, an ENFP) to show how synthesis varies
- A confidence calibration system for interview-derived typing — when to say "high confidence INFJ" vs "likely INFJ or INFP"
- Structured guidance for handling cultural context — an immigrant, a veteran, and a stay-at-home parent may answer conflict questions differently for contextual rather than personality reasons

## Authoring Experience
The skill-builder process (discovery → zone assessment → writing → QA testing) worked well. The zone assessment (K25/P40/C10/W25) correctly identified this as primarily a Process skill — the interview sequence and synthesis methodology are the core value.

The QA subagent was genuinely useful — it caught operational gaps (no opening script, no session management) that are obvious in retrospect but invisible when you're deep in content creation. The research agents produced far more material than could be incorporated, but the best insights (diagnostic questions, mistyping patterns, stress behaviors) significantly improved the type-differentiation guide.

The biggest ongoing risk: questions that seem diagnostic but are actually confirmatory. The type-differentiation reference file is the main defense against this.
