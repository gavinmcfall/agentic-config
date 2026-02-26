# Service Inventory

Full list of deployed services by namespace. Use this to check what exists before suggesting deployments.

---

## actions-runner-system

| Service | Purpose |
|---------|---------|
| actions-runner-controller | GitHub Actions self-hosted runner controller |
| home-ops-runner | Runner scale set for home-ops repo |

## database

| Service | Purpose |
|---------|---------|
| cloudnative-pg | PostgreSQL operator |
| postgres18-cluster | General-purpose PostgreSQL (3 replicas) |
| postgres18-immich | Immich-dedicated PostgreSQL (3 replicas) |
| mariadb | MariaDB instance |
| dragonfly | Redis-compatible (6 replicas, Dragonfly operator) |
| mosquitto | MQTT broker |

## downloads

| Service | Purpose |
|---------|---------|
| autobrr | IRC/announce automation |
| bazarr, bazarr-foreign, bazarr-uhd | Subtitle management |
| cross-seed | Cross-seeding automation |
| dashbrr | Dashboard for arr stack |
| flaresolverr | Cloudflare challenge solver |
| kapowarr | Comic management |
| metube | YouTube downloader |
| prowlarr | Indexer management |
| qbittorrent | BitTorrent client |
| qui | qBittorrent web UI |
| radarr, radarr-uhd | Movie management |
| readarr | Book management |
| recyclarr | TRaSH guide sync |
| sabnzbd | Usenet client |
| sonarr, sonarr-foreign, sonarr-uhd | TV management |
| tqm | Torrent queue manager |
| unpackerr | Archive extraction |

## entertainment

| Service | Purpose |
|---------|---------|
| audiobookshelf | Audiobook server |
| calibre-web | Ebook server |
| fileflows | Media file processing |
| immich | Photo management |
| kavita | Comic/manga reader |
| kometa | Plex metadata manager |
| overseerr | Media request manager |
| pasta | Pastebin |
| plex | Media server |
| plex-auto-languages | Automatic language selection |
| plex-image-cleanup | Cache cleanup |
| tautulli | Plex analytics |
| wizarr | Plex invitation manager |

## games

| Service | Purpose |
|---------|---------|
| pelican | Game server panel |
| pelican-dev | Dev game server panel |
| romm | ROM manager |

## home

| Service | Purpose |
|---------|---------|
| atuin | Shell history sync |
| bentopdf | PDF tools (OIDC-protected) |
| bookstack | Wiki/documentation |
| filebrowser | Web file manager |
| homepage | Dashboard |
| linkwarden | Bookmark manager |
| manyfold | 3D model organizer |
| paperless, paperless-ai, paperless-gpt | Document management |
| searxng | Metasearch engine |
| smtp-relay | Email relay |
| thelounge | IRC client |

## home-automation

| Service | Purpose |
|---------|---------|
| home-assistant | Home automation hub |
| n8n | Workflow automation |
| teslamate | Tesla data logger |

## network

| Service | Purpose |
|---------|---------|
| cloudflare-ddns | Dynamic DNS |
| cloudflared | Cloudflare tunnel |
| echo-server | Network testing |
| envoy-gateway | Gateway API controller |
| external-dns | Cloudflare DNS management |
| external-dns-unifi | UDM Pro DNS management |
| tailscale | VPN mesh |

## observability

| Service | Purpose |
|---------|---------|
| blackbox-exporter | Endpoint probing |
| discord-message-scheduler | Scheduled Discord messages |
| gatus | Uptime monitoring |
| grafana | Dashboards and visualization |
| keda | Event-driven autoscaling |
| kromgo | Status badges |
| kube-prometheus-stack | Prometheus + Alertmanager |
| kube-state-metrics | Kubernetes metrics |
| loki | Log aggregation |
| network-ups-tools | UPS monitoring |
| notifiarr | Notification routing |
| ntfy | Push notifications |
| ntfy-alertmanager | Alert-to-ntfy bridge |
| redisinsight | Redis GUI |
| Various exporters | snmp, speedtest, tautulli, plex, nut, unpoller, graphite |

## plane

| Service | Purpose |
|---------|---------|
| plane | Project management (API, admin, web, workers, live, RabbitMQ) |

## security

| Service | Purpose |
|---------|---------|
| pocket-id | OIDC identity provider |

## storage

| Service | Purpose |
|---------|---------|
| kopia | Backup repository server |
| minio-console | S3-compatible object storage UI |
| snapshot-controller | CSI snapshot management |
| syncthing | File synchronization |
| volsync | PVC replication and backup |
