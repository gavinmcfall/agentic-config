# Research Domains: Detailed Questions

Each domain has key questions, evidence sources, and solo dev traps. Use this as a checklist when researching a domain — not every question applies every time, but scanning them prevents blind spots.

---

## Genre & Scope

**Key questions:**
- What genres have successful solo dev precedent on Steam?
- What's the minimum viable feature set for this genre?
- How long do comparable solo dev games take to build?
- What's the expected price point and sales volume?
- Does the genre match your interests long enough to finish?

**Evidence sources:**
- Steam postmortems (GDC vault, gamediscoverability.substack.com)
- SteamDB genre tags and median review counts
- Solo dev case studies (Stardew Valley, Hollow Knight, Undertale, Celeste, Vampire Survivors)
- Chris Zukowski's market analysis (howtomarketagame.com)

**Solo dev traps:**
- Scope defined by the genre's best example ("I want Stardew but also with..."). Define scope by what you can cut, not what you can add.
- "Unique twist" that doubles scope. The twist IS the game; everything else should be minimal.
- Genres that need content volume (RPGs, open world) vs mechanics depth (roguelikes, puzzle games). Content takes time linearly; mechanics can be iterated.

---

## Game Engines

**Key questions:**
- What's the time from install to running tutorial? (Learning floor, not ceiling)
- Does it export to Steam on your OS?
- What language does it use? Is that language on boot.dev?
- How active is the community? (Discord size, subreddit activity, forum posts/week)
- What's the editor experience? (Visual scripting? Scene editor? Inspector?)
- What are the known limitations for your target genre?

**Evidence sources:**
- Official documentation and tutorials
- Community surveys (r/gamedev annual survey)
- boot.dev course catalogue
- YouTube tutorial density and recency
- GitHub stars and commit activity

**Solo dev traps:**
- Choosing based on capability ceiling ("Unreal can do AAA graphics") instead of learning floor ("Godot had me running a scene in 30 minutes").
- Engine-hopping after hitting the first friction point. All engines have friction; commit and learn to work with it.
- Confusing "popular" with "right for me." Unity has the largest market share but that doesn't make it the best choice for a beginner.

---

## Programming Languages

**Key questions:**
- Is there a boot.dev course for this language?
- What's the time to "I wrote something useful"?
- Does the language have good error messages for beginners?
- How transferable are the skills to other contexts?
- What does the debugging experience look like?

**Evidence sources:**
- boot.dev course catalogue and learning paths
- Language documentation quality (official tutorials, getting started guides)
- Stack Overflow question volume and answer quality
- Beginner experience reports (r/learnprogramming)

