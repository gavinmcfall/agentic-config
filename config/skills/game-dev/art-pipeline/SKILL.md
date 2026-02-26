---
name: art-pipeline
description: Manage game art assets from creation to in-engine. Use when organizing sprites, choosing art tools, setting up folder structures, managing source files, or planning asset production. For a solo dev learning art — practical pipeline, not art instruction.
zones: { knowledge: 45, process: 30, constraint: 15, wisdom: 10 }
---

# art-pipeline

The best art pipeline is the one you actually use. Start simple. Automate later.

---

## Capsule: SourceOfTruth

**Invariant**
Every asset has one source file and one export target. The source file is the editable original (layers, vectors, animation frames). The export is the game-ready file. Never edit exports directly.

**Example**
`player_idle.ase` (source, Aseprite) → export → `player_idle.png` (game-ready). Need to change the player? Edit the `.ase`, re-export. Never open the PNG in a pixel editor.
//BOUNDARY: Quick one-off assets (placeholder rectangles, debug markers) can skip the source file. But anything that will ship needs a source.

---

## Folder Structure

```
project/
├── assets/                    ← game-ready exports (committed to git)
│   ├── sprites/
│   │   ├── player/
│   │   ├── enemies/
│   │   ├── items/
│   │   └── effects/
│   ├── tilesets/
│   ├── ui/
│   ├── backgrounds/
│   └── audio/                 ← see sound-designer skill
│
├── art-source/                ← editable source files
│   ├── sprites/               ← mirrors assets/ structure
│   │   ├── player/
│   │   ├── enemies/
│   │   ├── items/
│   │   └── effects/
│   ├── tilesets/
│   ├── ui/
│   └── backgrounds/
│
└── marketing/                 ← Steam capsule, screenshots, trailer
    ├── capsule/
    ├── screenshots/
    └── trailer/
```

### Key Rules

- `assets/` mirrors `art-source/` in structure. Same subfolders, same naming.
- Source files go in `art-source/`. Exports go in `assets/`.
- `art-source/` can be gitignored if files are too large — but back them up (MinIO, external drive).
- `marketing/` is separate because marketing assets have different requirements (resolutions, formats, Steam specs).

---

## Naming Conventions

```
[subject]_[variant]_[state]_[frame].png
```

| Component | Examples | Notes |
|-----------|----------|-------|
| subject | `player`, `slime`, `sword`, `tile_grass` | What the asset is |
| variant | `red`, `elite`, `rusty` | Optional — for variations |
| state | `idle`, `run`, `attack`, `dead` | Animation state |
| frame | `01`, `02`, `03` | For sprite sheets / animation frames |

**Examples:**
- `player_idle_01.png`
- `slime_red_attack_03.png`
- `sword_rusty.png` (no state — static item)
- `tile_grass_center.png`

**Rules:**
- All lowercase
- Underscores between components, never spaces or hyphens
- Zero-padded frame numbers (`01` not `1`)
- No special characters, no unicode

**Source vs Export naming**: Aseprite stores all animation frames in one `.ase` file. The source file is named without frame numbers: `player_idle.ase`. On export (File -> Export Sprite Sheet or batch export), frames become `player_idle_01.png`, `player_idle_02.png`, etc. One source file, many export files.

---

## Tools for Getting Started

Pick ONE tool per category. Learn it. Switch only if it genuinely blocks you.

### Pixel Art (Recommended Start for 2D)

**Aseprite** — The standard for pixel art. Costs ~$20 or compile from source for free.
- Sprite creation, animation, sprite sheet export
- Tileset support built in
- Layer management, onion skinning

**LibreSprite** — Free, open-source fork of older Aseprite. Fewer features but functional.

### 2D Illustration

**Krita** — Free, open-source. Full painting/illustration tool.
- Good for larger-scale 2D art, concept art, backgrounds
- Overkill for pixel art (use Aseprite instead)

### Tile Map Editors

**LDtk** — Modern tile map editor by the creator of Dead Cells.
- Exports JSON that most engines can read
- Auto-tiling, entity placement, level design

**Tiled** — The long-standing standard. More features, steeper learning curve.

### 3D (If Needed)

**Blender** — Free, does everything. Steep learning curve but enormous community and tutorials.

---

