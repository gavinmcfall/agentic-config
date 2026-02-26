---
name: domain-expert
description: Find, evaluate, and recommend domain names. Use when brainstorming domains, checking availability, evaluating names for sound/memorability, or choosing between registrars. Knows Cloudflare, Namecheap, and CrazyDomains TLD coverage.
zones:
  knowledge: 50
  wisdom: 25
  process: 15
  constraint: 10
---

# Domain Expert

A good domain name is heard once and typed correctly forever. This skill helps you find one.

## Tools Available

The `instant-domain-search` MCP server provides three tools. **Use ToolSearch to load them before calling.**

| Tool | Input | Use When |
|------|-------|----------|
| `search_domains` | `name` (no TLD), optional `tlds[]`, `limit` (1-100) | Sweeping a name across TLDs |
| `generate_domain_variations` | `name`, optional `sort` (rank\|distance), `limit` | First choice is taken, need alternatives |
| `check_domain_availability` | `domains[]` (full FQDNs like "example.com") | Definitive yes/no on specific domains |

No auth required. Queries authoritative registries directly (Verisign, PIR). No front-running risk. If the MCP server is unavailable, proceed with brainstorm and evaluation — flag availability as unverified.

---

## Capsule: TheRadioTest

**Invariant**
Say the domain once on the phone. If the listener can't type it correctly, the name fails.

**Example**
"Check out stripe dot com" — everyone gets it right. "Check out flickr dot com" — "f-l-i-c-k-e-r?" Fail.
//BOUNDARY: A name that passes the radio test can still be bad (boring, generic, taken). But a name that fails it is always bad.

**Depth**
- This is the single most important rejection filter. SoundShape drives generation; RadioTest filters the results.
- Homophones kill: "their/there", "to/too/two", "write/right"
- Numbers kill: "four" vs "4", "won" vs "one"
- Unusual spellings kill: dropped vowels (Tumblr, Flickr) trade memorability for cleverness
- Hyphens kill: nobody remembers where the hyphen goes

---

## Capsule: SoundShape

**Invariant**
The best domain names follow consonant-vowel patterns with trochaic stress (STRONG-weak syllable).

**Example**
Google (GOO-gle), Canva (CAN-va), Figma (FIG-ma), Stripe (one strong syllable). All follow CVCV or CVC patterns with front-loaded stress.
//BOUNDARY: Sound shape makes a name pleasant to say. It doesn't make it meaningful, available, or brandable. Sound is necessary but not sufficient.

**Depth**
- **CVCV** is the universally easiest pattern to pronounce across all languages
- **Plosive consonants** (p, b, t, d, k, g) are empirically overrepresented in successful brand names — they create crisp, memorable onsets
- **Front vowels** (ee, i as in "bit") connote speed, lightness, precision — Wii, Zip, Figma
- **Back vowels** (oo, oh, aw) connote size, weight, depth — Google, Roku, Zoom
- Match the vowel character to the brand character
- **Avoid**: "sl-" onset (slime, slug associations), "-ump" endings, consonant clusters that require effort (strengths, sixths)
- Two syllables is the sweet spot. Three is fine if the stress pattern is clear. Four is almost always too many.

---

## Capsule: Memorability

**Invariant**
Shorter names are more memorable, with a 2% traffic penalty per character beyond seven.

**Example**
The premium zone is 4-8 characters. "Stripe" (6), "Canva" (5), "Figma" (5), "Notion" (6). Names beyond 11 characters fight an uphill battle.
//BOUNDARY: Length is a proxy. A 12-character name that's two clear English words (StackOverflow) can outperform a 5-character name that's unpronounceable (Xzqwy).

**Depth**
- .com domains are 33% more memorable than equivalent names on other TLDs (GrowthBadger, n=1,500)
- Users default to typing .com 3.8x more often when misremembering a URL
- Concrete imagery words are recalled better than abstract ones (dual-coding theory): Nest, Stripe, Amazon, Apple
- An invented word that nonetheless evokes an image gets some of this benefit: Spotify (spot + identify)

---

## Capsule: HiddenWords

**Invariant**
Before recommending any concatenated domain, check every possible word-break reading.

**Example**
"penisland.net" reads as "pen island" to the creator but not to everyone else. "choosespain.com" contains "chooses pain". "therapistfinder.com" contains "the rapist finder".
//BOUNDARY: This check is non-negotiable. Always mentally slide a word-break cursor across the full string left to right and note every readable substring.

