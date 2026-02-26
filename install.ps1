# agentic-config installer for Windows (PowerShell)
# Usage: .\install.ps1 [-Force] [-DryRun] [-All]

param(
    [switch]$Force,
    [switch]$DryRun,
    [switch]$All
)

$ErrorActionPreference = "Stop"

# --- Configuration ---
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$ConfigSrc = Join-Path $ScriptDir "config"
$ClaudeDir = Join-Path $env:USERPROFILE ".claude"

# --- Helper functions ---
function Write-Info { Write-Host "[INFO] " -ForegroundColor Blue -NoNewline; Write-Host $args[0] }
function Write-Ok { Write-Host "[OK] " -ForegroundColor Green -NoNewline; Write-Host $args[0] }
function Write-Warn { Write-Host "[WARN] " -ForegroundColor Yellow -NoNewline; Write-Host $args[0] }
function Write-Err { Write-Host "[ERROR] " -ForegroundColor Red -NoNewline; Write-Host $args[0] }

function Ask-YesNo {
    param([string]$Prompt)
    if ($Force) { return $true }
    $answer = Read-Host "$Prompt [y/N]"
    return $answer -match '^[Yy]'
}

function Ask-Tier {
    param([string]$Tier, [string]$Desc, [int]$Count)
    if ($All) { return $true }
    $answer = Read-Host "  Install $Tier tier? ($Count skills - $Desc) [y/N]"
    return $answer -match '^[Yy]'
}

function Copy-SafeFile {
    param([string]$Src, [string]$Dst)
    if ($DryRun) {
        Write-Host "  [DRY RUN] Would copy: $Src -> $Dst"
    } else {
        $parent = Split-Path -Parent $Dst
        if (-not (Test-Path $parent)) { New-Item -ItemType Directory -Path $parent -Force | Out-Null }
        Copy-Item -Path $Src -Destination $Dst -Force
    }
}

function Copy-SafeDir {
    param([string]$Src, [string]$Dst)
    if ($DryRun) {
        Write-Host "  [DRY RUN] Would copy directory: $Src -> $Dst"
    } else {
        if (-not (Test-Path $Dst)) { New-Item -ItemType Directory -Path $Dst -Force | Out-Null }
        Copy-Item -Path "$Src\*" -Destination $Dst -Recurse -Force
    }
}

# --- Main ---
Write-Host ""
Write-Host "agentic-config installer" -ForegroundColor White
Write-Host "========================"
Write-Host ""
Write-Info "Platform: Windows"
Write-Info "Source: $ConfigSrc"
Write-Info "Target: $ClaudeDir"
Write-Host ""

# Check source exists
if (-not (Test-Path $ConfigSrc)) {
    Write-Err "Config source directory not found at $ConfigSrc"
    exit 1
}

# Backup existing config
if (Test-Path $ClaudeDir) {
    Write-Warn "Existing Claude config found at $ClaudeDir"

    if ($DryRun) {
        Write-Host "  [DRY RUN] Would back up existing config"
    } elseif (Ask-YesNo "Back up existing config before installing?") {
        $timestamp = Get-Date -Format "yyyyMMddHHmmss"
        $BackupDir = "$ClaudeDir.backup.$timestamp"
        Write-Info "Backing up to $BackupDir\"

        New-Item -ItemType Directory -Path $BackupDir -Force | Out-Null
        foreach ($item in @("CLAUDE.md", "settings.json", "rules", "hooks", "skills")) {
            $itemPath = Join-Path $ClaudeDir $item
            if (Test-Path $itemPath) {
                Copy-Item -Path $itemPath -Destination $BackupDir -Recurse -Force
            }
        }
        Write-Ok "Backup complete"
    }
} else {
    Write-Info "No existing config found. Creating $ClaudeDir\"
    if (-not $DryRun) {
        New-Item -ItemType Directory -Path $ClaudeDir -Force | Out-Null
    }
}

Write-Host ""

# Install CLAUDE.md
Write-Info "Installing CLAUDE.md (global instructions)..."
Copy-SafeFile (Join-Path $ConfigSrc "CLAUDE.md") (Join-Path $ClaudeDir "CLAUDE.md")
Write-Ok "CLAUDE.md installed"

# Install settings
Write-Info "Installing settings template..."
$settingsPath = Join-Path $ClaudeDir "settings.json"
if ((Test-Path $settingsPath) -and -not $Force) {
    Write-Warn "settings.json already exists"
    if (Ask-YesNo "Overwrite with template? (Your permissions will be reset)") {
        Copy-SafeFile (Join-Path $ConfigSrc "settings.template.json") $settingsPath
        Write-Ok "settings.json installed"
    } else {
        Write-Info "Keeping existing settings.json"
    }
} else {
    Copy-SafeFile (Join-Path $ConfigSrc "settings.template.json") $settingsPath
    Write-Ok "settings.json installed"
}