## Asset Types and Specs

### Sprites

| Property | Recommendation |
|----------|---------------|
| Format | PNG (lossless, transparency) |
| Size | Power of 2 not required for modern engines, but keep consistent within a category |
| Resolution | Choose one base resolution and stick with it. Common: 16x16, 32x32, 48x48, 64x64 |
| Color depth | 32-bit RGBA |

### Tilesets

| Property | Recommendation |
|----------|---------------|
| Tile size | 16x16 or 32x32 for pixel art; match sprite scale |
| Format | Single PNG atlas with consistent grid |
| Padding | 1px between tiles to prevent bleeding |
| Export | Atlas + JSON metadata (LDtk or Tiled export) |

### UI Elements

| Property | Recommendation |
|----------|---------------|
| Format | PNG with transparency |
| Style | Match game's art style but prioritize readability |
| 9-slice | Use 9-slice/9-patch for resizable panels and buttons |

### Sprite Sheets

Combine animation frames into a single image:

```
player_idle_sheet.png (4 frames, 32x32 each = 128x32 total)
┌────┬────┬────┬────┐
│ 01 │ 02 │ 03 │ 04 │
└────┴────┴────┴────┘
```

Export from Aseprite: File → Export Sprite Sheet → choose layout.

---

## Art Production Sizing

Art takes longer than you think. Use these estimates for sprint planning:

| Asset | Size | Estimate (Beginner) |
|-------|------|---------------------|
| Simple sprite (16x16, few colors) | S | 30-60 min |
| Detailed sprite (32x32, animated) | M | 2-4 hours |
| Character with full animation set | L | 1-2 days |
| Tileset (basic, 20-30 tiles) | L | 1-2 days |
| Full tileset (60+ tiles, autotile) | XL | 3-5 days |
| UI mockup (one screen) | M | 2-4 hours |
| Background/parallax (one layer) | M | 2-4 hours |

These are beginner estimates. They get faster with practice, but NOT as fast as you hope.

---

## Version Control for Art

### What to Commit

- `assets/` (exported PNGs) — always commit. These are small and essential.
- `art-source/` — commit if files are reasonable size (<50MB total). Otherwise gitignore and back up separately.

### Large File Strategy

If source files are large (PSD, Blender files):
1. Add `art-source/` to `.gitignore`
2. Back up to MinIO bucket (see n8n-workflow-builder for automation)
3. Keep a `art-source/README.md` listing what's stored and where the backup lives

### Git LFS

For projects with many large source files, consider Git LFS. But for a solo dev starting out, the gitignore + backup approach is simpler.

---

## Constraints

- One source file per asset. Never edit exports directly.
- Follow naming conventions. No exceptions.
- Folder structure mirrors between `art-source/` and `assets/`.
- Pick one resolution per asset category and stick with it.
- Back up source files that aren't in git. Lost source files can't be recreated.
- Art tasks in sprint-manager use the production sizing estimates, not optimistic guesses.

---

## For AI Assistants

When helping with art pipeline:

1. **Check the folder structure**: Does it follow the convention? If not, help set it up.
2. **Enforce naming**: If the user names something `Player Idle (2).png`, gently redirect to `player_idle_02.png`.
3. **Size honestly**: When the user plans art tasks, reference the production sizing table. "A full character animation set is an L — that's 1-2 days for a beginner."
4. **Source file discipline**: If the user edits an export directly, flag it. "Edit the source file and re-export. This way you keep layers and can change it later."
5. **Scope check**: If art production plans seem large, invoke scope-guardian. "50 unique enemy sprites at M each is 100-200 hours of art. Is that Core scope?"

When the user is choosing art tools:
- Recommend Aseprite for pixel art, Krita for 2D illustration
- Discourage tool-shopping: "Pick one, learn it for a month, then evaluate"
- Check if the tool exports to formats the game engine supports

---

## Deeper

- The `scope-guardian` skill — Art scope is content scope
- The `prototype-coach` skill — Art tests validate style feasibility
- The `gdd-writer` skill — Art Direction section
- The `n8n-workflow-builder` skill — Automating asset processing
- The `sound-designer` skill — Audio assets follow similar pipeline patterns

---

*Organized assets compound. Messy assets multiply. Name it right the first time.*
