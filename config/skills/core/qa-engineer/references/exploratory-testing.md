---
description: How to do exploratory testing when there are no scripts to follow
audience: { human: 20, agent: 80 }
purpose: { wisdom: 50, process: 30, knowledge: 20 }
---

# Exploratory Testing

Exploratory testing is simultaneous learning, test design, and test execution. You don't write a script and then follow it. You observe, form hypotheses, probe, and adapt in real time.

---

## The Mental Model

Exploratory testing is an investigation, not an audit. You are a detective, not an inspector.

An inspector has a checklist and walks through it. A detective follows evidence, asks questions the checklist never thought of, and finds things nobody expected.

Both are necessary. Neither replaces the other.

---

## Session-Based Exploration

Structure exploration without scripting it.

### Charter
A one-sentence mission that focuses the session:

> "Explore the payment flow with expired credit cards to discover how error handling behaves."

A charter has three parts:
1. **Target**: what area or feature
2. **Condition**: what scenario, state, or configuration
3. **Purpose**: what you're looking for (behavior, risk, edge cases)

### Time Box
Set a boundary. 25-45 minutes per session. Long enough to go deep, short enough to stay focused.

### Notes
Write what you find as you go. Not a test case — an observation log:
- What you tried
- What happened (expected or not)
- What surprised you
- What you want to investigate further

---

## Heuristics for Exploration

When you don't know what to test, use these thinking tools:

### SFDIPOT (San Francisco Depot)
Seven categories to probe any feature:

| Category | Questions to Ask |
|----------|-----------------|
| **Structure** | What is it made of? Components, data structures, dependencies? |
| **Function** | What does it do? All the things it should do? |
| **Data** | What data does it consume, produce, transform? Boundaries? Formats? |
| **Interfaces** | What does it connect to? APIs, databases, other features, users? |
| **Platform** | What environment does it run in? OS, browser, network conditions? |
| **Operations** | How is it deployed, configured, maintained, monitored? |
| **Time** | What happens over time? Timeouts, expiration, sequencing, concurrency? |

### Boundary Values
Every input has edges. Test them:
- Empty / null / missing
- Zero / negative / maximum
- Just below and just above limits
- Unicode, special characters, injection strings
- Very long, very short

### State Transitions
Features have states. Test the transitions:
- Can you reach every state?
- Can you transition in unexpected orders?
- What happens if you interrupt a transition?
- What state are you left in after an error?

### Personas
Think as different users:
- The new user who doesn't know the conventions
- The power user who moves fast and breaks things
- The hostile user who is actively trying to break it
- The user with accessibility needs
- The user on a slow connection with a small screen

---

## Exploration for AI Agents

When Claude is doing the building AND the testing, the exploration changes shape:

### Self-Exploration Pattern
1. Build the feature
2. Step back. Pretend you didn't build it.
3. Ask: "If I were a user who just encountered this, what would I try?"
4. Ask: "What assumptions did I make that I haven't verified?"
5. Probe the assumptions

### Seam Testing
AI-built code has characteristic failure points:
- **Integration seams**: where separately-built components meet
- **Data contract seams**: where data shapes are assumed but not enforced
- **Error path seams**: where happy-path code meets reality
- **State management seams**: where state is shared between components

Focus exploratory effort on seams. The individual components usually work; the connections between them often don't.

### The "What Would the User Ask?" Test
Before presenting work:
1. Is the data correct, not just present?
2. Do the relationships hold under manipulation?
3. What happens when I follow the full user workflow, not just the component?
4. What did I skip?
5. What am I not confident about?

If you can answer those honestly, you're testing. If you're just checking that the page loads, you're not.

---

## Browser-Assisted Exploration

When Playwright MCP or similar browser automation is available, use it for systematic visual exploration — not just automated checking.

### Visual Review Protocol
1. **Navigate every user-facing page** — not just the page you changed
2. **Take full-page screenshots** at each step — visual evidence beats memory
3. **Cross-reference against data layer** — is the displayed data correct, not just present?
4. **Check responsive breakpoints** — key widths where layout shifts
5. **Test dynamic content** — conditional visibility, loading states, empty states

### Effective Browser Exploration Patterns
- `waitForLoadState('networkidle')` — reliable page-ready signal
- Conditional checks: `if (await element.isVisible())` — handle dynamic content gracefully
- Full-page screenshots at workflow milestones — not just on failure
- Explicit selectors (`locator('button', { hasText: /^Submit$/i })`) over fragile CSS selectors

### What Visual Review Catches That Code Review Misses
- Data that's present but wrong (correct component, incorrect data source)
- Layout issues that only appear with real data lengths
- Missing empty states (looks fine with data, broken without)
- Navigation dead ends (page exists but nothing links to it)
- Inconsistent styling between similar pages

---

## When Exploration Finds Something

Don't just note the bug. Investigate:
- Is this isolated or systemic?
- What's the root cause? (Not just the symptom)
- What other areas might be affected by the same cause?
- How severe is the impact to the user?

Then decide: fix now, flag for later, or accept the risk. Make the decision explicit.

---

*Exploration is not random. It is structured curiosity guided by risk.*
