---
name: sound-designer
description: Manage game audio from sourcing to in-engine integration. Use when planning sound effects, sourcing music, organizing audio assets, or deciding when to add sound to the project. For a solo dev — practical sourcing and pipeline, not music theory.
zones: { knowledge: 50, process: 25, constraint: 15, wisdom: 10 }
---

# sound-designer

Sound is 50% of the experience and 5% of the work — if you approach it right.

---

## Capsule: SoundTiming

**Invariant**
Add sound AFTER mechanics feel right, not before. Sound polish on broken mechanics is wasted effort.

**Example**
Don't add impact sounds to combat until the hit detection and knockback feel correct. Once the mechanic is validated, sound transforms "correct" into "satisfying."
//BOUNDARY: Placeholder sound during prototyping is fine — a simple "blip" on jump helps evaluate feel. But don't source or produce final audio until the mechanic is locked.

**Depth**
- The development order: mechanics → art → sound → polish
- Sound is a force multiplier: it makes good mechanics feel great
- Sound cannot save bad mechanics: if movement feels wrong, sound won't fix it
- Placeholder audio (simple beeps/clicks) during prototyping helps evaluation without premature investment

---

## Capsule: SourceDontCreate

**Invariant**
A solo dev learning to code and make art should source audio, not create it. Music composition and sound design are full careers.

**Example**
Need forest ambience? Download from Freesound.org (CC0 license). Need a sword clash? Use sfxr to generate a retro-style effect, or find one in a free SFX pack. Need a game soundtrack? Commission it or use a licensed music pack.
//BOUNDARY: If the user genuinely wants to learn audio production, respect that — but it's a scope expansion. Check with scope-guardian.

---

## Audio Asset Types

### SFX (Sound Effects)

| Category | Examples | Priority |
|----------|----------|----------|
| **Player actions** | Jump, attack, dash, land, pick up, use | Core — add these first |
| **Combat** | Hit, damage taken, death, projectile fire/hit | Core |
| **UI** | Button click, menu open/close, confirm, cancel | Important |
| **Environment** | Footsteps, doors, chests, breakables | Important |
| **Feedback** | Level complete, achievement, error, warning | Nice-to-have |

### Music

| Track | When | Priority |
|-------|------|----------|
| **Gameplay loop** (1-2 tracks) | During gameplay | Important |
| **Title/menu** | Main menu, pause | Nice-to-have |
| **Boss/tension** | Combat escalation | Nice-to-have |
| **Stingers** | Short cues for events (3-5 sec) | Nice-to-have |

For a v1.0 solo dev game: 2-3 music tracks and 15-25 SFX is enough. Don't plan for 20 unique tracks.

### Ambient

Background audio loops for environments. Layer on top of music.
- One per environment type is sufficient (forest, cave, town, rain)

---

## Sourcing Audio

### Free Sources

| Source | Content | License |
|--------|---------|---------|
| **Freesound.org** | SFX, ambient, field recordings | Varies (check per file) — prefer CC0 |
| **OpenGameArt.org** | SFX and music for games | Varies — check per asset |
| **Kenney.nl** | Game-ready SFX packs | CC0 |
| **itch.io** | SFX and music packs (free section) | Varies |

### Paid Sources

| Source | Content | Cost |
|--------|---------|------|
| **itch.io asset packs** | Curated game audio | $5-30 per pack |
| **Humble Bundle** | Periodic game audio bundles | $15-30 |
| **Epidemic Sound / Artlist** | Music libraries | Subscription |

### Generate Your Own SFX

**sfxr / jsfxr** — Generate retro-style sound effects procedurally.

Use for: jump, coin, explosion, laser, powerup, hit, select.

jsfxr runs in the browser at sfxr.me — no install needed. Export as WAV, then convert to OGG with Audacity.

**Audacity** — Free audio editor for:
- Trimming and normalizing downloaded SFX
- Layering multiple sounds
- Converting between formats
- Recording your own foley (clapping, tapping, etc.)
- **Volume normalization**: When mixing SFX from different sources, normalize all to the same peak level (e.g., -3dB). Effect -> Normalize in Audacity. This prevents some sounds being deafening while others are inaudible.

---

## Audio Formats

| Format | Use For | Why |
|--------|---------|-----|
| **WAV** | Source/master files | Uncompressed, full quality |
| **OGG Vorbis** | In-engine SFX and music | Compressed, good quality, free format |
| **MP3** | Avoid if possible | Patent issues historically; OGG is better for games |

### Export Settings

- **SFX**: OGG Vorbis, quality 6-8 (out of 10), mono, 44.1kHz
- **Music**: OGG Vorbis, quality 8-10, stereo, 44.1kHz
- **Ambient**: OGG Vorbis, quality 6-8, stereo, 44.1kHz, seamless loop

