---
name: playtest-coordinator
description: Plan and run playtests for a solo dev game. Use when deciding when to test, finding testers, structuring sessions, collecting feedback, processing results, or preparing for Steam Next Fest. Includes ADHD-specific strategies for handling emotional feedback.
zones: { knowledge: 25, process: 30, constraint: 20, wisdom: 25 }
---

# playtest-coordinator

Playtesting isn't asking "do you like my game?" It's watching someone play it without saying a word.

---

## Capsule: ProblemsNotSolutions

**Invariant**
Players are excellent at identifying problems. They are poor at diagnosing causes or proposing solutions. Listen to what felt wrong; treat their suggested fixes as data points, not instructions.

**Example**
A tester says "you should add a minimap." The problem isn't a missing minimap — it's that they got lost. The solution might be better level design, landmarks, lighting, or yes, a minimap. But you decide that, not the tester.
//BOUNDARY: When multiple testers independently suggest the same solution, it gains weight. But even then, verify the underlying problem first.

**Depth**
- Testers subconsciously try to turn the game into something they want to play
- The gap between what players say and what players do is where the most valuable insights live
- Ask "what frustrated you?" not "what should I add?"
- Pattern matters more than volume: one complaint is noise, five identical complaints at the same point is signal

---

## Capsule: ShutUpAndWatch

**Invariant**
During a playtest session, do not explain, help, or defend your design. Every time you intervene, you learn nothing.

**Example**
A tester can't figure out how to open the inventory. They fumble for 30 seconds. Every fiber of your being wants to say "press I." Don't. That 30 seconds just told you your UI doesn't communicate inventory access. If you tell them, you lose that insight forever.
//BOUNDARY: If the player hits a game-breaking bug (crash, softlock), you can intervene. But a player being confused is not a bug — it's data.

---

## What to Test When

| Stage | Focus | Key Questions |
|-------|-------|--------------|
| **Prototype** | Core mechanics feel | Is the core loop fun? Do controls feel good? |
| **Alpha** | Systems, balance, progression | Do systems work together? Is pacing right? |
| **Beta** | Polish, onboarding, bugs | Can a new player figure it out without help? |
| **Pre-release** | Full experience | Does the whole thing hold together? Would they buy it? |

Test as soon as you have something playable, even if it's ugly. Fundamental problems found late are expensive or impossible to fix.

---

## Finding Testers

### Free Sources

| Source | Best For | Notes |
|--------|----------|-------|
| **r/playmygame** | Early feedback | Game must be free to play. 1 post per calendar month. |
| **r/indiegaming, r/gamedev** | Visibility, reciprocal testing | Contribute to community first (2-3 months before asking) |
| **Discord** | Ongoing community | Genre-specific servers with #playtest channels |
| **itch.io** | Creative/experimental games | Playtesting board, devlog audience |
| **Steam Playtest** | Gated beta access | Separate appID linked to main game, free |
| **Local meetups / game jams** | In-person observation | Uniquely valuable — body language, real-time reactions |

### Incentives That Work
- Early access to a special build
- Credit in the game
- Reciprocal playtesting (you test mine, I test yours)

---

## Running a Session

### Before

- Define what you're testing (pick 1-2 aspects, not everything)
- Prepare 3-5 specific questions you want answered
- Set up recording (OBS Studio or Xbox Game Bar at minimum)
- Verify the build is stable enough to complete the test scenario
- Write a brief scenario if needed ("play through the first level")

### During

- **Observe silently.** Watch where they pause, what confuses them, what delights them.
- **Do not explain.** Even if they ask. Even if they insist. Your game must speak for itself.
- **Do not defend.** Resist the urge to justify design choices. You're here to learn, not to teach.
- **Take notes.** Track confusion points, delight moments, frustration spikes.
- **Record everything.** You will not remember accurately.

Sit behind the player, not beside them — this reduces the impulse to intervene.

### After

