---
name: home-ops-deployer
description: Deploy and manage applications in the home-ops Kubernetes cluster via GitOps. Use when deploying new apps, modifying existing ones, adding routing, managing secrets, or working with the home-ops repo structure.
zones: { knowledge: 50, process: 25, constraint: 20, wisdom: 5 }
---

# home-ops-deployer

Everything reaches the cluster through Git. Flux reconciles. Manual changes revert.

---

## Hard Constraints

- Never `kubectl apply`. Commit to `~/home-ops`, push, Flux deploys.
- Never run `task configure`. It is for initial bootstrap only. Edit both the template AND the generated output file manually.
- Never commit unencrypted secrets. SOPS-encrypt or use ExternalSecrets.
- Always pin images with digest: `tag@sha256:digest`. Use `crane digest` to fetch.
- Always use `bjw-s/app-template` chart unless a vendor chart is required (infrastructure components).

---

## Mental Model

```
You edit files in ~/home-ops → push to GitHub → Flux detects (≤30min or webhook)
→ Flux applies to cluster → cluster converges to match Git
```

Two kinds of files:
- **Templates** (`bootstrap/templates/*.yaml.j2`) — Jinja2 source, uses `#{var}#` syntax
- **Generated/Direct** (`kubernetes/apps/**/*.yaml`) — what Flux actually reads

If a template exists for a file, edit BOTH the template AND the generated file. If no template exists, edit the generated file directly.

---

## App Structure

```
kubernetes/apps/<namespace>/<app>/
├── ks.yaml                    # Flux Kustomization
└── app/
    ├── helmrelease.yaml       # HelmRelease (app-template)
    ├── kustomization.yaml     # Lists resources for Kustomize
    └── secret.sops.yaml       # Encrypted secrets (optional)
```

Wire into namespace: add `./myapp/ks.yaml` to `kubernetes/apps/<namespace>/kustomization.yaml`.

---

## Common Mistakes

These are the values Claude hallucinates. Use the correct ones.

| Pattern | Correct | Wrong |
|---------|---------|-------|
| Secret store | `onepassword-connect` | `onepassword`, `1password` |
| Block storage | `ceph-block` | `ceph-block-storage` |
| Filesystem storage | `ceph-filesystem` | `cephfs` |
| Hostname | `{{ .Release.Name }}.${SECRET_DOMAIN}` | `appname.${SECRET_DOMAIN}` |
| Timezone | `${TIMEZONE}` | `Pacific/Auckland` |
| Gateway name | `internal` or `external` | `envoy-internal`, `envoy-external` |
| Gateway namespace | `network` | `default`, `networking` |
| Gateway section | `https` | `http` |
| Default UID/GID | `568` | `1000` |
| Image tag | `v1.0@sha256:abc...` | `latest`, `v1.0` |
| Makejinja var | `#{variable}#` | `{{variable}}` |

---

## Deployment Process

See `references/deploy-app.md` for the full step-by-step process.

Quick summary:
1. Create directory structure under `kubernetes/apps/<namespace>/<app>/`
2. Write `helmrelease.yaml` using app-template pattern
3. Add routing (Gateway API and/or Tailscale)
4. Add secrets (SOPS or ExternalSecret)
5. Write `kustomization.yaml` listing all resources
6. Write `ks.yaml` (Flux Kustomization)
7. Wire into namespace `kustomization.yaml`
8. Validate with `task kubernetes:kubeconform`
9. Commit and push

---

## Routing Quick Reference

### Internal app (LAN only)

```yaml
route:
  app:
    annotations:
      internal-dns.alpha.kubernetes.io/target: internal.${SECRET_DOMAIN}
    hostnames:
      - "{{ .Release.Name }}.${SECRET_DOMAIN}"
    parentRefs:
      - name: internal
        namespace: network
        sectionName: https
```

### External app (internet)

```yaml
route:
  app:
    annotations:
      external-dns.alpha.kubernetes.io/target: external.${SECRET_DOMAIN}
    hostnames:
      - "{{ .Release.Name }}.${SECRET_DOMAIN}"
    parentRefs:
      - name: external
        namespace: network
        sectionName: https
```

### Dual-homed (both)

Two route entries: one with `external` parentRef and external annotation, one with `internal` parentRef and internal annotation. Same hostname.

