---
description: QA patterns specific to AI-assisted development — where AI builds and AI must also verify
audience: { human: 10, agent: 90 }
purpose: { wisdom: 40, constraint: 35, knowledge: 25 }
---

# AI QA Patterns

When AI builds the code, AI must also wear the QA hat. This creates a unique challenge: the builder and the tester are the same entity. The biases are the same. The blind spots are the same.

This reference exists to counteract those biases.

---

## The Core Problem

You (Claude) are optimized to produce plausible, helpful output quickly. This is the exact opposite of what QA requires. QA requires skepticism, slowness, and the assumption that something is wrong until proven otherwise.

When you build a feature and then verify it, you are confirming your own assumptions. You must actively work against this.

---

## AI-Specific Failure Patterns

### 1. Plausible But Wrong
AI code looks correct. It follows patterns. It compiles. But the business logic is subtly wrong because you pattern-matched from training data instead of reasoning from the specific requirements.

**Counter**: After building, re-read the requirements. Does your implementation match what was ASKED, or what you ASSUMED was asked?

### 2. Happy Path Tunnel Vision
You built the happy path first (because that's what was requested), and then you either forgot the error paths entirely or bolted them on as afterthoughts.

**Counter**: For every happy path, immediately ask: "What are the three most likely ways this fails?" Build those paths too.

### 3. Integration Blindness
You built Component A. Then Component B. Both work in isolation. But when A calls B, the data shape doesn't match, or the error handling doesn't chain, or the state management conflicts.

**Counter**: After building components, explicitly test the seams. Call A's output into B's input. Verify the full chain.

### 4. Confident Incorrectness
You presented your work with authority. The user accepted it. The bug shipped. You were wrong, but you sounded right.

**Counter**: Hard Constraint #5 — never hide gaps. If you're not confident in something, say so. "I believe this is correct but I haven't verified the cascade behavior" is infinitely better than silence.

### 5. Stale Assumptions
You assumed a library API works a certain way based on training data. The API has changed. Your code compiles because the method exists but the behavior is different.

**Counter**: When using APIs you haven't verified in this session, check the actual behavior. Run the code. Read the current docs.

### 6. Over-Abstraction
You created a clean abstraction because the pattern felt right. The abstraction introduced complexity that makes the code harder to verify and debug.

**Counter**: Before abstracting, ask: "Does anyone need this flexibility? Or am I engineering for an imaginary future?"

---

## The Self-Verification Protocol

After building anything non-trivial, run this protocol:

### Step 1: Pause
Stop building. Switch from "builder" mode to "reviewer" mode. These are different cognitive states.

### Step 2: Re-Read Requirements
Do they match what you built? Not "is what I built good" but "is what I built what was asked for?"

### Step 3: Trace the Critical Path
Follow the primary user workflow from start to finish. Not in your head — actually trace the code execution or run it.

### Step 4: Probe the Seams
Where do components connect? Where does data flow from one system to another? Test those boundaries.

### Step 5: Test the Error Paths
What happens when:
- The database is unreachable?
- The input is empty, null, malformed?
- The user doesn't have permission?
- The operation is interrupted midway?
- Two users do the same thing simultaneously?

### Step 6: Report Honestly
What you tested. What you found. What you didn't test. What you're not confident about.

---

## The Questions Your User Will Ask

Anticipate these before presenting work:

1. **"Does the data look right?"** — Not "is data present" but "is it the correct data with correct relationships?"
2. **"What happens if I do X?"** — Where X is the thing you didn't test. They will find it.
3. **"Did you actually test this or just build it?"** — Be honest. "I built it and verified the happy path. I haven't tested error handling" is the right answer.
4. **"What would break this?"** — Think adversarially. What's the weakest point?
5. **"Is this complete?"** — Not "does it compile" but "does it handle the full scope including edge cases, error states, and data integrity?"

---

## The Two Hats Problem

You cannot simultaneously be the builder and the tester at the same quality level. The builder wants the code to work. The tester wants to find out if it doesn't.

Practical approaches:
- **Time separation**: Build first, then deliberately switch to testing mode
- **Perspective separation**: "If I were a new engineer reviewing this code, what would I question?"
- **Checklist separation**: Use the verification checklist as an external prompt, not internal reasoning
- **Explicit gaps**: When in doubt, state what you haven't verified rather than implying completeness

The goal is not perfect self-testing. The goal is honest self-assessment that gives the human accurate confidence levels.

---

*The AI that says "I'm not sure this is right" is more trustworthy than the AI that says "this is correct" without evidence.*
