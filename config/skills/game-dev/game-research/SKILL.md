---
name: game-research
description: Structured game development research with solo-dev feasibility filtering. Use when investigating engines, genres, art styles, tools, or any game-dev decision. Wraps the research skill with game-specific framing. Outputs feed into decision-journal.
zones: { knowledge: 30, process: 35, constraint: 15, wisdom: 20 }
---

# game-research

Research for someone who is learning to build, not someone who already knows how.

---

## Before Starting

1. **Invoke the `research` skill.** This skill extends it, not replaces it. The research skill's stance, evidence hierarchy, and citation requirements all apply.
2. **Invoke the `decision-journal` skill.** Know the output format before gathering.

---

## The Solo Dev Filter

Every research direction must pass through this question:

**Can one person, who is still learning, achieve this within a reasonable timeline?**

This filter eliminates:
- AAA production pipelines requiring teams of 50+
- Technologies with 2+ year learning curves before productive use
- Art styles requiring professional training the user doesn't have
- Scope that assumes full-time development when this is a side project

When presenting findings, always include a feasibility assessment for a solo learner.

---

## Research Domains

### Domain Dependency Map

```
Genre & Scope
├── Engine (what can run it?)
│   └── Language (what does the engine use?)
│       └── Learning Path (how do I learn it?)
├── Art Style (what fits the genre?)
│   └── Art Tools (what produces this style?)
└── Sound & Music (what does the genre need?)
```

**Research in dependency order.** Don't research art tools before knowing the art style. Don't research languages before knowing the engine.

### Domain Reference

| Domain | Key Questions | Solo Dev Traps |
|--------|--------------|----------------|
| **Genre & Scope** | What's achievable? What sells on Steam? What do you enjoy? | Scope creep. "Just one more feature" syndrome. Comparing to AAA. |
| **Engine** | Learning curve? Community? Export to Steam? Language support? | Choosing based on capability ceiling, not learning floor. |
| **Language** | Learning resources? boot.dev courses? Transferable skills? | Picking the "best" language instead of the most learnable. |
| **Art Style** | Achievable solo? Consistent at scale? Asset pipeline? | Pixel art "looks easy" but consistency is hard. 3D has a huge tool learning curve. |
| **Art Tools** | Cost? Learning curve? Export formats? Community? | Tool hopping. Buying expensive tools before committing to a style. |
| **Sound & Music** | Create vs license vs AI? Legal implications? | Underestimating audio's importance, then scrambling at the end. |
| **Game Design** | GDD depth? Prototyping approach? Scope control? | Over-designing before prototyping. GDD as procrastination. |
| **SDLC** | Version control? CI/CD? Testing? | Over-engineering the pipeline before there's code to run through it. |
| **Steam** | Steamworks setup? Store page timing? Wishlists? | Marketing too late. No store page until launch. |
| **Learning** | boot.dev path? Supplementary? Practice projects? | Tutorial hell. Learning without building. |
| **Community** | When to start? Discord? Devlog? | Starting too early (nothing to show) or too late (no audience). |

---

## Research Process

### 1. Frame the question

What decision will this research inform? Be specific.

- Good: "Which game engine has the best learning curve for a beginner targeting 2D games on Steam?"
- Bad: "What game engine should I use?"

### 2. Identify the domain and dependencies

Check the dependency map. Are prerequisite decisions already made? If not, research those first.

Check the `decision-journal` — has this already been decided? If yes, check the revisit trigger before proceeding.

### 3. Define research directions

For each domain, consider:
- **Technical capability** — Can it do what I need?
- **Learning curve** — How long to become productive?
- **Community & resources** — Tutorials, forums, Stack Overflow presence?
- **Solo dev track record** — Have solo devs shipped with this? Examples?
- **Cost** — Free? One-time? Subscription? Revenue share?
- **Longevity** — Is this actively maintained? Growing or dying?

### 4. Conduct research

Follow the `research` skill's process:
- Launch parallel subagents for different directions
- Include one subagent for "directions I haven't thought of"
- Apply the solo dev filter to all findings

### 5. Synthesize

Present findings using the `research` skill's output format. Add:
- **Solo dev feasibility**: explicit rating (high/medium/low) with justification
- **Learning investment**: estimated time to become productive (not to mastery)
- **Decision recommendation**: what the evidence points toward (synthesis, not prescription)

### 6. Record the decision

After the user decides, invoke `decision-journal` to create an entry with:
- Alternatives considered (from research)
- Evidence links (from research output)
- Revisit trigger (from the findings)
- Confidence level (based on research depth)

---

## Steam Market Context

When researching genres, include Steam market data:

- **What sells for solo devs?** Look at indie success stories, not AAA.
- **Saturated vs underserved genres** — 2D platformers are saturated. Niche genres may have smaller but more passionate audiences.
- **Price expectations by genre** — An RPG can charge $20. A puzzle game struggles above $10.
- **Wishlist-to-sale conversion** — Industry benchmarks for indie games.
- **Time to recoup** — How many units at what price to cover costs?

Sources: SteamDB, Steam Spy (limited), GDC talks, indie postmortems, How to Market a Game (Chris Zukowski).

---

## Constraints

- Apply the solo dev filter to every finding. Don't present options that require a team.
- Cite sources for every claim. The `research` skill's evidence hierarchy applies.
- Present synthesis, not prescription. "The evidence suggests..." not "You should..."
- Check the decision-journal before researching. Don't re-research settled decisions unless the revisit trigger has been met.
- Account for learning curve, not just capability. "Can do X" means nothing if it takes 2 years to learn.

---

## Deeper

- The `research` skill — Core research methodology and subagent coordination
- The `decision-journal` skill — Where decisions land after research
- `references/research-domains.md` — Detailed questions for each domain

---

*Research for a learner, not an expert. Feasibility before capability.*
