# Kill Chain

The sequence is load-bearing. Each phase feeds the next. Skipping phases means missing vulnerabilities that only become visible through systematic progression.

---

## Phase 1: Reconnaissance

**Goal**: Understand the target before touching it.

### Passive Recon (no direct interaction)

- **Code analysis**: Read source, configs, READMEs, CI/CD pipelines, Dockerfiles
- **Dependency tree**: Package manifests, lock files, version constraints
- **Git history**: Secrets in old commits, removed features, author patterns
- **Documentation**: API docs, architecture diagrams, deployment guides
- **Public exposure**: DNS records, certificate transparency, Shodan/Censys data
- **Error messages**: Stack traces, debug output, verbose error responses

### Active Recon (direct interaction)

- **Service fingerprinting**: Technology detection, version identification
- **Endpoint enumeration**: Crawl, brute-force common paths, API discovery
- **Authentication probing**: Login flows, password reset, registration
- **Header analysis**: Security headers, server identification, framework leaks

### Recon Output

Document:
- Technology stack (languages, frameworks, databases, infrastructure)
- Attack surface inventory (every interface, endpoint, input)
- Authentication and authorization model
- Data flow (what data enters, where it's processed, where it's stored)
- Initial hypotheses about where the weak points are

---

## Phase 2: Enumeration

**Goal**: Map every potential entry point in detail.

For each attack surface identified in recon:
- What inputs does it accept?
- What validation exists?
- What happens with malformed input?
- What error information is disclosed?
- What authentication/authorization is required?
- What are the trust boundaries?

### Enumeration Techniques

| Surface | Enumeration Method |
|---------|--------------------|
| Web endpoints | Parameter fuzzing, method testing (GET/POST/PUT/DELETE/PATCH/OPTIONS) |
| Authentication | Credential stuffing, token analysis, session management |
| APIs | Schema discovery, parameter manipulation, rate limit testing |
| File system | Path traversal probing, file upload testing, symlink following |
| Dependencies | CVE database lookup, known exploit search |
| Infrastructure | Port scanning, service version detection, configuration review |
| Secrets | Pattern scanning (regex for keys, tokens, passwords), entropy analysis |

---

## Phase 3: Exploitation

**Goal**: Prove vulnerabilities are real by exploiting them.

### Rules of Exploitation

1. **Prove, don't theorize** — A vulnerability is real when you exploit it
2. **Minimum viable exploit** — Demonstrate impact with the least destructive method
3. **Document everything** — Request, response, steps to reproduce
4. **No destruction** — Read access proves the point. Don't modify or delete.
5. **Stop at proof** — Once you've proven access, stop. Don't explore further than needed.

### Exploitation Priorities

Test in this order — highest impact first:

1. **Remote Code Execution (RCE)** — Can you execute arbitrary code?
2. **Authentication bypass** — Can you access without credentials?
3. **Authorization bypass** — Can you access other users' data?
4. **Data exposure** — Can you read sensitive data?
5. **Injection** — Can you inject commands, queries, templates?
6. **Denial of Service** — Can you disrupt availability? (test carefully, observe `guardrails.md`)

### For Each Vulnerability Found

Record:
- **What**: The vulnerability class (e.g., SQL injection, SSRF)
- **Where**: Exact location (endpoint, file:line, parameter)
- **How**: Step-by-step reproduction
- **Proof**: Request/response, screenshot, or output
- **Impact**: What an attacker gains

---

## Phase 4: Escalation

**Goal**: Chain findings to demonstrate maximum impact.

Individual vulnerabilities tell a story. Chains tell the real story.

### Chain Discovery

1. List all confirmed vulnerabilities
2. For each, ask: "What does this give me access to?"
3. For each access gained, ask: "What new attacks does this enable?"
4. Map the chains: Vuln A → Access B → Vuln C → Full Compromise

### Common Chains

| Chain | Pattern |
|-------|---------|
| SSRF → Cloud metadata → Credentials → Account takeover | Network → Cloud → IAM |
| XSS → Session theft → Admin access → RCE | Client → Auth → Server |
| SQL injection → Data dump → Password reuse → Admin login | Data → Auth → Privilege |
| Dependency vuln → RCE → Container escape → Host access | Supply chain → Infra |
| Config leak → API keys → Third-party access → Data exfil | Secrets → Lateral |

### Escalation Output

For each chain:
- Starting point (initial vulnerability)
- Each step with proof
- Final impact (what the attacker achieves)
- Aggregate severity (usually higher than any individual finding)

---

## Phase 5: Reporting

**Goal**: Deliver actionable findings that drive remediation.

See `report-format.md` for the full template.

Key principles:
- Structure for the audience (executives get summary, engineers get proof)
- Severity reflects real-world impact, not theoretical risk
- Remediation is specific and actionable
- Attack chains are highlighted — they change the severity picture
- Prioritization considers both severity and effort

---

*Recon tells you where to look. Enumeration tells you what to try. Exploitation proves it's real. Escalation shows why it matters.*
