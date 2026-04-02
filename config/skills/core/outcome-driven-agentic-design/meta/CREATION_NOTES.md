# Creation Notes

## What Helped

- Reading the worked examples (AoC folder) was essential. The methodology document describes the theory; the AoC files show what each layer actually looks like at different scales. Without these, the skill would have been too abstract.
- The forms-findings.md document was the best example of what findings can be — four data sources (code, New Relic, Pendo, customer feedback) converging on the same conclusions.
- The zone assessment (wisdom:35, knowledge:30, process:20, constraint:15) correctly identified this as a blended skill. Pure wisdom would have been too sparse — the layer reference table and EARS patterns are load-bearing knowledge content.
- The writing-documents skill already covers how to write each layer. This skill needed to focus on orchestration (when, which layers, how they relate) rather than duplicating writing guidance.

## What the Subagent Test Revealed

- **BacktrackToFix was the biggest gap.** Writing layer N and discovering problems in layer N-1 is the most common real-world situation, and the original skill had no guidance. Added as a capsule.
- **EARS syntax was referenced but not defined.** The plan guide in writing-documents defines it, but the skill used the term repeatedly. Added the pattern table inline.
- **Flows boundary was fuzzy.** "Never Contains: Our API/UX designs" needs a concrete example. Added: "the parent selects which children" (process) vs. "POST /checkin/batch accepts a list" (our API design).
- **Plan granularity** — when to split plans — was not addressed. Added guidance to TruthStatements depth.

## What Would Improve skill-builder

- The wisdom reference says "one screen maximum" but that guidance is for pure wisdom skills. A blended skill with 30% knowledge content needs more space. The skill-builder could be clearer that the one-screen rule scales with wisdom percentage.
- The test step was the most valuable part. The subagent found issues that were invisible from the author's perspective. Consider making the test prompt a template in skill-builder.

## Decisions Made

- **Kept the layer table instead of expanding each layer into its own section.** The table is scannable and the writing-documents skill has the depth. Progressive disclosure.
- **Put verification protocol in a reference, not inline.** SKILL.md has the ErrorCorrectionChain capsule for the concept; verification.md has the operational detail. Agents load it when doing verification work.
- **Did not add file naming/directory guidance.** The worked examples show a pattern (designs/, flows/, plans/, north-stars/) but this is project-specific, not methodology-specific.
- **Did not inline the verification chain summary table.** The SKILL.md layer table already has "Checked Against" column. The verification reference adds operational detail for agents doing actual verification.
