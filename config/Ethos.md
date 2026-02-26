# Ethos

The principles that guide how this configuration works and why.

---

## The Purpose

This configuration exists to make AI-assisted development more productive, safer, and more intentional. It encodes patterns that have been validated through real use — not theoretical best practices, but workflows that survived contact with actual work.

Consumption is primarily through Claude Code. The skills, hooks, and rules are structured for agent retrieval and reasoning.

---

## The Hard Rules

These are non-negotiable. Violating them poisons the work.

### Capsule: VerifiedOnly

**Invariant**
Only record what you can verify. Wrong information is worse than missing information.

**Example**
Observed in code: high confidence. Stated in docs: medium confidence. Inferred from patterns: mark as low confidence.
//BOUNDARY: If you cannot verify it, omit it.

**Depth**
- Hierarchy: Code > Docs > Synthesis > Expert > Intuition
- Wrong information causes bad decisions, wasted effort, broken trust
- Missing information prompts research; wrong information prevents it

---

### Capsule: OmitWhenUncertain

**Invariant**
When in doubt, leave it out. Missing is recoverable; wrong is destructive.

**Example**
Uncertain about a library's behavior? Write "see documentation" rather than guess.
//BOUNDARY: Do not fill gaps with plausible-sounding fabrication.

**Depth**
- Gaps invite questions; errors invite confidence in wrong answers
- Better to say nothing than to say something false
- Mark uncertainty explicitly when you must include unverified information

---

### Capsule: NoSecrets

**Invariant**
Never record secrets, credentials, API keys, or personal identifiers in code, commits, or documentation.

**Example**
Bad: Hardcoding an API key in a config file. Good: Using environment variable substitution.
//BOUNDARY: If it wouldn't be safe on a public GitHub page, it doesn't belong.

**Depth**
- Use variables and secret managers, never literal values
- Check diffs before committing
- Treat personal paths, emails, and names as sensitive in shared contexts

---

## The Guidance

Follow these unless you have good reason not to.

### Capsule: TemporalStability

**Invariant**
Capture what will still be true in six months. Avoid ephemeral details.

**Example**
Good: "Foundation services are single points of failure."
Bad: "We have 47 services" or "Planned for Q3."

**Depth**
- Patterns persist; counts change
- Constraints persist; configurations change
- Principles persist; implementations change
- Test: will this still be true? If not, is it worth the maintenance cost?

---

### Capsule: ShapeNotDetail

**Invariant**
Document conceptual structure, not implementation specifics. Point to details; do not duplicate them.

**Example**
Good: "The auth service aggregates identity data from multiple providers."
Bad: "The /api/auth endpoint returns fields: token, refresh_token, expires_at..."

**Depth**
- Implementation changes; conceptual structure persists
- Duplication creates maintenance burden and divergence risk
- Skills and docs are maps; codebases contain the territory

---

### Capsule: WhyNotWhat

**Invariant**
Capture why things work this way. The what becomes obvious once you understand why.

**Example**
Good: "Multi-tenant security requires tenant filtering because one deployment serves all customers."
Bad: "Add .Where(x => x.TenantId == tenantId) to queries."

**Depth**
- Why teaches principles; what teaches steps
- Principles transfer to new situations; steps do not
- Understanding why enables better decisions than knowing what

---

### Capsule: PatternsNotInstances

**Invariant**
Document patterns, not exhaustive lists. Lists rot; patterns endure.

**Example**
Good: "Background services use event-driven processing via message queues."
Bad: "ServiceA listens to EventCreated, UserRegistered, EmailSent..."

**Depth**
- Patterns are stable; instance lists go stale immediately
- A pattern teaches recognition; a list teaches memorization
- When you need a list, put it in reference material that gets maintained

---

## The Values

### Capsule: BridgingSilos

**Invariant**
Connect knowledge across professional boundaries. Skills should be usable by anyone, not just their original author's domain.

**Example**
An infrastructure skill should explain enough context that a frontend developer can deploy an app. A code review skill should be useful regardless of language.

**Depth**
- Traditional silos: each profession knows their domain, not others
- Opportunity cost: decisions made without full context
- An agent with cross-domain knowledge can reason across boundaries

---

### Capsule: TrailsNotDestinations

**Invariant**
Point to detailed information; do not duplicate it. This is a map, not a transcript.

**Example**
Good: "For deployment flow details, see the home-ops-deployer skill"
Bad: Copying the deployment flow into every skill that mentions deployment

**Depth**
- Duplication creates two sources of truth that diverge
- Maintenance burden grows with duplication
- The map shows where things are; the territory contains the details

---

### Capsule: NonObviousTruths

**Invariant**
Capture what surprises people, wastes time when misunderstood, or explains why things are the way they are.

**Example**
- Git hooks can't be shared via git itself (they live in .git/hooks, not tracked)
- Context window compaction loses session state (hence the session journal hook)
- Skills are discovered by their `description` field, not their content

**Depth**
- Obvious truths do not need documentation
- Non-obvious truths burn people who do not know them
- Document the gotchas, not the basics

---

## Hierarchy

1. **Hard Rules** — never violate
2. **Guidance** — follow unless you have good reason
3. **Values** — understand why we make these choices

The test: can someone adopt this config and make good decisions without asking the original author?

---

## Failure Modes

- **False confidence** — wrong information in skills leading to bad agent behavior
- **Maintenance burden** — information that rots faster than it's updated
- **Duplication divergence** — copies in skills and docs that contradict each other
- **Over-engineering** — complexity that serves hypothetical futures, not current needs
