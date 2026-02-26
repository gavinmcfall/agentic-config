# Creating Your Inner Ally

The inner-ally skill is a deeply personal mentor that knows your psychology. The template provides the structure — you provide the content.

## Why This Skill Exists

When you're stuck, overwhelmed, or wanting to quit, generic encouragement doesn't help. A mentor who knows your specific patterns — what triggers you, what actually works, what makes things worse — can intervene effectively.

This skill encodes that knowledge so Claude can be that mentor.

## What You Need

Before filling in the template, gather information about yourself:

### 1. Personality Frameworks (pick what resonates)

You don't need all of these. Use whatever frameworks you've found genuinely useful:

- **MBTI** — Your type and what it means for how you process decisions and stress
- **Enneagram** — Your type + wing, especially your stress/growth arrows
- **DISC** — Your profile and what it means for work style
- **Neurodivergence** — ADHD, autism, OCD, or other profiles and their practical implications
- **Attachment style** — How you relate to others and to your work
- **Values/strengths assessments** — What drives you

### 2. The Tensions

The most valuable part of this skill is documenting how your traits **contradict each other**:

- "I need novelty (ADHD) but I crave stability (DISC S)"
- "I want to be strong (Enneagram 8) but I feel everything deeply (INFJ)"
- "I can't start tasks (ADHD) but I can't stop once started (OCD)"

These tensions are where you actually get stuck. Generic personality descriptions miss them.

### 3. Your Patterns

Document your specific patterns:

- **Quitting patterns**: What does "about to quit" look like for you? What are the early warning signs?
- **Recovery patterns**: What has actually worked to pull you out of a slump?
- **Energy patterns**: When are you most productive? What drains you?
- **Avoidance patterns**: What do you do instead of the hard thing?

### 4. What Helps (and What Doesn't)

Be specific about what kind of support works:

- "Don't tell me it'll be fine — show me evidence that I've done this before"
- "Don't give me a pep talk — give me a tiny next step"
- "Acknowledge the feeling first, then suggest action"
- "Never say 'just' — it minimizes the difficulty"

## Filling In the Template

Open `~/.claude/skills/inner-ally/SKILL.md` and fill in each capsule:

### TheRealYou Capsule

Write the core tension paragraph. Not a list of types — the story of how they interact.

### QuittingPatterns Capsule

Describe your specific quitting signals with concrete examples.

### WhatActuallyHelps Capsule

List the interventions that have worked, with specific examples.

### Non-Negotiable Response Rules

These are instructions for how Claude should respond when using this skill. Be direct:
- "Never use toxic positivity"
- "Always acknowledge what I'm feeling before suggesting anything"
- "Use evidence from my past successes, not generic encouragement"

## Testing It

The best way to test this skill is to invoke it when you're actually struggling. If the response feels generic or off-base, the content needs more specificity.

Iterate after each real use. The skill gets better as you refine the patterns.

## Privacy

This skill contains deeply personal information. It lives only in your local `~/.claude/skills/` directory. It is never sent to anyone unless you explicitly share it.

If you use the config-packager skill to update a public repo, the inner-ally content is automatically replaced with the template skeleton. Your personal data never leaves your machine.
