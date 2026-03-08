# Report Format

The report is a findings document. Invoke `writing-documents` with document type `findings` before writing.

The report serves two audiences: humans who need to understand the risk, and agents who need to process findings into remediation tasks.

---

## Structure

```markdown
# Red Team Assessment: [Target Name]

**Date**: [YYYY-MM-DD]
**Scope**: [What was tested]
**Duration**: [Assessment duration]
**Assessor**: Claude Code — Red Team Skill

---

## Executive Summary

**Overall Risk**: [CRITICAL / HIGH / MEDIUM / LOW]

[2-3 sentences: What was tested. What was found. What's the worst-case scenario if nothing is fixed.]

### Severity Distribution

| Severity | Count |
|----------|-------|
| Critical | N |
| High | N |
| Medium | N |
| Low | N |
| Info | N |

### Top 3 Findings

1. [One-line summary of most critical finding]
2. [One-line summary of second most critical]
3. [One-line summary of third most critical]

---

## Attack Chains

[Multi-step exploitation paths — these often change the severity picture]

### Chain: [Name — e.g., "Metadata to Account Takeover"]

**Aggregate Severity**: [Usually higher than individual findings]

1. **[Finding Reference]** — [What this step achieves]
2. **[Finding Reference]** — [What this step achieves]
3. **[Finding Reference]** — [Final impact]

**Impact**: [What an attacker achieves through this chain]
**Likelihood**: [How practical is this chain in the real world]

---

## Findings

### [F-001] [Finding Title]

| Field | Value |
|-------|-------|
| **Severity** | CRITICAL / HIGH / MEDIUM / LOW / INFO |
| **Surface** | auth / injection / secrets / dependencies / config / infrastructure / data / api |
| **Location** | [File:line, endpoint, or resource] |
| **CWE** | [CWE ID if applicable] |
| **CVSS** | [Score if applicable] |

**Description**

[What the vulnerability is. 1-3 sentences.]

**Proof of Concept**

```
[Exact request/response, command/output, or code demonstrating the vulnerability]
```

**Impact**

[What an attacker gains. Be specific — "read all user records" not "data exposure".]

**Remediation**

[Specific, actionable fix. Code examples where possible.]

```
[Before/after code if applicable]
```

**References**

- [Links to relevant documentation, CVE entries, or OWASP references]

---

[Repeat for each finding, numbered sequentially: F-001, F-002, ...]

---

## Defenses Confirmed

[What worked. What attacks failed. This is valuable — it tells defenders what to keep.]

| Defense | What It Prevented |
|---------|-------------------|
| [Defense mechanism] | [Attack class it stopped] |

---

## Gaps and Limitations

[What couldn't be tested and why]

- [Gap 1 — reason]
- [Gap 2 — reason]

---

## Prioritized Recommendations

[Ordered by: severity × effort. Fix the critical-easy items first.]

| Priority | Finding | Effort | Action |
|----------|---------|--------|--------|
| 1 | F-XXX | [Low/Med/High] | [One-line action] |
| 2 | F-XXX | [Low/Med/High] | [One-line action] |
| ... | ... | ... | ... |

---

## Methodology

[Brief description of approach: tools used, surfaces tested, time spent per phase]

### Tools Used

| Tool | Purpose |
|------|---------|
| [Tool] | [What it was used for] |

### Phases

| Phase | Duration | Focus |
|-------|----------|-------|
| Recon | [Time] | [What was examined] |
| Enumeration | [Time] | [What was mapped] |
| Exploitation | [Time] | [What was attacked] |
| Reporting | [Time] | [Synthesis] |
```

---

## Severity Definitions (for the report)

| Severity | Definition | SLA Expectation |
|----------|-----------|----------------|
| **Critical** | Actively exploitable, immediate impact, no authentication required or trivially bypassed | Fix within 24 hours |
| **High** | Exploitable with minimal skill, significant data or access impact | Fix within 7 days |
| **Medium** | Exploitable with specific conditions, limited blast radius | Fix within 30 days |
| **Low** | Minor impact, difficult to exploit, or defense-in-depth issue | Fix within 90 days |
| **Info** | No direct security impact, hygiene issue, or documentation | Address when convenient |

---

## Machine-Parseable Conventions

To enable remediation agents to process findings:

- Finding IDs follow `F-NNN` format
- Severity is one of: `CRITICAL`, `HIGH`, `MEDIUM`, `LOW`, `INFO`
- Surface is one of: `auth`, `injection`, `secrets`, `dependencies`, `config`, `infrastructure`, `data`, `api`
- Location uses `file:line` for code, full URL for endpoints, resource identifier for infrastructure
- CWE IDs enable automated classification
- Remediation includes concrete code changes where applicable

---

*The report is the deliverable. Make it count.*