# Fix paths in settings.json
if (-not $DryRun -and (Test-Path $settingsPath)) {
    $content = Get-Content $settingsPath -Raw
    $homePath = $env:USERPROFILE -replace '\\', '/'
    $content = $content -replace '\$HOME', $homePath

    # Check if Git Bash is available for hook scripts
    $gitBash = Get-Command bash -ErrorAction SilentlyContinue
    if ($gitBash) {
        Write-Info "Git Bash detected - hooks will use bash"
        # Wrap .sh hook commands with bash
        $content = $content -replace '"command": "([^"]+\.sh)"', '"command": "bash $1"'
    } else {
        Write-Warn "Git Bash not found. Hook scripts may not work natively."
        Write-Warn "Install Git for Windows or create PowerShell equivalents."
    }

    Set-Content $settingsPath $content -NoNewline
    Write-Ok "Paths resolved in settings.json"
}

# Install rules
Write-Info "Installing rules..."
$rulesDir = Join-Path $ClaudeDir "rules"
if (-not $DryRun) { New-Item -ItemType Directory -Path $rulesDir -Force | Out-Null }
Get-ChildItem (Join-Path $ConfigSrc "rules") -Filter "*.md" | ForEach-Object {
    Copy-SafeFile $_.FullName (Join-Path $rulesDir $_.Name)
}
Write-Ok "Rules installed"

# Install hooks
Write-Info "Installing hooks..."
$hooksDir = Join-Path $ClaudeDir "hooks"
if (-not $DryRun) { New-Item -ItemType Directory -Path $hooksDir -Force | Out-Null }
Get-ChildItem (Join-Path $ConfigSrc "hooks") -Filter "*.sh" | ForEach-Object {
    Copy-SafeFile $_.FullName (Join-Path $hooksDir $_.Name)
}
Write-Ok "Hooks installed"

# Install skills by tier
Write-Host ""
Write-Host "Skill Tiers" -ForegroundColor White
Write-Host ""

# Core (always installed)
$coreDir = Join-Path $ConfigSrc "skills\core"
$coreCount = (Get-ChildItem $coreDir -Directory -ErrorAction SilentlyContinue).Count
Write-Info "Installing core skills ($coreCount skills - always included)..."
$skillsDir = Join-Path $ClaudeDir "skills"
if (-not $DryRun) { New-Item -ItemType Directory -Path $skillsDir -Force | Out-Null }
Get-ChildItem $coreDir -Directory | ForEach-Object {
    Copy-SafeDir $_.FullName (Join-Path $skillsDir $_.Name)
}
Write-Ok "Core skills installed"

# Game Dev (optional)
$gamedevDir = Join-Path $ConfigSrc "skills\game-dev"
if (Test-Path $gamedevDir) {
    $gamedevCount = (Get-ChildItem $gamedevDir -Directory -ErrorAction SilentlyContinue).Count
    if ($gamedevCount -gt 0 -and (Ask-Tier "game-dev" "solo game dev + ADHD workflows" $gamedevCount)) {
        Write-Info "Installing game-dev skills..."
        Get-ChildItem $gamedevDir -Directory | ForEach-Object {
            Copy-SafeDir $_.FullName (Join-Path $skillsDir $_.Name)
        }
        Write-Ok "Game-dev skills installed"
    }
}

# Infra (optional)
$infraDir = Join-Path $ConfigSrc "skills\infra"
if (Test-Path $infraDir) {
    $infraCount = (Get-ChildItem $infraDir -Directory -ErrorAction SilentlyContinue).Count
    if ($infraCount -gt 0 -and (Ask-Tier "infra" "Kubernetes homelab management" $infraCount)) {
        Write-Info "Installing infra skills..."
        Get-ChildItem $infraDir -Directory | ForEach-Object {
            Copy-SafeDir $_.FullName (Join-Path $skillsDir $_.Name)
        }
        Write-Ok "Infra skills installed"
    }
}

# Templates (optional)
$templatesDir = Join-Path $ConfigSrc "skills\templates"
if (Test-Path $templatesDir) {
    $templateCount = (Get-ChildItem $templatesDir -Directory -ErrorAction SilentlyContinue).Count
    if ($templateCount -gt 0 -and (Ask-Tier "templates" "skeleton skills for personal customization" $templateCount)) {
        Write-Info "Installing template skills..."
        Get-ChildItem $templatesDir -Directory | ForEach-Object {
            Copy-SafeDir $_.FullName (Join-Path $skillsDir $_.Name)
        }
        Write-Ok "Template skills installed"
    }
}

# Summary
Write-Host ""
Write-Host "Installation Complete" -ForegroundColor White
Write-Host "====================="
Write-Host ""
Write-Ok "Config installed to $ClaudeDir\"
Write-Host ""
Write-Host "Next Steps:" -ForegroundColor White
Write-Host "  1. Review and customize ~\.claude\CLAUDE.md with your own rules"
Write-Host "  2. Review ~\.claude\rules\skills.md to see available skills"
Write-Host "  3. Start a Claude Code session - hooks will activate automatically"
Write-Host "  4. Permissions will build up as you approve tool usage"
Write-Host ""
Write-Host "  For customization help, see: docs\customization.md"
Write-Host ""