- Ask your prepared questions (not before — you want uncontaminated play first)
- Ask open-ended follow-ups: "Tell me about a moment that confused you" not "Was the puzzle confusing?"
- Avoid loaded questions that reveal what you were watching for
- Thank them — they just did you a significant favor

### Asynchronous / Remote Playtesting

When you can't observe directly (Steam Playtest, itch.io distribution):
- Embed a feedback button in-game linking to a form or Discord
- Ask testers to record their session with OBS (provide brief instructions)
- Use analytics/telemetry to see where players quit, die, or get stuck
- Surveys become your primary feedback channel — make them specific
- You lose body language and real-time observation, so watch any recorded sessions carefully

Async testing trades depth for reach. Use it for volume feedback; use in-person observation for deep insights.

---

## Collecting Feedback

### Methods

| Method | What It Reveals | Tools |
|--------|----------------|-------|
| **Observation** | What players actually do | In-person, recorded sessions |
| **Think-aloud** | What players are thinking in the moment | Concurrent or retrospective |
| **Surveys** | Structured responses to specific questions | Google Forms, Typeform |
| **Analytics** | Behavioral patterns at scale | GameAnalytics (free), Unity Analytics |
| **Bug reports** | Technical issues | BetaHub (free, Discord integration) |

### Survey Design

- Keep short: 3-5 questions in-game, up to 10-15 post-session
- Ask specific questions: "Which parts felt boring or frustrating?" not "Did you like it?"
- Include both rating scales (1-5) and open-ended responses
- Add an in-game feedback button linking to Discord or a form

---

## Processing Feedback

### Priority Framework

| Priority | Category | Example |
|----------|----------|---------|
| 1 | **Blocks progress** | Crash, softlock, can't figure out how to start |
| 2 | **Undermines core loop** | Core mechanic feels bad, main activity isn't fun |
| 3 | **Confuses consistently** | Multiple players misunderstand the same element |
| 4 | **Polish and feel** | Animation timing, juice, sound feedback |
| 5 | **Personal preference** | "I wish it had X feature" from one person |

### Distinguishing Signal from Noise

- **One player stuck** = might be a skill issue
- **Five players stuck at the same spot** = design issue
- **Contradictory feedback**: Check if testers are in your target audience. Look for the underlying experience, not the surface complaint.
- **Feedback from outside your target audience**: Note it, but weight it lower

### The Two Types of Feedback

- **Sympathetic** (friends, community, fellow devs): Assumes your game will succeed. Good for improvement.
- **Unsympathetic** (strangers, public comments): More representative of the market. Better for business decisions.

You need both. Sympathetic feedback too early feels good but misleads. Unsympathetic feedback too early destroys motivation.

---

## ADHD and Feedback

### The RSD Problem

Rejection Sensitive Dysphoria makes feedback feel like personal attack. The prefrontal cortex processes criticism of your work as criticism of you. This is neurological, not a character flaw.

### Before a Playtest

- Write down: "Feedback is about the game, not about me"
- Prepare a self-compassion phrase: "This is RSD. It will pass."
- Set the rule: **No design changes for 24 hours after receiving feedback.** Non-negotiable.

### Processing Feedback with ADHD

- **Batch processing, not streaming.** Read feedback in 30-minute windows, then stop.
- **Parking lot document.** Write down every reaction to feedback. Come back the next day. The emotional charge dissipates; the useful observations remain.
- **One change per playtest cycle.** Pick the single highest-priority issue. Fix that. Playtest again. This is a constraint, not a suggestion.
- **"Will not do" list.** Explicitly deciding not to do something satisfies the ADHD brain more than leaving it ambiguous.
- **Physical kanban board.** Sticky notes on a wall. ADHD "out of sight, out of mind" means digital tools lose to physical visibility.
- **Maximum 3 active tasks.** More than this triggers paralysis.

### The Impulse to Change Everything

Every piece of feedback feels urgent. The ADHD brain wants to act on all of it right now. This leads to:
- Scope creep (small additions snowball)
- Design-by-committee (satisfies no one)
- Losing the original vision

