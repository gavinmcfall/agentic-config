# Ticket Templates

Use these as starting points when creating Plane tickets. Adapt to fit — they're templates, not forms.

---

## Feature Ticket

```
Title: [Imperative verb] [specific thing]
  e.g., "Add player double-jump mechanic"

Size: S / M / L
Energy: high-energy / low-energy
Domain: gameplay / art / audio / engine / tools / learning

Done when:
- [ ] [Specific, observable outcome 1]
- [ ] [Specific, observable outcome 2]
- [ ] Committed and tested

Notes:
[Context, approach ideas, reference links]
```

**Example:**
```
Title: Add player double-jump mechanic
Size: M
Energy: high-energy
Domain: gameplay

Done when:
- [ ] Player can jump once from ground
- [ ] Player can jump again while airborne (once)
- [ ] Jump resets on landing
- [ ] Animation triggers for both jumps
- [ ] Committed and tested

Notes:
See Celeste devlog for coyote time reference. Consider adding later.
```

---

## Bug Ticket

```
Title: Fix [what's broken]
  e.g., "Fix player falling through floor on slopes"

Size: S / M / L
Energy: high-energy / low-energy
Domain: gameplay / art / audio / engine / tools

Steps to reproduce:
1. [Step]
2. [Step]
3. [Observe: what happens]

Expected: [What should happen]
Actual: [What actually happens]

Done when:
- [ ] Bug no longer reproduces
- [ ] No regressions in related behavior
- [ ] Committed and tested
```

---

## Learning Ticket

```
Title: Complete [course/tutorial name]
  e.g., "Complete boot.dev GDScript fundamentals"

Size: S / M / L
Energy: high-energy / low-energy
Domain: learning

Done when:
- [ ] Course/tutorial completed
- [ ] Built [practice thing] using what was learned
- [ ] Key takeaways noted in breadcrumbs

Notes:
[Link to course/resource]
```

**The practice requirement is key.** A completed tutorial without applied practice is tutorial hell. The ticket isn't done until something is built.

---

## Research Ticket

```
Title: Research [question]
  e.g., "Research 2D art styles achievable solo"

Size: M / L (research is rarely S)
Energy: high-energy
Domain: [relevant domain]

Question: [Specific question this research answers]
Decision: [What decision-journal entry will this inform?]

Done when:
- [ ] Research conducted (invoke game-research skill)
- [ ] Findings documented
- [ ] Decision journal entry created (if decision was made)
- [ ] Follow-up tickets created (if applicable)
```

---

## Infrastructure Ticket

```
Title: [Deploy/Configure/Fix] [service/tool]
  e.g., "Deploy Gitea on k8s cluster"

Size: S / M / L
Energy: low-energy (usually — deployment is procedural)
Domain: tools

Done when:
- [ ] Service deployed/configured/fixed
- [ ] Accessible at expected URL
- [ ] Verified working with basic test
- [ ] Committed to home-ops repo (if k8s)

Notes:
[Reference home-ops-deployer skill for k8s deployments]
```

---

## Chore Ticket

```
Title: [Clean up / Reorganize / Update] [specific thing]
  e.g., "Reorganize asset folder structure"

Size: S / M
Energy: low-energy (usually)
Domain: [relevant domain]

Done when:
- [ ] [Specific, observable outcome]
- [ ] No regressions
- [ ] Committed

Notes:
[What prompted this — tech debt, folder mess, outdated config]
```

Chores include: refactoring, folder reorganization, dependency updates, config cleanup, dead code removal. They're low-energy work that keeps the project healthy.

---

## Spike Ticket

A spike is time-boxed exploration. The output is knowledge, not code.

```
Title: Spike: [what you're exploring]
  e.g., "Spike: Can Godot handle 1000 on-screen enemies at 60fps?"

Size: M (always M — spikes are time-boxed to half a day)
Energy: high-energy
Domain: [relevant domain]

Question: [What are you trying to learn?]
Time box: [2-4 hours maximum]

Done when:
- [ ] Time box expired, OR answer found (whichever first)
- [ ] Findings documented (even if "I don't know yet")
- [ ] Next action decided: continue (new ticket), pivot, or abandon

Notes:
The spike is DONE when the time runs out, regardless of whether
you have a complete answer. Incomplete answers are still progress.
```

---

## Quick Sizing Guide

| If the ticket involves... | Likely size |
|--------------------------|-------------|
| Changing a few lines of code | S |
| Adding a self-contained feature | M |
| Building a new system or refactoring | L (break it down) |
| Completing a short tutorial | S |
| Completing a course module | M |
| Full research investigation | L (break into phases) |
| Deploying an app to k8s | M |
| Fixing a known bug with clear repro | S |
| Investigating a mysterious bug | M (spike first) |

---

*Every ticket answers: what am I building, and how do I know it's done?*
