# Troubleshooting Workflows

Ordered diagnostic workflows. Start at step 1, follow the path.

---

## App Not Working

### 1. Check Flux status

```bash
flux get hr <name> -n <namespace>
```

| Status | Next Step |
|--------|-----------|
| Ready: True | Flux is fine, go to step 2 |
| Ready: False | Check Flux logs (step 1a) |
| Not found | App not wired into Flux, check `ks.yaml` and namespace `kustomization.yaml` |

### 1a. Flux logs

```bash
kubectl logs -n flux-system deploy/helm-controller | grep <name> | tail -20
```

Common causes: missing secret, invalid chart values, chart version not found.

### 2. Check pod status

```bash
kubectl get pods -n <namespace> -l app.kubernetes.io/name=<app>
```

| Status | Next Step |
|--------|-----------|
| Running | Go to step 3 |
| Pending | Check events: `kubectl describe pod -n <namespace> <pod-name>` — likely storage or scheduling issue |
| CrashLoopBackOff | Check logs: `kubectl logs -n <namespace> <pod-name> --previous` |
| ImagePullBackOff | Verify image exists: `crane manifest <repo>:<tag>` |
| ContainerCreating | Check events — likely missing ConfigMap, Secret, or PVC |

### 3. Check service and route

```bash
# Service exists?
kubectl get svc -n <namespace> -l app.kubernetes.io/name=<app>

# Route exists?
kubectl get httproutes -n <namespace> | grep <app>

# Test from cluster
kubectl run -it --rm debug --image=alpine -- wget -qO- http://<service>.<namespace>.svc:port/health
```

### 4. Check DNS

```bash
# Internal DNS (from UDM)
dig <app>.${SECRET_DOMAIN} @10.90.254.1

# External DNS (from Cloudflare)
dig <app>.${SECRET_DOMAIN} @1.1.1.1

# Check external-dns logs
kubectl logs -n network -l app.kubernetes.io/name=external-dns | grep <app>
kubectl logs -n network -l app.kubernetes.io/name=external-dns-unifi | grep <app>
```

---

## Storage Issues

### PVC Pending

```bash
kubectl get pvc -n <namespace>
kubectl describe pvc <name> -n <namespace>
```

| Cause | Fix |
|-------|-----|
| No matching StorageClass | Use `ceph-block` or `ceph-filesystem` |
| Ceph unhealthy | Check Ceph status (below) |
| Node affinity (openebs-hostpath) | Pod must schedule to the node with local storage |

### Ceph Health

```bash
kubectl -n rook-ceph exec deploy/rook-ceph-tools -- ceph status
kubectl -n rook-ceph exec deploy/rook-ceph-tools -- ceph osd status
kubectl -n rook-ceph exec deploy/rook-ceph-tools -- ceph health detail
```

| Status | Severity |
|--------|----------|
| HEALTH_OK | Fine |
| HEALTH_WARN | Monitor, usually self-resolving |
| HEALTH_ERR | Investigate — check `ceph health detail` for specifics |

---

## Database Issues

### CloudNative-PG

```bash
# Cluster status
kubectl get clusters.postgresql.cnpg.io -n database

# Pod logs
kubectl logs -n database <cluster-name>-1

# Switchover (if primary is unhealthy)
kubectl cnpg switchover <cluster-name> -n database
```

### Dragonfly

```bash
kubectl get dragonfly -n database
kubectl logs -n database -l app=dragonfly
```

---

## Network Issues

### Spawn debug pod

```bash
task kubernetes:network ns=<namespace>
# Or manually:
kubectl run -it --rm netshoot --image=nicolaka/netshoot -n <namespace> -- /bin/bash
```

### Check gateway health

```bash
kubectl get gateways -n network
kubectl get httproutes -A
kubectl logs -n network -l gateway.envoyproxy.io/owning-gateway-name=internal | tail -20
kubectl logs -n network -l gateway.envoyproxy.io/owning-gateway-name=external | tail -20
```

### Cilium status

```bash
kubectl get ciliumendpoints -n <namespace>
kubectl -n kube-system exec ds/cilium -- cilium status
```

---

## Node Issues (Talos)

```bash
# Node health
talosctl --nodes <ip> health

# System services
talosctl --nodes <ip> services

# Kernel messages
talosctl --nodes <ip> dmesg | tail -50

# Kubelet logs
talosctl --nodes <ip> logs kubelet | tail -50

# Disk usage
talosctl --nodes <ip> usage /var
```

---

## Flux Stuck

```bash
# Force full reconciliation
task flux:reconcile

# Restart failed HelmReleases
task flux:hr-restart

# Check source controller
kubectl logs -n flux-system deploy/source-controller | tail -20

# Nuclear option: suspend and resume
flux suspend hr <name> -n <namespace>
flux resume hr <name> -n <namespace>
```

---

*Diagnose from the top down: Flux → Pod → Service → Route → DNS.*
