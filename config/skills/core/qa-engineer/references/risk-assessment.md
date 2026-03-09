---
description: How to assess risk and focus testing effort where it matters most
audience: { human: 20, agent: 80 }
purpose: { process: 40, wisdom: 35, knowledge: 25 }
---

# Risk Assessment

You cannot test everything. Risk assessment is how you decide what to test deeply, what to test lightly, and what to skip.

---

## The Principle

Testing effort should be proportional to risk. Risk is the combination of likelihood and impact.

High likelihood + high impact = test deeply, test first.
Low likelihood + low impact = test lightly or skip.

This is obvious in theory. In practice, most people test what's easy and skip what's hard — which is the exact inverse of risk-based testing.

---

## Risk Dimensions

### Likelihood
How probable is a failure?

| Factor | Increases Likelihood |
|--------|---------------------|
| Complexity | More branches, more states, more ways to fail |
| Novelty | New code, new patterns, new integrations |
| Change frequency | Areas that change often accumulate defects |
| Developer confidence | "This should be fine" is a risk signal, not reassurance |
| AI-generated | AI code is syntactically correct and semantically plausible — but it assumes |

### Impact
How bad is the failure if it happens?

| Factor | Increases Impact |
|--------|-----------------|
| Data integrity | Can it corrupt, lose, or expose data? |
| Financial | Can it affect payments, billing, accounts? |
| Security | Can it be exploited? Does it expose credentials? |
| User trust | Will users lose confidence in the product? |
| Blast radius | How many users/systems are affected? |
| Reversibility | Can the damage be undone? |

---

## Quick Risk Matrix

For each area of a change, place it on the matrix:

```
                    High Impact
                        │
         ┌──────────────┼──────────────┐
         │              │              │
         │   DEEP TEST  │  DEEP TEST   │
         │   (monitor)  │  (first)     │
         │              │              │
Low ─────┼──────────────┼──────────────┼───── High
Likelihood│              │              │  Likelihood
         │              │              │
         │   SKIP or    │  MODERATE    │
         │   LIGHT TEST │  TEST        │
         │              │              │
         └──────────────┼──────────────┘
                        │
                    Low Impact
```

### Translation to Action

| Quadrant | Action |
|----------|--------|
| High likelihood + High impact | Test first. Test deeply. Exploratory testing. Multiple scenarios. |
| High likelihood + Low impact | Moderate testing. Automated checks. Quick exploratory pass. |
| Low likelihood + High impact | Test the critical paths. Document what you tested and what you skipped. |
| Low likelihood + Low impact | Light check or skip. Don't spend time here. |

---

## Risk Assessment for Common Change Types

### Data Model Changes
**Default risk: HIGH.** Data model changes cascade through every layer.
- FK relationships: verify constraints hold under insert, update, delete
- Cascades: verify delete/update cascades don't orphan or destroy unintended data
- Migrations: verify up AND down, verify data integrity after migration
- Indexes: verify query performance didn't degrade
- Nullability: verify all consumers handle null correctly

### API Changes
**Default risk: MEDIUM-HIGH.** Contracts are promises to consumers.
- Request validation: all invalid inputs return appropriate errors
- Response shape: consumers won't break on the new shape
- Auth: every endpoint enforces authorization
- Error responses: structured, helpful, not leaking internals
- Rate limiting: still functional after changes

### UI Changes
**Default risk: MEDIUM.** Varies wildly based on what changed.
- Rendering: correct data, not just correct layout
- Interactions: full user flow, not just individual clicks
- State: what happens on refresh, back button, concurrent tabs?
- Accessibility: keyboard navigation, screen reader, contrast
- Responsive: different viewport sizes if relevant

### Configuration Changes
**Default risk: MEDIUM.** Often underestimated.
- Invalid values: what happens with wrong types, missing values, extra values?
- Defaults: are defaults sensible? What if the config is completely absent?
- Environment differences: does this work in dev AND production?
- Rollback: can the old config work with the new code?

### Dependency Updates
**Default risk: VARIES.** Check the changelog.
- Breaking changes in the changelog? → HIGH
- Security patch only? → LOW (but verify it applies)
- Major version bump? → HIGH (API surface may have changed)

---

## Risk Assessment for AI-Built Code

AI has characteristic risk patterns. Apply these multipliers:

| AI Pattern | Risk Multiplier | Why |
|------------|----------------|-----|
| Multiple components built in one session | 1.5x | Integration seams accumulate |
| Database schema and code built together | 2x | Schema assumptions propagate unchecked |
| "It works in my test" | 1.5x | AI tests the happy path by default |
| Complex business logic | 2x | AI patterns-matches from training data, may not match your domain |
| Auth/security code | 2x | Getting it "mostly right" is not right |
| Copy-paste from documentation | 1.2x | Docs may be outdated or for a different version |

---

## How to Document a Risk Assessment

Keep it lightweight. A risk assessment is a thinking tool, not a deliverable.

```
## Risk Assessment: [Feature/Change Name]

### High Risk (test deeply)
- [Area]: [Why it's high risk]
- [Area]: [Why it's high risk]

### Medium Risk (moderate testing)
- [Area]: [Why]

### Low Risk (light check)
- [Area]: [Why]

### Not Tested (and why)
- [Area]: [Accepted risk because...]
```

The "Not Tested" section is the most important. It makes the gaps explicit instead of hidden.

---

*Risk assessment is not about eliminating risk. It is about knowing where the risk lives and choosing how to spend your time.*
