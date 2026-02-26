# Skill Tiers

Skills are organized into tiers based on how universally applicable they are.

## Tier 1: Core

**Always installed.** These skills are useful regardless of what you're building.

- **using-skills** — Entry point: checks and invokes available skills before any task
- **skill-builder** — How to create and improve Claude Code skills
- **writing-documents** — Documentation guidance for 7+ document types
- **code-review** — Fresh-eyes code review with multi-AI prompt generation
- **review-responder** — Process and respond to code review feedback
- **research** — Evidence-first investigation with mandatory citations
- **mermaid-diagrams** — Effective diagram creation in markdown
- **domain-expert** — Domain name evaluation and recommendation

## Tier 2: Game Dev

**Optional.** Solo game development workflows with ADHD-adapted productivity patterns.

These skills encode universal patterns that apply broadly to creative solo work:
- ADHD management strategies (energy economics, hyperfocus leverage, two-minute starts)
- Sprint planning adapted for one person, not teams
- Scope protection (the external "no" that prevents feature creep)
- Learning path structure (prevents tutorial hell)
- Game-specific workflows (GDD, prototyping, playtesting, Steam publishing)

Even if you're not building games, the ADHD/productivity skills (`adhd-coach`, `session-planner`, `sprint-manager`, `scope-guardian`) may be useful for any solo creative work.

## Tier 3: Infrastructure

**Optional.** Kubernetes homelab management with GitOps workflows.

These skills assume a stack similar to:
- Talos Linux for node management
- Ceph for distributed storage
- Cilium for networking
- Flux for GitOps reconciliation

If your stack differs, these skills still provide useful patterns — just update the specific commands and references.

## Tier 4: Templates

**Optional.** Skeleton skills for deeply personal customization.

Currently includes:
- **inner-ally** — A template for building your own personal mentor/guide skill. The structure teaches the pattern (personality framework integration, quitting-pattern recognition, evidence-over-encouragement) without containing any actual personal data.

See [Creating Your Inner Ally](creating-your-inner-ally.md) for a detailed guide.

## How the Installer Uses Tiers

The `install.sh` / `install.ps1` scripts:
1. Always install Core skills (no prompt)
2. Ask if you want Game Dev skills
3. Ask if you want Infrastructure skills
4. Ask if you want Template skills

Use `--all` to install everything without prompts.

Skills are installed flat into `~/.claude/skills/` — Claude Code doesn't use the tier directories. The tiers are only for organizing the distribution.
