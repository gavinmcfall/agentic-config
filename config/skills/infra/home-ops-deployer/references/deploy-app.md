# Deploying a New App

Process where order matters. Each step depends on the previous.

---

## Prerequisites

- [ ] Working directory is `~/home-ops`
- [ ] `kubeconfig` exists and cluster is reachable
- [ ] Know: app name, namespace, image repository, image tag+digest, port, storage needs, exposure (internal/external/tailscale)

---

## Steps

### 1. Choose namespace

Check existing namespaces in `kubernetes/apps/`. Use an existing namespace that matches the app's purpose. Creating a new namespace requires additional Flux wiring.

→ Verify: `ls kubernetes/apps/` shows your target namespace

### 2. Create directory structure

```
kubernetes/apps/<namespace>/<app>/
├── ks.yaml
└── app/
    ├── helmrelease.yaml
    ├── kustomization.yaml
    └── externalsecret.yaml   (if needed)
    └── secret.sops.yaml      (if needed)
```

→ Verify: directories exist

### 3. Write `helmrelease.yaml`

Start from an existing app in the same namespace as a reference. Key elements:

```yaml
apiVersion: helm.toolkit.fluxcd.io/v2
kind: HelmRelease
metadata:
  name: &app myapp
spec:
  interval: 30m
  chart:
    spec:
      chart: app-template
      version: 4.4.0    # Check current version: grep 'version:' kubernetes/apps/home/*/app/helmrelease.yaml | head -1
      sourceRef:
        kind: HelmRepository
        name: bjw-s
        namespace: flux-system
  install:
    remediation:
      retries: 3
  upgrade:
    cleanupOnFail: true
    remediation:
      strategy: rollback
      retries: 3
  values:
    controllers:
      myapp:
        containers:
          app:
            image:
              repository: ghcr.io/org/myapp
              tag: v1.0.0@sha256:...    # Always pin with digest
            env:
              TZ: ${TIMEZONE}
            probes:
              liveness:
                spec:
                  httpGet:
                    path: /health        # Check app docs for correct path
                    port: &port 8080
            securityContext:
              allowPrivilegeEscalation: false
              readOnlyRootFilesystem: true
              capabilities: { drop: ["ALL"] }
    defaultPodOptions:
      securityContext:
        runAsNonRoot: true
        runAsUser: 568
        runAsGroup: 568
        fsGroup: 568
        fsGroupChangePolicy: OnRootMismatch
        seccompProfile: { type: RuntimeDefault }
    service:
      app:
        controller: myapp
        ports:
          http:
            port: *port
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
    persistence:
      config:
        existingClaim: myapp
        globalMounts:
          - path: /config
```

→ Verify: YAML is valid, image tag has digest, correct gateway and annotation

### 4. Write `kustomization.yaml`

```yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resources:
  - helmrelease.yaml
  # - externalsecret.yaml   (if applicable)
  # - secret.sops.yaml      (if applicable)
```

→ Verify: every file in `app/` is listed

### 5. Write `ks.yaml`

```yaml
apiVersion: kustomize.toolkit.fluxcd.io/v1
kind: Kustomization
metadata:
  name: &app myapp
  namespace: flux-system
spec:
  targetNamespace: <namespace>
  commonMetadata:
    labels:
      app.kubernetes.io/name: *app
  path: ./kubernetes/apps/<namespace>/myapp/app
  prune: true
  sourceRef:
    kind: GitRepository
    name: flux-system
  wait: false
  interval: 30m
  retryInterval: 1m
  timeout: 5m
  postBuild:
    substitute: {}
    substituteFrom:
      - kind: ConfigMap
        name: cluster-settings
      - kind: Secret
        name: cluster-secrets
```

→ Verify: `targetNamespace` matches, `path` is correct

### 6. Wire into namespace kustomization

Edit `kubernetes/apps/<namespace>/kustomization.yaml`:

```yaml
resources:
  - ./existingapp/ks.yaml
  - ./myapp/ks.yaml          # Add this line
```

→ Verify: alphabetical order, path correct
→ If failed: Flux will not discover the app

### 7. Add secrets (if needed)

**ExternalSecret (1Password)**:
```yaml
apiVersion: external-secrets.io/v1beta1
kind: ExternalSecret
metadata:
  name: myapp-secret
spec:
  secretStoreRef:
    kind: ClusterSecretStore
    name: onepassword-connect    # MUST be this exact name
  target:
    name: myapp-secret
  data:
    - secretKey: KEY_NAME
      remoteRef:
        key: myapp               # 1Password item name
        property: key_name       # 1Password field
```

**SOPS secret**: create `secret.sops.yaml`, encrypt with `sops --encrypt --in-place`.

→ Verify: secret store name is `onepassword-connect`, not `onepassword`

### 8. Validate

```bash
task kubernetes:kubeconform
```

→ Verify: no errors
→ If failed: fix YAML, check chart version, verify structure

### 9. Commit and push

```bash
git add kubernetes/apps/<namespace>/myapp/
git add kubernetes/apps/<namespace>/kustomization.yaml
git commit -m "feat(myapp): initial deployment"
git push
```

→ Verify: `flux get kustomizations` shows the new app
→ Verify: `flux get helmrelease myapp -n <namespace>` shows Ready
→ If failed: `kubectl logs -n flux-system deploy/helm-controller | grep myapp`

---

## Recovery

| Failure | Fix |
|---------|-----|
| HelmRelease stuck Reconciling | Check `flux logs`, verify secrets exist, validate values |
| Pod pending on storage | Create PVC or check rook-ceph health |
| Route not working | Verify gateway exists in `network` namespace, check DNS annotations, check external-dns logs |
| Secret not found | Verify ExternalSecret sync: `kubectl get externalsecrets -n <namespace>` |
| Image pull error | Verify image exists: `crane manifest <image>:<tag>` |

---

## Modifying an Existing App

### If template exists in `bootstrap/templates/`

1. Edit the `.yaml.j2` template
2. Edit the corresponding generated file in `kubernetes/apps/` with the same change
3. Do NOT run `task configure`
4. Validate and commit

### If no template

1. Edit `kubernetes/apps/<namespace>/<app>/app/helmrelease.yaml` directly
2. Validate and commit

---

*Copy from a working app in the same namespace. Adapt, don't invent.*