### Tailscale (VPN access)

```yaml
ingress:
  tailscale:
    enabled: true
    className: tailscale
    hosts:
      - host: "{{ .Release.Name }}"
```

---

## Persistence

### Inline PVC (app-template creates it)

```yaml
persistence:
  data:
    type: persistentVolumeClaim
    accessMode: ReadWriteOnce
    size: 5Gi
    storageClass: ceph-block
    globalMounts:
      - path: /data
```

### Existing PVC (pre-created or VolSync-managed)

```yaml
persistence:
  data:
    existingClaim: myapp
    globalMounts:
      - path: /data
```

### Writable temp directories (when `readOnlyRootFilesystem: true`)

```yaml
persistence:
  tmp:
    type: emptyDir
    globalMounts:
      - path: /tmp
```

---

## Security Context Pattern

```yaml
defaultPodOptions:
  securityContext:
    runAsNonRoot: true
    runAsUser: 568
    runAsGroup: 568
    fsGroup: 568
    fsGroupChangePolicy: OnRootMismatch
    supplementalGroups: [10000]
    seccompProfile: { type: RuntimeDefault }

containers:
  app:
    securityContext:
      allowPrivilegeEscalation: false
      readOnlyRootFilesystem: true
      capabilities: { drop: ["ALL"] }
```

**Note**: UID/GID 568 is the default. Some images require a different UID — verify against the container's expected user. If the app writes to paths outside mounted volumes, add `emptyDir` mounts for `/tmp`, `/cache`, etc.

---

## Image Pinning

```bash
# Find latest tag
crane ls <registry>/<image>

# Verify against official releases
gh release list --repo <owner>/<repo> --limit 10

# Get digest
crane digest <registry>/<image>:<tag>
```

Result:
```yaml
image:
  repository: ghcr.io/org/app
  tag: v1.0.0@sha256:abc123...
```

---

## Secrets

### ExternalSecret (from 1Password)

```yaml
apiVersion: external-secrets.io/v1beta1
kind: ExternalSecret
metadata:
  name: myapp-secret
spec:
  secretStoreRef:
    kind: ClusterSecretStore
    name: onepassword-connect
  target:
    name: myapp-secret
  data:
    - secretKey: API_KEY
      remoteRef:
        key: myapp
        property: api_key
```

### SOPS (encrypted in Git)

Create `secret.sops.yaml`, encrypt with `sops --encrypt --in-place <file>`.

### Wire secrets into the container

After creating the secret (either method), reference it in the HelmRelease container spec:

```yaml
containers:
  app:
    envFrom:
      - secretRef:
          name: myapp-secret
```

**Verification**: If you created a secret but the app can't see its values, check that `envFrom` or `env.valueFrom` exists in the container spec.

---

## Deeper

- `references/deploy-app.md` — Full deployment process with verification
- `~/home-ops/docs/ai-context/ARCHITECTURE.md` — GitOps architecture
- `~/home-ops/docs/ai-context/CONVENTIONS.md` — Full conventions and common mistakes
- `~/home-ops/docs/ai-context/WORKFLOWS.md` — Operational workflows
- `~/home-ops/docs/ai-context/NETWORKING.md` — Traffic flows, DNS, OIDC

---

## Namespaces

| Namespace | Purpose |
|-----------|---------|
| database | PostgreSQL, MariaDB, Dragonfly, Mosquitto |
| downloads | Media acquisition (arr stack, qbittorrent, sabnzbd) |
| entertainment | Media serving (plex, immich, audiobookshelf) |
| games | Gaming (pelican, romm) |
| home | Utilities (homepage, bookstack, paperless, searxng) |
| home-automation | IoT (home-assistant, n8n) |
| network | Gateways, DNS, cloudflared, tailscale |
| observability | Prometheus, grafana, loki, alerting |
| plane | Project management |
| security | Authentication (pocket-id) |
| storage | Backups (kopia, volsync, syncthing, minio) |

---

## Commit Convention

```
type(scope): description

Pair-programmed with Claude Code - https://claude.com/claude-code

Co-Authored-By: Claude <noreply@anthropic.com>
Co-Authored-By: the user <your-email@example.com>
```

Types: `feat`, `fix`, `chore`, `docs`, `refactor`

---

*All changes through Git. Flux is the authority.*
