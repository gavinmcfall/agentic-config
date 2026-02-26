---
name: steam-publisher
description: Navigate the Steam publishing pipeline from Steamworks registration to post-launch. Use when setting up a store page, preparing builds for upload, planning a release timeline, pricing, marketing, or deciding about Early Access. For a solo dev publishing their first game.
zones: { knowledge: 55, process: 25, constraint: 10, wisdom: 10 }
---

# steam-publisher

The gap between "game is done" and "game is on Steam" is wider than you think. Plan for it.

---

## Capsule: CapsuleIsKing

**Invariant**
Your capsule image is the single most viewed asset. If it doesn't stand out in a grid of other capsules, nothing else about your game matters.

**Example**
Players browse Steam like a bookstore — they scan covers. A mediocre game with professional capsule art gets more clicks than a great game with programmer art capsules. This is one place where commissioning professional work pays for itself many times over.
//BOUNDARY: "Professional" doesn't mean expensive. A competent freelance artist on Fiverr or ArtStation can produce quality capsule art for $50-200. But programmer-art capsules are almost never acceptable.

**Depth**
- Capsules cannot contain review quotes, award logos, or marketing text beyond the game title
- The logo/title must be readable at small sizes (462x174 for Small Capsule)
- Art style should represent actual gameplay, not aspirational concept art
- Test your capsule at multiple sizes — it needs to work at every dimension

---

## Capsule: ComingSoonIsMarketing

**Invariant**
Your Coming Soon page is your first and most important marketing tool. Launch it the moment you announce your game publicly, not when the game is "almost done."

**Example**
A viral tweet about your game reaches 10,000 people. Without a Steam page, that attention evaporates. With a Coming Soon page, those people can wishlist — and Steam will email every one of them on launch day.
//BOUNDARY: The Coming Soon page must be live at least 2 weeks before release (Steam requirement). But "as early as possible" is the real guideline. Games that outperformed expectations averaged ~214 days of pre-release visibility.

---

## Steamworks Setup

### Registration Process

1. Create a Steam account (if needed)
2. Sign up at partner.steamgames.com
3. Sign NDA and Steam Distribution Agreement
4. Complete identity/financial verification (legal ID, tax interview W-9/W-8BEN, bank info for payment)
5. Wait 2-7 business days for verification

### Costs

- **$100 per app** (Steam Direct fee) — recoupable at $1,000 revenue
- **70/30 revenue split** (developer/Valve) — standard tier
- Free: CD key generation, matchmaking, mod hosting, merchant services

---

## Store Page Requirements

### Required Graphical Assets (August 2024 dimensions)

Verify current dimensions at partner.steamgames.com/doc/store/assets/standard before creating art — dimensions have changed before and may change again.

**Store Assets:**

| Asset | Dimensions | Notes |
|-------|-----------|-------|
| Header Capsule | 920 x 430 | Primary store listing image |
| Small Capsule | 462 x 174 | Auto-generates smaller variants |
| Main Capsule | 1232 x 706 | Featured placement |
| Vertical Capsule | 748 x 896 | Sales and events |

**Library Assets:**

| Asset | Dimensions | Notes |
|-------|-----------|-------|
| Library Capsule | 600 x 900 | Vertical art in player libraries |
| Library Hero | 3840 x 1240 | Wide banner in library |
| Library Logo | 1280w and/or 720h | Your game logo (PNG) |

**Other:**

| Asset | Dimensions |
|-------|-----------|
| App Icon | 184 x 184 (JPG) |
| Shortcut Icon | 256 x 256 (ICO/PNG) |
| Event Cover | 800 x 450 |

### Screenshots
- Minimum 5, gameplay only (no concept art, no marketing text)
- Recommended: 1920 x 1080 (16:9)
- At least 4 must be "suitable for all ages" for broad visibility

### Trailers
- Not strictly required but strongly recommended
- A good trailer is the highest-converting store page asset after capsule art
- Lead with your strongest trailer if you have multiple

### Store Text
- Short description: ~300 characters
- Long description: Supports basic formatting
- Tags: Community-driven, developer sets initial tags. Tags drive recommendation algorithm.
- Categories: Developer-set feature flags (Singleplayer, Controller Support, Achievements, Cloud, etc.)

---

## Build Upload (SteamPipe)

### Key Concepts

