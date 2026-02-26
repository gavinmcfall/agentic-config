---
name: k8s-operator
description: Query and diagnose the home Kubernetes cluster. Use when checking cluster health, troubleshooting pods/services/routes, inspecting storage, or understanding what's deployed. Covers Talos node management, Ceph storage, Cilium networking.
zones: { knowledge: 60, process: 15, constraint: 15, wisdom: 10 }
---

# k8s-operator

Query before acting. Understand scope, then drill down.

---

## Hard Constraints

- Talos Linux has no SSH. Use `talosctl` for node management.
- Prefer read-only operations. State changes go through GitOps (see `home-ops-deployer` skill).
- Never `kubectl apply` or `kubectl edit` — Flux reverts manual changes.
- Never `kubectl delete` pods to "fix" things — find the root cause.

---

## Cluster: your-cluster

| Node | IP | Roles | OS |
|------|-----|-------|----|
| your-cluster-01 | 10.90.3.101 | control-plane | Talos v1.11.5 |
| your-cluster-02 | 10.90.3.102 | control-plane | Talos v1.11.5 |
| your-cluster-03 | 10.90.3.103 | control-plane | Talos v1.11.5 |

- **Kubernetes**: v1.33.1
- **Container runtime**: containerd 2.1.5
- **CNI**: Cilium (eBPF, BGP, DSR mode)
- **Control plane**: 10.90.3.100:6443 (VIP)

---

## Storage

### Rook-Ceph

3x NVMe OSDs, ~5.2 TiB total capacity.

| Storage Class | Provisioner | Use |
|---------------|-------------|-----|
| `ceph-block` (default) | rook-ceph.rbd.csi.ceph.com | Single-instance apps, databases |
| `ceph-filesystem` | rook-ceph.cephfs.csi.ceph.com | Shared/multi-instance (RWX) |
| `ceph-bucket` | rook-ceph.ceph.rook.io/bucket | S3-compatible object storage |
| `openebs-hostpath` | openebs.io/local | Node-local storage (monitoring, caches) |

### Check Ceph Health

```bash
kubectl -n rook-ceph exec deploy/rook-ceph-tools -- ceph status
kubectl -n rook-ceph exec deploy/rook-ceph-tools -- ceph osd status
kubectl -n rook-ceph exec deploy/rook-ceph-tools -- ceph df
```

---

## Networking

### Load Balancer IPs (Cilium LB-IPAM via BGP)

| IP | Service |
|----|---------|
| 10.99.8.201 | External gateway (public via Cloudflare tunnel) |
| 10.99.8.202 | Internal gateway (LAN direct) |

### Infrastructure

| IP | Device |
|----|--------|
| 10.90.254.1 | UDM Pro (router/DNS/firewall) |
| 10.96.0.10 | CoreDNS (cluster DNS) |

### Key Concepts

- **Split-horizon DNS**: Same hostname resolves differently from LAN vs internet. external-dns manages Cloudflare, external-dns-unifi manages UDM Pro records.
- **DSR mode**: Direct Server Return. Known limitation: same-node hairpin fails. CoreDNS template rewrites internal hostnames to ClusterIP as workaround.
- **BGP**: Cilium advertises LoadBalancer IPs to UDM Pro (ASN 65010 → 65001).

---

## Databases

| Service | Type | Namespace | Notes |
|---------|------|-----------|-------|
| postgres18-cluster | PostgreSQL 18 | database | 3 replicas, CloudNative-PG, pgBackRest backups |
| postgres18-immich | PostgreSQL 18 | database | 3 replicas, dedicated to Immich |
| mariadb | MariaDB | database | Single instance |
| dragonfly | Redis-compatible | database | 6 replicas, Dragonfly operator |
| mosquitto | MQTT | database | Single instance |

---

## Deployed Services by Namespace

See `references/service-inventory.md` for the full list.

Key namespaces for game development context:
- **games**: pelican (game server panel), pelican-dev, romm
- **plane**: project management (Plane)
- **home**: bookstack (wiki), filebrowser, searxng, manyfold (3D models)
- **storage**: minio-console, kopia, syncthing
- **observability**: grafana, prometheus, loki

---

## Talos Management

Talos is immutable. No SSH, no package manager, no shell access on nodes.

```bash
# Node health
talosctl --nodes 10.90.3.101 health
talosctl --nodes 10.90.3.101 get members

# System logs
talosctl --nodes 10.90.3.101 logs kubelet
talosctl --nodes 10.90.3.101 dmesg

# Node config (read-only)
talosctl --nodes 10.90.3.101 get machineconfig

# Apply config changes (use with caution)
talosctl --nodes 10.90.3.101 apply-config --file <config.yaml>

# Upgrade Talos
task talos:upgrade node=your-cluster-01

# Upgrade Kubernetes
task talos:upgrade-k8s
```

---

## Troubleshooting

See `references/troubleshooting.md` for detailed workflows.

### Quick Checks

```bash
# Cluster overview
kubectl get nodes -o wide
kubectl top nodes

# All pods not Running
kubectl get pods -A --field-selector status.phase!=Running

# Recent events
kubectl get events -A --sort-by=.lastTimestamp | tail -20

# Flux status
flux get kustomizations
flux get helmreleases -A | grep -v True

# Specific app
flux get hr <name> -n <namespace>
kubectl logs -n <namespace> -l app.kubernetes.io/name=<app>
kubectl describe pod -n <namespace> -l app.kubernetes.io/name=<app>
```

---

## Taskfile Commands

| Command | Purpose |
|---------|---------|
| `task kubernetes:kubeconform` | Validate YAML schemas |
| `task kubernetes:resources` | List all cluster resources |
| `task kubernetes:sync-secrets` | Force ExternalSecret refresh |
| `task kubernetes:network ns=<ns>` | Debug pod networking (spawns netshoot) |
| `task flux:reconcile` | Force full Flux reconciliation |
| `task flux:hr-restart` | Restart failed HelmReleases |
| `task volsync:snapshot app=<app> ns=<ns>` | Snapshot an app PVC |
| `task volsync:restore app=<app> ns=<ns>` | Restore a PVC from snapshot |
| `task volsync:list ns=<ns>` | List snapshots |

---

## Deeper

- `references/service-inventory.md` — Full list of deployed services
- `references/troubleshooting.md` — Step-by-step diagnostic workflows
- `~/home-ops/docs/ai-context/NETWORKING.md` — Full networking architecture
- `~/home-ops/docs/ai-context/ARCHITECTURE.md` — Backup strategy, operational limits

---

*Understand first. Act through GitOps.*
