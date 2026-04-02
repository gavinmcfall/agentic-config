# Discovery: Outcome-Driven Agentic Design Skill

## Sources Examined

- `outcome-driven-agentic-design.md` — The methodology document itself
- `research/market/feedback/direct/archdiocese-of-chicago/` — Full worked example (3 workstreams, 2 north stars, 1 design, 8+ flows, 11+ plans)
- `repositories/churchcommunitybuilder/modernization/forms-findings.md` — Forms discovery findings (exemplary: 4 data sources converging)
- `repositories/churchcommunitybuilder/modernization/forms-north-star.md` — Forms north star (exemplary: user-perspective declarations)
- `.claude/skills/writing-documents/` — All guides, templates, exemplars for findings, north-star, flows, design, plans, research
- `.claude/skills/skill-builder/references/wisdom.md` — Wisdom skill authoring guidance

## What the Methodology Is

A design methodology where permanent documents declare how the system should work, and ephemeral plans close the gap between declaration and reality. Five layers, each building on the previous:

1. **Findings** — Synthesize everything known into evidence
2. **North Star** — Declare what great looks like
3. **Flows** — Describe processes that must exist
4. **Design** — Specify contracts and architecture
5. **Plans** — State what's not true yet

First four are permanent (the "declaration of intent"). Plans are deleted when complete.

## What Claude Would Get Wrong Without This Skill

1. **Treating the declaration as documentation** — It's the source of truth. When declaration and code disagree, the declaration wins. The methodology document explicitly says: "Think of the code as the North Star at maximum magnification."
2. **Writing plans as task lists** — Plans are truth statements ("The family table shall have a household_mailing_name_override column"), not instructions ("Step 1: Create migration").
3. **Skipping the verification chain** — Each layer should be checked against its predecessor. Without this, errors compound silently.
4. **Making changes at code level** — Changes enter at the declaration layer and flow down. Changing code without updating the declaration creates drift.
5. **Not knowing when to skip layers** — Simple changes (e.g., household salutation fix) don't need north stars or designs. Complex new features (OCIA) need the full chain.
6. **Not deleting plans** — Plans are ephemeral. Once truth statements are realized, the plan is deleted.
7. **Putting the wrong content in the wrong layer** — North stars never contain implementation. Flows never contain our API designs. Findings never contain recommendations.

## What Writing-Documents Already Covers

- How to write each document type (detailed guides, templates, exemplars)
- The frontmatter system
- General writing quality rules
- Individual document checklists

## What This Skill Uniquely Provides

1. The methodology as orchestration — how layers relate, when to engage
2. The declaration-as-source-of-truth philosophy
3. The verification chain (each layer checked against predecessor)
4. The change flow (changes enter at declaration, flow down)
5. Scale adaptation (when to use full vs abbreviated methodology)
6. The Product/UX/Engineering workflow
7. Integration with writing-documents for individual layer guidance

## Observations From Worked Examples

**AoC (full methodology):** Three workstreams at different scales. OCIA and Sacraments got the full chain (findings → north star → flows → design → 7 and 4 plans respectively). Household Communications got abbreviated treatment (findings → flows → plans). The methodology scaled to fit.

**Forms findings:** Four data sources (code architecture, New Relic telemetry, Pendo analytics, 164 customer quotes) converged on the same conclusions. The "Where Customer Feedback and Production Data Converge" table is the payoff — showing the same problem from four angles. This is what makes findings powerful: synthesis across sources nobody has read together before.

**Forms north star:** Opens with a narrative "dream paragraph" showing the parent-director-Monday morning experience. Then breaks into evaluable declarations. Every declaration passes the "I have a dream" test. No implementation details.

## Zone Assessment Reasoning

- **Wisdom (35):** The core philosophy is the most important thing to convey. Declaration as source of truth, not documentation. Each layer verifies the previous. Plans as truth statements. Changes flow through declaration. These shifts in thinking reshape how an agent approaches feature work.
- **Knowledge (30):** The five layers, what each contains/doesn't contain, the verification chain specifics, the Product/UX/Engineering workflow. These are facts about the methodology Claude wouldn't know.
- **Process (20):** The sequence matters (findings before north star, etc.). The change flow is a defined process. The verification at each transition follows a pattern.
- **Constraint (15):** The "never contains" rules for each layer, plan deletion requirement, declaration-first changes.