**Solo dev traps:**
- Picking the "best" language instead of the one tied to your engine choice. The engine decision should drive this.
- Learning a language in isolation before applying it to game dev. Learn through building.
- Paralysis between similar options (GDScript vs C# in Godot). Either works; pick one and go.

---

## Art Style

**Key questions:**
- Can you produce this consistently across 50+ assets? (Not just one good piece)
- What's the asset pipeline? (Create → export → import → display)
- How forgiving is the style of imperfection? (Pixel art hides less than you think)
- Does the style match your genre's expectations?
- What reference games use this style successfully?

**Evidence sources:**
- Indie games with solo dev art (check credits)
- Art style postmortems (GDC, YouTube devlogs)
- Asset creation time estimates from devlogs
- Tool-specific tutorials and community galleries

**Solo dev traps:**
- "Pixel art is easy." Consistent pixel art at scale requires discipline. Every pixel is a decision.
- 3D has a massive tool learning curve before producing anything usable. If you've never done 3D, budget months for tools alone.
- Mixing styles within a game. Pick one and commit. Consistency matters more than quality.
- Underestimating UI/UX art. Menus, HUDs, and icons are art too.

---

## Art Tools

**Key questions:**
- What's the cost? (Free/one-time/subscription)
- What export formats does your engine need?
- How large is the tutorial community?
- Does it support your chosen art style well?
- Is there a pipeline from this tool to your engine?

**Evidence sources:**
- Tool documentation and export format lists
- YouTube tutorial counts for "tool + art style" combination
- Community forums and Discord servers
- Free vs paid feature comparison

**Solo dev traps:**
- Tool hopping. Pick one and learn it deeply rather than trying everything.
- Buying expensive tools before committing to a style. Start with free options.
- Optimizing the pipeline before having assets to put through it.

---

## Sound & Music

**Key questions:**
- Create, license, or AI-generate? Each has different cost/time/legal profiles.
- What audio does the genre require? (Ambient? Dynamic? Reactive?)
- How many unique sound effects does a typical game in this genre have?
- What's the integration path with your engine?
- What are the legal implications of your chosen approach?

**Evidence sources:**
- Audio middleware documentation (FMOD, Wwise — both have free indie tiers)
- Royalty-free audio marketplaces and their license terms
- AI audio tool capabilities and legal standing (rapidly evolving)
- Indie game audio postmortems
- Engine-specific audio documentation

**Solo dev traps:**
- Leaving audio until the end. Budget time for it from the start.
- Assuming "royalty-free" means "use however you want." Read licenses.
- AI-generated audio's legal standing is unsettled. Keep fallback options.
- Underestimating how much audio contributes to game feel.

---

## Game Design

**Key questions:**
- What's the core loop? (Can you describe it in one sentence?)
- What's the minimum prototype that tests the core loop?
- What does the GDD need to contain at each stage?
- How will you playtest as a solo dev?

**Evidence sources:**
- Game design books (pick one, not five)
- GDC talks on prototyping and core loops
- Published GDDs from indie games
- Playtest methodology resources

**Solo dev traps:**
- Over-designing before prototyping. A 50-page GDD is procrastination if there's no prototype.
- Designing systems instead of experiences. "The crafting system has 200 materials" vs "the player feels clever when combining unexpected items."
- Scope creep disguised as design iteration.

---

## SDLC & Tools

**Key questions:**
- Version control setup? (Git + hosting)
- Build pipeline? (Export → test → package)
- How will you track bugs vs features vs ideas?
- What's the backup strategy for irreplaceable assets?

**Evidence sources:**
- Engine-specific CI/CD guides
- Solo dev workflow postmortems
- Plane documentation (already deployed on k8s)
- GitHub Actions documentation

**Solo dev traps:**
- Over-engineering the pipeline before there's code. Version control + basic backup is enough to start.
- No backup strategy for art assets (Git LFS? Separate storage?)
- Confusing "professional SDLC" with "productive solo dev SDLC." You don't need staging environments for a solo project.

---

## Steam Publishing

**Key questions:**
- When should the Steamworks account be created? (Early — it takes time)
- When should the store page go live? (Before the game is done)
- What's the wishlist-to-sale conversion benchmark?
- What marketing assets are needed and when?
- What are the Steamworks technical requirements?

**Evidence sources:**
- Steamworks documentation
- Chris Zukowski's Steam marketing guides
- GDC talks on indie Steam launches
- Postmortems with sales data

**Solo dev traps:**
- No store page until launch. The store page IS the marketing. Launch it early.
- Ignoring capsule art. The small capsule image is the most important marketing asset.
- Underpricing. Solo devs consistently underprice. Research genre price expectations.
- Marketing starts at store page creation, not at launch.

---

## Learning Path

**Key questions:**
- What does boot.dev offer for my chosen stack?
- What supplementary resources fill gaps boot.dev doesn't cover?
- What's the learning order? (Language fundamentals → engine basics → game-specific patterns)
- How do I measure progress beyond "completed a tutorial"?

**Evidence sources:**
- boot.dev course catalogue and reviews
- Engine-specific learning path recommendations
- Community-recommended supplementary resources
- "I learned X in Y months" experience reports

**Solo dev traps:**
- Tutorial hell. Learning without building. Set a rule: for every hour of tutorial, spend an hour building something original.
- Learning everything before starting. Learn just enough to build the next thing.
- Comparing your learning pace to full-time developers or CS graduates.

---

## Community & Marketing

**Key questions:**
- When is the right time to start building an audience?
- What platforms make sense? (Discord, Twitter/X, Reddit, YouTube devlog)
- What content can you create that doesn't eat into dev time?
- How do you build a wishlist funnel?

**Evidence sources:**
- Chris Zukowski's audience-building guides
- Successful indie devlog channels (analysis of what works)
- Steam wishlist benchmarks by genre
- Community management postmortems

**Solo dev traps:**
- Starting community too early (nothing to show) or too late (no audience at launch).
- Devlog as procrastination. Spending more time documenting than building.
- Comparing follower counts to teams with dedicated community managers.

---

*Research in dependency order. Don't research tools before knowing the style.*