Most game engines prefer OGG. Check your engine's documentation.

---

## Folder Structure

Follows art-pipeline conventions:

```
assets/
└── audio/
    ├── sfx/
    │   ├── player/        ← player_jump.ogg, player_attack.ogg
    │   ├── combat/        ← hit_sword.ogg, damage_taken.ogg
    │   ├── ui/            ← button_click.ogg, menu_open.ogg
    │   └── environment/   ← door_open.ogg, chest_open.ogg
    ├── music/
    │   ├── gameplay/      ← track_exploration.ogg
    │   ├── menu/          ← track_title.ogg
    │   └── stingers/      ← stinger_boss_appear.ogg
    └── ambient/           ← ambient_forest.ogg, ambient_cave.ogg
```

### Naming Convention

Same pattern as art-pipeline:
```
[category]_[descriptor].ogg
```

Examples:
- `player_jump.ogg`
- `hit_sword_01.ogg`, `hit_sword_02.ogg` (variants for randomization)
- `track_exploration.ogg`
- `ambient_forest_loop.ogg`

**Multiple variants**: For SFX that play frequently (footsteps, hits), create 2-3 variants numbered `_01`, `_02`, `_03`. Playing random variants prevents repetition fatigue.

---

## Licensing

### Hard Rules

- **Always check the license** before using any sourced audio
- **Record the license** in a `LICENSES.md` file in the audio directory
- **CC0 (public domain)**: Use freely, no attribution required. Prefer this.
- **CC-BY**: Must credit the creator. Track attributions in `LICENSES.md`.
- **CC-BY-NC**: Non-commercial only. Do NOT use for a game you plan to sell.
- **No license listed**: Do NOT use. Unlicensed content defaults to "all rights reserved."

### License Tracking

```markdown
# Audio Licenses

## SFX
- player_jump.ogg: Generated with jsfxr (no license needed)
- hit_sword_01.ogg: Freesound.org by [author], CC0
- door_open.ogg: Kenney.nl, CC0

## Music
- track_exploration.ogg: Commissioned from [artist], exclusive license
- track_title.ogg: [Pack name] from itch.io, CC-BY [author]
```

---

## When to Add Sound (Development Timeline)

| Phase | Sound Work | Effort |
|-------|-----------|--------|
| **Prototyping** | Placeholder bleeps from sfxr | 30 min total |
| **Core mechanics locked** | Source/generate player action SFX | 2-4 hours |
| **Vertical slice** | Basic SFX set + one music track | 1-2 days |
| **Alpha** | Full SFX set, 2-3 music tracks | 3-5 days |
| **Beta** | Polish, audio mixing, ambient layers | 2-3 days |

Total audio work for a solo dev game: roughly **2 weeks** spread across development. This is why sourcing beats creating — 2 weeks of sourcing and integration gets you 95% of the result that 6 months of learning audio production would.

---

## Constraints

- Source audio, don't create it (unless audio production is an explicit learning goal)
- Always check and record licenses in `LICENSES.md`
- No audio work until mechanics are validated (placeholders excepted)
- OGG Vorbis for in-engine files, WAV for source/master files
- Follow naming conventions from art-pipeline
- 2-3 variants for frequently-played SFX to prevent repetition fatigue
- Keep total audio scope realistic: 15-25 SFX + 2-3 music tracks for v1.0

---

## For AI Assistants

When helping with game audio:

1. **Check the timing**: Has the mechanic been validated? If not, defer sound work. "Let's get the movement feeling right first, then add sound."
2. **Default to sourcing**: When the user needs audio, suggest sourcing before creating. "For forest ambience, check Freesound.org with a CC0 filter."
3. **License check**: When the user adds sourced audio, ask about the license. "What license does that file use? Let's add it to LICENSES.md."
4. **Scope guard**: If the user plans extensive audio work, check scope. "15 SFX and 2 music tracks is good for v1.0. We can add more post-launch."
5. **Suggest sfxr**: For retro-style games or quick placeholders, jsfxr is instant. "Want to generate a quick jump sound in jsfxr?"

When the user mentions wanting to learn music production:
- Acknowledge the interest
- Check with scope-guardian: "Learning music production is a multi-month investment. Want to factor that into the project timeline, or source audio and learn music separately?"

---

## Deeper

- The `art-pipeline` skill — Parallel asset management patterns
- The `scope-guardian` skill — Audio content is scope
- The `gdd-writer` skill — Audio Direction section
- The `prototype-coach` skill — Placeholder audio during prototyping
- Freesound.org — Primary free SFX source
- jsfxr — Browser-based retro SFX generator

---

*Sound turns a game you can see into a game you can feel.*