| Concept | What It Is |
|---------|-----------|
| **App** | Your game. Identified by App ID. |
| **Depot** | Logical file grouping within an app. Simple game = one depot. |
| **Build** | Specific version of your depots. Gets a Build ID. |
| **Branch** | Like a git branch. "default" = what players download. |

### Upload Process

1. Download Steamworks SDK
2. Place game files in `ContentBuilder/content/`
3. Create VDF configuration files in `ContentBuilder/scripts/`
4. Run SteamCMD to upload: `steamcmd.exe +login <user> +run_app_build <path.vdf> +quit`
5. Set build live on the "default" branch in Steamworks

SteamPipe is chunk-based — only changed files re-upload on updates.

**SteamPipeGUI** (Windows only) provides a visual interface if you prefer not to use the command line.

### Engine Integration

Your game needs the Steamworks SDK integrated to use Steam features (achievements, cloud saves, etc.):
- **Godot**: GodotSteam plugin (godotsteam.com)
- **Unity**: Steamworks.NET
- **Unreal**: Built-in Online Subsystem Steam

SDK integration must be working before build upload — listed features that don't work cause review rejection.

---

## Release Timeline

### Minimum Timeline

| Step | When |
|------|------|
| Coming Soon page live | As early as possible (minimum 2 weeks before release) |
| Store page submitted for review | 7+ business days before release |
| Build submitted for review | 7+ business days before release |
| **Practical minimum** | **4-6 weeks** from first submission |

### Review Process

- **Store review**: Valve checks assets, descriptions, compliance. 3-5 business days.
- **Build review**: Valve checks the game launches, runs on listed platforms, listed features work. 3-5 business days.
- Plan for potential feedback and resubmission rounds.
- After initial approval, updates do NOT need re-review.

### Common Rejection Reasons
- Build fails to launch
- Listed features (achievements, cloud saves) not actually implemented
- Copyright-infringing content
- External payment systems instead of Steam Wallet

---

## Pricing

### Guidelines for Indie Games

- Most indie games price between **$5-$20**
- Price **20-30% above your "real" target** — most sales happen during discounts
- Use Steam's recommended regional pricing (based on purchasing power parity)
- Pricing too low signals low quality AND leaves no room for meaningful discounts

### Launch Discount Rules

| Rule | Detail |
|------|--------|
| Range | 10% to 40% |
| Duration | 7 to 14 days |
| Must configure | Before release |
| Cooldown after | 30 days before next discount |
| Wishlist notification | 20%+ discount triggers email to all wishlisters |

---

## Wishlists

### Why They Matter

1. **Direct notifications**: Steam emails wishlisters on launch and on 20%+ discounts
2. **Popular Upcoming placement**: One of the few widgets where wishlist count directly influences visibility
3. Wishlists do NOT broadly drive the recommendation algorithm beyond that widget

### Conversion Benchmarks

| Metric | Value |
|--------|-------|
| Median first-week conversion (>25k wishlists) | ~15% |
| Games priced over $10 | ~10% |
| Lifetime conversion | ~10% of total wishlists |
| Key conversion factor | Review score (91% positive for outperformers) |

### What Drives Conversion

- **Review quality** matters most — positive reviews correlate with higher conversion
- **Shorter pre-release windows** (~7 months) convert better than longer (~14 months)
- **Price** — higher price reduces conversion rate

---

## Early Access Decision

### EA Launch IS Your Launch

Steam gives Early Access the same algorithmic visibility spike as a full release. The 1.0 release does NOT give you a second full launch. Your 5 Update Visibility Rounds are shared between EA and full release.

### When EA Makes Sense

- Iterative genre (survival craft, colony sim, roguelike)
- You have a **polished vertical slice**, not a prototype
- You can commit to monthly updates
- Realistic plan to reach 1.0 within 12-18 months
- You are NOT counting on EA revenue to fund core development

### When to Skip EA

- Narrative-driven or has a defined ending
- Cannot commit to update cadence
- Close enough to done that EA would be a premature launch

---

## Marketing Timeline

| When | Action |
|------|--------|
| **Game announced publicly** | Coming Soon page live immediately |
| **9-12 months before release** | Capsule art finalized, store page polished |
| **6-9 months before release** | Steam Next Fest with demo (if applicable) |
| **3-6 months before release** | Social media, press outreach, content creators |
| **2 months before release** | Finalize pricing and regional settings |
| **1 month before release** | Submit for review, configure launch discount |
| **Launch week** | Be present in forums, respond to bugs, post announcements |
| **Post-launch** | Updates, Visibility Rounds, seasonal sales |

