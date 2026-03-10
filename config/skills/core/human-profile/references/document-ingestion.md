# Document Ingestion Guide

When a user provides existing assessment results instead of (or alongside) interview answers, use this guide to extract and cross-reference findings.

## Supported Assessment Types

The skill can process results from any provider for these framework families:

### MBTI / 16Personalities / TypeFinder
- **Look for**: 4-letter type code (e.g., INFJ, ESTP), dichotomy percentages, trait descriptions
- **Key data points**: Type code, individual dimension scores (I/E %, S/N %, T/F %, J/P %), Assertive/Turbulent identity, cognitive function stack
- **Providers**: 16Personalities, Truity TypeFinder, official MBTI, HumanMetrics, etc.
- **Watch for**: 16Personalities uses different terminology (Mind/Energy/Nature/Tactics/Identity) than classical MBTI

### Big Five / OCEAN
- **Look for**: Scores on Openness, Conscientiousness, Extraversion, Agreeableness, Neuroticism
- **Key data points**: Raw scores or percentiles for each dimension, sub-facet scores if available
- **Providers**: Truity, IPIP-NEO, Big Five Inventory, Costa & McCrae NEO-PI-R, etc.
- **Watch for**: Some use 0-100 scales, some use percentiles, some use T-scores (mean 50, SD 10)

### DISC
- **Look for**: Primary/secondary style letters (D, I, S, C), behavioral descriptors
- **Key data points**: Dimension scores, primary and secondary styles, Active/Receptive balance, Agreeable/Skeptical balance
- **Providers**: DiSC (Wiley), DISC (various), Crystal Knows, Tony Robbins DISC, etc.
- **Watch for**: Some show "natural" vs "adapted" profiles (how you are vs how you present at work)

### Enneagram
- **Look for**: Type number (1-9), wing, tritype, instinctual variant (sp/so/sx)
- **Key data points**: Primary type, wing, scores for all 9 types, integration/disintegration arrows, instinctual stacking
- **Providers**: Truity, Enneagram Institute (RHETI), Integrative9, etc.
- **Watch for**: High scores on multiple types — this is diagnostically valuable, not a sign of a bad test

### Values (Schwartz)
- **Look for**: Scores on 10 value dimensions
- **Key data points**: Relative priority ranking: Universalism, Benevolence, Conformity, Tradition, Security, Power, Achievement, Hedonism, Stimulation, Self-Direction
- **Providers**: Gyfted, idrlabs, Schwartz PVQ, etc.

### Learning Styles (VARK)
- **Look for**: Scores on Visual, Aural, Read/Write, Kinesthetic
- **Key data points**: Modality scores, single/multi-modal classification, relative preferences
- **Providers**: VARK questionnaire, various learning style assessments

### Emotional Intelligence (EQ)
- **Look for**: Scores on EQ dimensions
- **Key data points**: Self-Awareness, Other Awareness (Social Awareness), Emotional Control (Self-Management), Empathy, Wellbeing (or equivalent facets)
- **Providers**: Truity, EQ-i 2.0, Goleman-based, etc.
- **Watch for**: Different models use different facet names for similar constructs

### Strengths
- **Look for**: Ranked list of strengths with scores
- **Key data points**: Top 5-10 strengths, bottom 3-5, domain scores
- **Providers**: CliftonStrengths (Gallup), VIA Character Strengths, Personality Quizzes, High5, etc.
- **Watch for**: Different providers use different strength names for similar constructs

## Extraction Process

### Step 1: Identify What You Have
For each document provided:
1. Identify the framework family (MBTI, Big Five, etc.)
2. Identify the specific provider
3. Note the format (PDF, screenshot, text, scores only)
4. Extract all quantitative data (scores, percentages, rankings)
5. Extract all qualitative data (descriptions, strengths/weaknesses narratives)

**Document format handling:**
- **Text-based PDFs**: Extract directly
- **Image-based PDFs** (scanned documents): Render pages to images, then read visually. Many assessment PDFs are image-based or have charts that require visual reading.
- **Screenshots/PNGs**: Read visually — common for online assessment results
- **Encrypted PDFs**: Ask the user for the password, or ask them to export as text/images
- If extraction fails, ask the user to copy-paste the key results or take screenshots of the important pages

### Step 2: Normalize Scores
Convert provider-specific scoring to comparable ranges:
- Percentages: Use as-is (0-100)
- T-scores: Convert to approximate percentile
- Stanines: Convert to approximate percentile range
- Raw categorical (High/Medium/Low): Note as ranges (High ≈ 70-100, Medium ≈ 40-69, Low ≈ 0-39)

### Step 3: Cross-Reference Across Frameworks
Map findings across frameworks to identify:

| Pattern Type | Example |
|---|---|
| **Convergence** | Low E (Big Five) + I preference (MBTI) + S/C style (DISC) = strong introversion signal |
| **Paradox** | High Agreeableness (Big Five) + Type 8 (Enneagram) = caring protector tension |
| **Gap** | High EQ Other-Awareness + Low EQ Self-Management = absorbs but can't regulate |
| **Amplification** | Low Resilience (16P) + Low Optimist (Strengths) + Moderate Neuroticism (Big Five) = compounding vulnerability |

### Step 4: Identify Missing Coverage
Check which frameworks have data and which need interview coverage:

| Framework | Data Available? | If Missing, Interview Phase |
|---|---|---|
| MBTI/Cognitive Style | ☐ | Phase 1, 2, 3 |
| Big Five/OCEAN | ☐ | Phase 1, 2, 3, 4, 6 |
| DISC | ☐ | Phase 3, 4 |
| Enneagram | ☐ | Phase 5, 6, 7 |
| Values | ☐ | Phase 5 |
| Learning Style | ☐ | Phase 2 |
| EQ | ☐ | Phase 4, 6 |
| Strengths | ☐ | Phase 3, 8 |

For any uncovered framework, run the corresponding interview phase(s) to fill the gap.

### Step 5: Synthesize
Follow the same synthesis process as interview mode (see interview-questions.md, Synthesis Prompts section).

## Handling Unknown Assessment Types

If the user provides an assessment you don't recognize:
1. Read the full document to understand what it measures
2. Map its dimensions to the closest known framework
3. Extract all quantitative and qualitative data
4. Note where it provides unique data not covered by standard frameworks
5. Incorporate into the cross-reference matrix

## Quality Signals

### Strong Data
- Percentage scores with clear scales
- Sub-facet breakdowns (not just top-level dimensions)
- Behavioral descriptions with examples
- Growth/development sections

### Weak Data
- Type labels only without scores (e.g., "You're an INTJ" with no dimension percentages)
- Horoscope-style descriptions without behavioral specificity
- Results from very short assessments (under 20 questions)
- Self-reported types without assessment backing

When data quality is low, flag the uncertainty and prioritize interview coverage for those frameworks.
