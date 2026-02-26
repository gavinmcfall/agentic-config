# Decision Entry Template

Copy this template for each new decision.

---

```markdown
# NNN: Decision Title (imperative form)

## Metadata

- **domain**: [engine | language | genre | art | audio | tools | architecture | learning | scope | infrastructure]
- **status**: [decided | exploring | superseded]
- **confidence**: [high | medium | low]
- **supersedes**: [NNN (if applicable)]
- **superseded_by**: [NNN (if applicable)]

## Context

What situation prompted this decision? What problem are we solving?

[2-4 sentences. Be specific about what triggered the need to decide.]

## Decision

[One clear sentence stating what was decided.]

## Rationale

Why this option over the alternatives?

[Focus on the deciding factors. What tipped the balance?]

## Alternatives Considered

### [Alternative 1]
- **Pros**: ...
- **Cons**: ...
- **Why not**: [Specific reason this was rejected]

### [Alternative 2]
- **Pros**: ...
- **Cons**: ...
- **Why not**: [Specific reason this was rejected]

## Consequences

### Enables
- [What becomes possible because of this decision]

### Constrains
- [What this decision rules out or makes harder]

## Revisit Trigger

Reopen this decision if:
- [Specific, observable condition 1]
- [Specific, observable condition 2]

If none of these conditions are met, the decision stands.

## Evidence

- [Link to research document, benchmark, prototype, or external source]
- [Confidence: code | docs | synthesis | user | intuition]
```

---

## Good vs Bad Entries

### Good revisit trigger
> "Revisit if Godot 4's 3D performance cannot achieve 60fps with 10,000 on-screen entities on mid-range hardware, verified by prototype."

### Bad revisit trigger
> "Revisit if Godot doesn't feel right anymore."

### Good rationale
> "GDScript has lower learning barrier than C++ and the project doesn't need the performance ceiling. boot.dev offers GDScript courses. The community is active and growing."

### Bad rationale
> "It seemed like the best option."

### Good confidence label
> `confidence: medium` — "Compared 3 engines against my requirements. Did not prototype in all 3. Decision based on docs, community feedback, and one tutorial."

### Bad confidence label
> `confidence: high` — (but you only read one blog post)