### Steam Next Fest

- Runs 3x/year (February, June, October)
- Free event — showcase a demo
- Release demo 2 weeks before Next Fest to gather initial feedback
- Aim for 15-25 minute demo showcasing core mechanics
- Median demo earns ~300 wishlists; 5,000-7,000 is a breakout
- Livestreaming during the fest boosts visibility

---

## Steam Features Worth Implementing

| Feature | Effort | Priority |
|---------|--------|----------|
| **Achievements** | Low | Important — players expect them |
| **Cloud Saves (Auto-Cloud)** | Low | Important — lack of cloud saves draws negative reviews |
| **Controller Support** | Medium | Important for Steam Deck |
| **Trading Cards** | N/A | Gated behind ~$50k revenue — post-success bonus |
| **Workshop** | High | Post-launch, only if natural modding potential |
| **Remote Play Together** | Low | Valuable for local co-op games without netcode |

### Auto-Cloud Setup

The easiest path: specify file paths/patterns in Steamworks settings. Steam syncs automatically on launch and exit. No code changes needed. Configure byte quota and file count per user.

---

## Post-Launch

### Update Visibility Rounds

- 5 rounds per product (shared between EA and full release)
- Each round: front page placement for 30 days or 1M impressions
- Requires a community announcement within the last 30 days
- Does not display during seasonal sales (but days still count)
- Use wisely — pair with meaningful content updates and discounts

### Announcement Tiers

1. **Patch Notes**: Bug fixes. Low visibility.
2. **Regular Updates**: New content/features. Moderate visibility.
3. **Major Updates**: Significant additions. High visibility. Can trigger Visibility Round.

### DLC Strategy

- Created as separate App ID attached to base game
- Extends revenue lifetime
- Cosmetic/content DLC is lower-risk than mechanical DLC for solo dev
- Well-planned DLC can account for more than half of lifetime revenue

---

## Common Solo Dev Mistakes

| Mistake | Why It Hurts |
|---------|-------------|
| Marketing too late | No time to build wishlist base |
| Underestimating store page work | Dozens of hours of asset preparation |
| EA without polished vertical slice | Burns your one launch opportunity |
| Not using Visibility Rounds | Algorithm interprets silence as abandonment |
| Pricing too low | Signals low quality, no room for discounts |
| Skipping Steam events | Leaving free visibility on the table |
| Programmer-art capsules | Invisible in the store grid |

---

## Constraints

- Never enter Early Access with a prototype — polished vertical slice minimum
- Always verify exact asset dimensions against current Steamworks docs before creating capsule art
- Submit for review at least 7 business days before target release
- Configure launch discount before release, not after
- Coming Soon page must be live minimum 2 weeks before release
- Track revenue split terms in your current Steam Distribution Agreement — terms have changed over time

---

## For AI Assistants

When helping with Steam publishing:

1. **Check the timeline**: "When are you planning to release?" If it's less than 6 weeks out, flag the review timeline. "Store and build review each take 3-5 business days. Let's plan the submission schedule."
2. **Asset dimensions**: Always reference the August 2024 dimensions. Old sizes are rejected. "Header Capsule is 920x430 — double-check before creating art."
3. **Marketing timing**: If the user has a playable game but no Coming Soon page, this is urgent. "Your Coming Soon page should have gone up when you first announced. Let's set it up now."
4. **EA decision**: If the user is considering Early Access, check the criteria. "EA launch IS your launch algorithmically. Is the vertical slice polished enough for that?"
5. **Scope the store page work**: Users consistently underestimate this. "Preparing a Steam store page is easily 20-40 hours of work. Let's break it down."
6. **Capsule art priority**: If the user plans to use placeholder capsule art, flag it. "Capsule art is the highest-ROI marketing investment. Commission this even if you DIY everything else."

---

## Deeper

- The `art-pipeline` skill — Capsule art as a special asset category
- The `scope-guardian` skill — Store page preparation is scope
- The `prototype-coach` skill — Vertical slice readiness for EA
- The `playtest-coordinator` skill — Steam Playtest feature, Next Fest demos
- The `sprint-manager` skill — Store page tasks in sprint planning
- partner.steamgames.com — Steamworks documentation and portal

---

*The store page isn't a chore after development. It's a marketing tool during development.*
