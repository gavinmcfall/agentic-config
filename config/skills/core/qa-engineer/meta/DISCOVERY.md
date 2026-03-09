# Discovery Notes: qa-engineer

## Source Material
- Context-driven testing school — James Bach & Michael Bolton (Rapid Software Testing)
- 15 years of QA experience distilled into thinking frameworks, not process checklists
- Anti-patterns: ISTQB rigidity, automation-as-strategy, formal test plans, QA-as-gatekeeper

## Key Insights
1. **QA is a thinking discipline, not a testing process.** Emphasis on thinking over following scripts.
2. **The core tension is builder vs verifier.** When AI builds and AI verifies, the same biases apply. This is the unique challenge this skill must address.
3. **The 7-step process has genuine load-bearing order.** Understanding the problem before testing the solution prevents the most common failure: building the right thing wrong vs building the wrong thing right.
4. **Transparency > completeness.** "I didn't test X" is valued over implied completeness. This is a hard constraint.
5. **Workflow thinking, not feature thinking.** Components working in isolation is insufficient. End-to-end flows are the unit of verification.

## Zone Assessment
- Knowledge (15): QA terminology and RST methodology — Claude mostly knows this domain
- Process (20): The 7-step process has genuine ordering requirements
- Constraint (25): Hard rules about never presenting broken work, never skipping validation
- Wisdom (40): The core value is changing how the agent thinks about quality

## Design Decisions
- Made this a standalone core skill, not nested under any group — QA thinking applies to everything
- Reference files split by topic: exploratory testing, risk assessment, verification checklists, personas, AI-specific patterns
- AI-specific patterns reference gets its own file because the "AI building and AI testing" dynamic is unique and deserves dedicated treatment
- Verification checklist is structured as knowledge (what to check) with constraint (non-negotiable minimums)
- Anti-patterns table is the most actionable part for the agent
- QA audit methodology captures a battle-tested 5-phase process from real-world audits
- Test infrastructure patterns (factories, setupTestDatabase, auth helpers, RBAC matrix) incorporated into verification-checklist.md
- Browser-assisted visual review patterns added to exploratory-testing.md from Playwright MCP usage
- Project-local QA context (`.claude/qa-context.md`) convention allows per-project customization without modifying the skill