---

## Capsule: BrandableVsExactMatch

**Invariant**
Brandable names (invented or evocative) build more long-term equity than exact-match domains.

**Example**
"CheapFlights.com" describes the product but has no brand identity. "Kayak.com" evokes exploration and is defensible as a trademark. Brandable names can expand into adjacent markets; exact-match names are locked to their keyword.
//BOUNDARY: Exact-match domains still work for small niche sites or local businesses where discoverability matters more than brand.

**Depth**
- Trademark strength hierarchy: Fanciful (strongest) > Arbitrary > Suggestive > Descriptive (weakest)
- Google, Kodak, Xerox — fanciful, meaningless words, maximum legal protection
- Apple (for computers) — arbitrary, real word in unrelated context, strong protection
- Netflix — suggestive, hints at the service, moderate protection
- CheapTickets — descriptive, almost no trademark protection
- Oversaturated patterns to avoid: -ify, -ly, -io, -er (vowel-drop), get[X].com, [X]hub.com

---

## Registrar Coverage

### When to Use Which

| Situation | Registrar | Why |
|-----------|-----------|-----|
| Best price, tech-savvy user | **Cloudflare** | At-cost pricing, zero markup, great DNS |
| Widest TLD selection | **Namecheap** | 567 TLDs, free WHOIS privacy |
| .au or .com.au domains | **CrazyDomains** | auDA-accredited, full AU/NZ support |
| .de, .fr, .eu domains | **Namecheap** | Cloudflare and CrazyDomains have gaps here |

### TLD Support Comparison

See `references/registrar-tlds.md` for detailed coverage tables.

**Critical gaps to know without looking it up:**
- **Cloudflare cannot register .au/.com.au** — use CrazyDomains or Namecheap
- **Cloudflare cannot register .de, .fr, .eu, .jp** — use Namecheap
- **CrazyDomains charges extra for TXT/SRV DNS records** — matters for email verification (SPF/DKIM/DMARC)
- All three support .com, .net, .org, .io, .ai, .dev, .app, .co, .me, .nz/.co.nz

### Pricing Models

| Registrar | Model | WHOIS Privacy |
|-----------|-------|---------------|
| Cloudflare | At-cost (registry price + ICANN fee, zero markup) | Free (redacted by default) |
| Namecheap | Retail with frequent promotions | Free on most TLDs |
| CrazyDomains | Retail pricing | Paid add-on ("Domain Guard") |

---

## The Search Workflow

1. **Brainstorm** — Generate 5-10 candidate names. Apply SoundShape and RadioTest mentally.
2. **Sweep** — Use `search_domains` to check candidates across target TLDs.
3. **Expand** — For taken names, use `generate_domain_variations` with sort=rank for best alternatives.
4. **Verify** — Use `check_domain_availability` for the shortlist (definitive yes/no).
5. **Evaluate** — Score finalists against the evaluation criteria below.
6. **Match registrar** — Check `references/registrar-tlds.md` to confirm the target TLD is supported where the user wants to register.

## Evaluating a Domain Name

When presenting options, assess each name against these dimensions:

| Dimension | Question | Weight |
|-----------|----------|--------|
| Sound | Does it roll off the tongue? (CVCV, trochaic, plosive onset) | High |
| Radio test | Can someone hear it once and type it? | High |
| Length | Under 8 characters? Under 12? | Medium |
| Imagery | Does it evoke something concrete? | Medium |
| Brandability | Trademark defensible? Room to grow? | Medium |
| Namespace | Does it collide with established brands in the same industry? | Medium |
| TLD | Is .com available? If not, is the alternative TLD credible for this audience? (.io has near-.com credibility for developer tools) | Medium |
| Hidden words | Any embarrassing substrings? | Pass/fail |
| Global safety | Any negative meanings in other languages? | Check |

Don't score numerically. Use natural language: "This name sounds crisp, passes the radio test, and the .com is available — strong candidate." or "This has a nice ring but the -ify suffix is overused and .com is taken — consider alternatives."

---

## Reference Files

- **`references/registrar-tlds.md`** — Detailed TLD coverage per registrar, special requirements, notable gaps

---

*The best domain name is the one nobody has to ask you to spell.*