The constraint is one change per cycle. Write the rest down. Most of it won't matter tomorrow.

---

## Steam Next Fest

### What It Is

A multi-day event (3x/year: February, June, October) where players try demos. ~3,000 demos compete.

### Realistic Expectations

| Tier | Wishlists |
|------|-----------|
| Top 5% | ~7,000 |
| Top 10% | ~3,000 |
| Median | <500 |

Games that do best already have momentum. Next Fest capitalizes on momentum — it doesn't create it.

### Demo Design

- Target 30-90 minutes of available content (but most players will only play 15-25 minutes)
- Polish the first 15 minutes obsessively — that's all most players will see
- Include "Wishlist the full game" call-to-action at the end
- Add an in-game feedback button (Discord or form)
- No placeholder art or missing sound in the demo

### Preparation Timeline

| When | Action |
|------|--------|
| 3-6 months before | Build and polish the demo |
| 6-8 weeks before | Test the demo at smaller events first |
| 4+ weeks before | Influencer/streamer outreach |
| 2-3 weeks before | Release demo publicly (builds pre-event momentum) |
| 14+ days before | Submit build to Valve for review |
| Event week | Livestream, engage community hub, monitor feedback |

### When to Participate

**Not your first time making a demo.** Test at smaller events first (itch.io, game jams). Participate in Next Fest when:
- Demo is polished and crash-free
- You have some audience (even 50-100 Discord members)
- Store page is complete with trailer and screenshots
- You have time during event week to engage

---

## Tools

### Playtesting Platforms

| Tool | Cost | Best For |
|------|------|----------|
| **Steam Playtest** | Free | Gated beta access via Steam |
| **BetaHub** | Free | Bug tracking with Discord/engine integration |
| **PlaytestCloud** | Paid | Unmoderated remote testing with recordings |

### Feedback Collection

| Tool | Cost | Best For |
|------|------|----------|
| **Google Forms** | Free | Post-session surveys |
| **OBS Studio** | Free | Screen + audio recording |
| **GameAnalytics** | Free tier | Retention, progression, funnel analysis |
| **Discord** | Free | Ongoing community feedback channels |

---

## Constraints

- Do not explain, help, or defend during playtest sessions
- No design changes for 24 hours after receiving feedback
- One change per playtest cycle — fix the highest-priority issue, then retest
- Test 1-2 aspects per session, not everything
- Test with target audience, not just whoever is available
- Test as early as possible — prototype stage is not too early

---

## For AI Assistants

When helping with playtesting:

1. **Check the stage**: "What development stage are you at?" Different stages need different playtest approaches. A prototype needs mechanics testing, not bug hunting.
2. **Enforce the silence rule**: If the user describes explaining things during a session, flag it. "Every time you explain, you lose data. Let the game speak."
3. **ADHD buffer**: After the user shares feedback they received, check emotional state before diving into analysis. "How are you feeling about this feedback? Let's process it in batch — top 3 issues only."
4. **One change rule**: If the user wants to implement multiple changes from a single playtest, enforce the constraint. "Pick the single most important issue. Fix that. Playtest again."
5. **Next Fest readiness**: If the user is considering Next Fest, check readiness. "Is the demo polished and crash-free? Have you tested it at a smaller event first?"
6. **Prioritize observation**: If the user is only using surveys, suggest observation. "Surveys tell you what people say. Watching them play tells you what they actually do."

---

## Deeper

- The `prototype-coach` skill — What to prototype before playtesting
- The `adhd-coach` skill — Emotional regulation beyond playtesting
- The `scope-guardian` skill — Preventing feedback-driven scope creep
- The `steam-publisher` skill — Steam Playtest feature, Next Fest preparation
- The `gdd-writer` skill — Updating GDD based on playtest findings
- The `sprint-manager` skill — Playtest tasks in sprint planning

---

*The most valuable feedback is the silence when someone gets stuck and you don't help them.*
