# Registrar TLD Coverage

Detailed TLD support across Cloudflare, Namecheap, and CrazyDomains. Data sourced February 2026.

---

## Coverage Summary

| Registrar | Total TLDs | Strengths | Key Limitation |
|-----------|-----------|-----------|----------------|
| Cloudflare | ~422 | At-cost pricing, no markup | No .au, .de, .fr, .eu, .jp |
| Namecheap | ~567 | Broadest catalog, free WHOIS | Some ccTLD operational quirks |
| CrazyDomains | ~485 | Best AU/NZ support | Premium DNS paywall for TXT/SRV |

---

## Popular TLD Availability Matrix

| TLD | Cloudflare | Namecheap | CrazyDomains | Notes |
|-----|:---:|:---:|:---:|-------|
| .com | Y | Y | Y | |
| .net | Y | Y | Y | |
| .org | Y | Y | Y | |
| .io | Y | Y | Y | Popular tech/startup |
| .ai | Y | Y | Y | Popular AI companies |
| .dev | Y | Y | Y | Requires HTTPS |
| .app | Y | Y | Y | Requires HTTPS |
| .co | Y | Y | Y | |
| .me | Y | Y | Y | |
| .tv | Y | Y | Y | |
| .xyz | Y | Y | Y | |
| .shop | Y | Y | Y | |
| .tech | Y | Y | Y | |
| .cloud | Y | Y | Y | |
| .design | Y | Y | Y | |
| .store | Y | Y | Y | |
| .blog | Y | Y | Y | |
| .online | Y | Y | Y | |
| .site | Y | Y | Y | |

## Country-Code TLD Coverage

| TLD | Cloudflare | Namecheap | CrazyDomains | Notes |
|-----|:---:|:---:|:---:|-------|
| .au / .com.au | **N** | Y | Y | CrazyDomains is auDA-accredited; requires ABN/ACN |
| .nz / .co.nz | Y | Y | Y | All three support full NZ set |
| .uk / .co.uk | Y | Y | Y | |
| .ca | Y | Y | Y | Requires Canadian connection |
| .de | **N** | Y | Y | Germany |
| .fr | **N** | Y | Y | France |
| .eu | **N** | Y | Y | EU presence required |
| .nl | **N** | Y | Y | Netherlands |
| .it | **N** | Y | Y | Italy |
| .es | **N** | Y | Y | Spain |
| .jp | **N** | Limited | Limited | Japan; restrictive |
| .cn | **N** | Limited | Y | China; restrictive |
| .in | **N** | Y | Y | India |
| .us | Y | Y | Y | US nexus required; no WHOIS privacy |
| .mx | Y | Y | Y | Mexico |

---

## Australian Domain Requirements (.au namespace)

Handled best by CrazyDomains (auDA-accredited).

| TLD | Eligibility | Min Term |
|-----|------------|----------|
| .com.au | ABN, ACN, or AU trademark | 1 year |
| .net.au | Same as .com.au | 1 year |
| .org.au | Non-profit, incorporated association | 1 year |
| .id.au | AU citizen, resident, or permanent resident | 1 year |
| .asn.au | Clubs, associations | 1 year |
| .au (direct) | Eligible for .com.au or .id.au | 1 year |

WHOIS privacy is **not available** for any .au domain (auDA policy, all registrars).

---

## New Zealand Domain Coverage

All three registrars support the core NZ set:

| TLD | Notes |
|-----|-------|
| .co.nz | Commercial (most common) |
| .net.nz | Network operators |
| .org.nz | Organisations |
| .nz | Direct registration |
| .geek.nz | Tech/computing |

CrazyDomains additionally supports: .gen.nz, .kiwi.nz, .maori.nz, .ac.nz, .school.nz

---

## Cloudflare-Specific Notes

- **At-cost pricing**: Registry wholesale price + ICANN fee. No registrar margin. Cheapest option for supported TLDs.
- **Requires Cloudflare DNS**: Must use Cloudflare as authoritative nameserver. Cannot use external DNS.
- **No IDN support**: Internationalized domain names not supported.
- **422 TLDs**: Strong on gTLDs and new gTLDs. Weak on European and Asian ccTLDs.
- **Canadian provinces**: Supports .ab.ca, .bc.ca, .mb.ca, .on.ca, etc.
- **DNSSEC**: One-click, free.

## Namecheap-Specific Notes

- **567 TLDs**: Broadest catalog of the three.
- **Free WHOIS privacy**: Included at no cost on most TLDs (competitive advantage).
- **Handshake (HNS) domains**: Supports decentralized blockchain TLDs (don't resolve in standard browsers).
- **DNSSEC gaps**: No DNSSEC management for .africa, .barcelona, .cat, .de, .eu, .nl, .com.au, .net.au, .org.au.
- **.fr quirk**: Must renew more than 12 days before expiry.

## CrazyDomains-Specific Notes

- **485 TLDs**: Solid catalog, slightly smaller than competitors.
- **AU/NZ specialist**: auDA-accredited, full .au and .nz support.
- **Premium DNS paywall**: Standard DNS does NOT support TXT or SRV records. Must purchase Premium DNS (~AUD $20/year) for SPF/DKIM/DMARC, Microsoft 365 verification, Google Workspace verification. This is unusual — competitors include TXT records at no cost.
- **WHOIS privacy**: Paid add-on ("Domain Guard"), not included.
- **Workaround for DNS limitation**: Register at CrazyDomains, point nameservers to Cloudflare (free tier), manage DNS at Cloudflare.

---

## Registrar Selection Decision

```
Need .au/.com.au?
  → CrazyDomains (then point NS to Cloudflare for free DNS)

Need .de/.fr/.eu or broad ccTLD coverage?
  → Namecheap

TLD supported by Cloudflare?
  → Cloudflare (cheapest, best DNS)

Unsure or want maximum flexibility?
  → Namecheap (broadest catalog, free WHOIS)
```

---

*When in doubt, check availability first — registrar choice follows from what's available.*
