# WoW Addon Management Script
# Manages ElvUI and ToxiUI git repos + WTF settings backup/restore

param(
    [string]$Action = "setup",
    [string]$WoWPath = "$env:ProgramFiles(x86)\World of Warcraft\_retail_"
)

# Configuration
$WoWAddOns = "$WoWPath\Interface\AddOns"
$WoWWTF = "$WoWPath\WTF"
$RepoWTF = ".\WTF"

# Helper functions
function Write-Info($Message) { Write-Host "[INFO] $Message" -ForegroundColor Green }
function Write-Warn($Message) { Write-Host "[WARN] $Message" -ForegroundColor Yellow }
function Write-Error($Message) { Write-Host "[ERROR] $Message" -ForegroundColor Red }

# Setup git repositories
function Setup-Repos {
    Write-Info "Setting up addon repositories..."

    if (-not (Test-Path "ElvUI")) {
        Write-Info "Cloning ElvUI..."
        git clone https://github.com/tukui-org/ElvUI.git
    } else {
        Write-Info "ElvUI already exists"
    }

    if (-not (Test-Path "toxiui")) {
        Write-Info "Cloning ToxiUI (development branch)..."
        git clone -b development https://github.com/Toxicom/toxiui.git
    } else {
        Write-Info "toxiui already exists"
    }
}

# Update addon repositories
function Update-Addons {
    Write-Info "Updating addon repositories..."

    if (Test-Path "ElvUI") {
        Write-Info "Updating ElvUI..."
        Push-Location ElvUI
        git pull
        Pop-Location
    } else {
        Write-Error "ElvUI directory not found. Run setup first."
        return
    }

    if (Test-Path "toxiui") {
        Write-Info "Updating ToxiUI..."
        Push-Location toxiui
        git pull
        Pop-Location
    } else {
        Write-Error "toxiui directory not found. Run setup first."
        return
    }
}

# Copy addons to WoW directory
function Copy-ToWoW {
    if (-not (Test-Path $WoWAddOns)) {
        Write-Error "WoW AddOns directory not found: $WoWAddOns"
        Write-Error "Check WoW installation or use -WoWPath parameter"
        return
    }

    Write-Info "Copying addons to WoW directory..."

    # Copy ElvUI components
    if (Test-Path "ElvUI\ElvUI") {
        Write-Info "Copying ElvUI core..."
        Copy-Item -Path "ElvUI\ElvUI" -Destination $WoWAddOns -Recurse -Force
    }

    if (Test-Path "ElvUI\ElvUI_Libraries") {
        Write-Info "Copying ElvUI Libraries..."
        Copy-Item -Path "ElvUI\ElvUI_Libraries" -Destination $WoWAddOns -Recurse -Force
    }

    if (Test-Path "ElvUI\ElvUI_Options") {
        Write-Info "Copying ElvUI Options..."
        Copy-Item -Path "ElvUI\ElvUI_Options" -Destination $WoWAddOns -Recurse -Force
    }

    # Copy ToxiUI
    if (Test-Path "toxiui") {
        Write-Info "Copying ToxiUI..."
        $ToxiUITarget = "$WoWAddOns\ElvUI_ToxiUI"
        if (Test-Path $ToxiUITarget) { Remove-Item $ToxiUITarget -Recurse -Force }
        Copy-Item -Path "toxiui" -Destination $ToxiUITarget -Recurse -Force
    }

    Write-Info "Addons copied successfully!"
}

# Backup WTF settings from WoW to repo
function Backup-Settings {
    if (-not (Test-Path $WoWWTF)) {
        Write-Error "WoW WTF directory not found: $WoWWTF"
        return
    }

    Write-Info "Backing up WTF settings from WoW..."

    if (Test-Path $RepoWTF) { Remove-Item $RepoWTF -Recurse -Force }
    Copy-Item -Path $WoWWTF -Destination $RepoWTF -Recurse -Force

    Write-Info "WTF settings backed up to $RepoWTF"
    Write-Warn "Don't forget to commit these changes to git!"
}

# Restore WTF settings from repo to WoW
function Restore-Settings {
    if (-not (Test-Path $RepoWTF)) {
        Write-Error "Repository WTF directory not found: $RepoWTF"
        Write-Error "No settings to restore. Run backup first or ensure WTF\ exists in repo."
        return
    }

    if (-not (Test-Path $WoWPath)) {
        Write-Error "WoW installation not found: $WoWPath"
        return
    }

    Write-Info "Restoring WTF settings to WoW..."

    if (Test-Path $WoWWTF) {
        Write-Warn "Backing up existing WoW WTF to WTF.backup..."
        if (Test-Path "$WoWWTF.backup") { Remove-Item "$WoWWTF.backup" -Recurse -Force }
        Move-Item $WoWWTF "$WoWWTF.backup"
    }

    Copy-Item -Path $RepoWTF -Destination $WoWWTF -Recurse -Force
    Write-Info "WTF settings restored to WoW!"
}

# Show help
function Show-Help {
    Write-Host "WoW Addon Management Script"
    Write-Host ""
    Write-Host "Usage: .\setup.ps1 [-Action <command>] [-WoWPath <path>]"
    Write-Host ""
    Write-Host "Commands:"
    Write-Host "  setup     - Clone ElvUI and ToxiUI repositories (default)"
    Write-Host "  update    - Pull latest changes and copy to WoW"
    Write-Host "  copy      - Copy current addon versions to WoW"
    Write-Host "  backup    - Backup WTF settings from WoW to repository"
    Write-Host "  restore   - Restore WTF settings from repository to WoW"
    Write-Host "  help      - Show this help message"
    Write-Host ""
    Write-Host "Parameters:"
    Write-Host "  -WoWPath  - WoW installation path (default: Program Files (x86)\World of Warcraft\_retail_)"
    Write-Host ""
    Write-Host "Examples:"
    Write-Host "  .\setup.ps1"
    Write-Host "  .\setup.ps1 -Action update"
    Write-Host "  .\setup.ps1 -Action copy -WoWPath 'D:\Games\World of Warcraft\_retail_'"
}

# Main script logic
switch ($Action.ToLower()) {
    "setup" {
        Setup-Repos
        if (Test-Path $RepoWTF) {
            Write-Info "WTF directory found, restoring settings..."
            Restore-Settings
        }
    }
    "update" {
        Update-Addons
        Copy-ToWoW
    }
    "copy" { Copy-ToWoW }
    "backup" { Backup-Settings }
    "restore" { Restore-Settings }
    "help" { Show-Help }
    default {
        Write-Error "Unknown command: $Action"
        Show-Help
        exit 1
    }
}