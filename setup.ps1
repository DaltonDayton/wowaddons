# WoW Addon Management Script
# Manages ElvUI and ToxiUI git repos with symlinks for two-way sync

param(
    [string]$Action = "setup",
    [string]$WoWPath = "$env:ProgramFiles(x86)\World of Warcraft\_retail_"
)

# Configuration
$WoWInterface = "$WoWPath\Interface"
$WoWWTF = "$WoWPath\WTF"
$RepoInterface = ".\Interface"
$RepoWTF = ".\WTF"
$RepoPath = (Get-Location).Path

# Helper functions
function Write-Info($Message) { Write-Host "[INFO] $Message" -ForegroundColor Green }
function Write-Warn($Message) { Write-Host "[WARN] $Message" -ForegroundColor Yellow }
function Write-Error($Message) { Write-Host "[ERROR] $Message" -ForegroundColor Red }

# Check if running as administrator
function Test-AdminPrivileges {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

# Ensure admin privileges for symlink operations
function Ensure-AdminPrivileges {
    if (-not (Test-AdminPrivileges)) {
        Write-Error "This script requires administrator privileges to create symlinks."
        Write-Error "Please run PowerShell as Administrator and try again."
        exit 1
    }
}

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

# Create external symlinks (WoW directories to repository)
function Create-ExternalSymlinks {
    Ensure-AdminPrivileges

    Write-Info "Creating external symlinks (WoW → Repository)..."

    # Check if WoW path exists
    if (-not (Test-Path $WoWPath)) {
        Write-Error "WoW installation not found: $WoWPath"
        Write-Error "Use -WoWPath parameter to specify correct path"
        return
    }

    # Backup existing WoW directories if they exist and aren't symlinks
    foreach ($dir in @($WoWInterface, $WoWWTF)) {
        if (Test-Path $dir) {
            $item = Get-Item $dir
            if ($item.LinkType -ne "SymbolicLink") {
                $backupPath = "$dir.backup"
                Write-Warn "Backing up existing directory: $dir → $backupPath"
                if (Test-Path $backupPath) { Remove-Item $backupPath -Recurse -Force }
                Move-Item $dir $backupPath
            } else {
                Write-Info "Existing symlink found, removing: $dir"
                Remove-Item $dir -Force
            }
        }
    }

    # Create symlinks from WoW to repository
    if (Test-Path $RepoInterface) {
        Write-Info "Creating Interface symlink: $WoWInterface → $RepoInterface"
        New-Item -ItemType SymbolicLink -Path $WoWInterface -Target (Resolve-Path $RepoInterface).Path -Force | Out-Null
    }

    if (Test-Path $RepoWTF) {
        Write-Info "Creating WTF symlink: $WoWWTF → $RepoWTF"
        New-Item -ItemType SymbolicLink -Path $WoWWTF -Target (Resolve-Path $RepoWTF).Path -Force | Out-Null
    }

    Write-Info "External symlinks created successfully!"
}

# Create internal symlinks (Interface/AddOns to git repos)
function Create-InternalSymlinks {
    Ensure-AdminPrivileges

    Write-Info "Creating internal symlinks (AddOns → Git Repos)..."

    # Ensure Interface/AddOns directory exists
    $AddOnsPath = "$RepoInterface\AddOns"
    if (-not (Test-Path $AddOnsPath)) {
        Write-Info "Creating Interface/AddOns directory..."
        New-Item -ItemType Directory -Path $AddOnsPath -Force | Out-Null
    }

    # Create symlinks for ElvUI components
    $symlinks = @(
        @{ Name = "ElvUI"; Target = "..\..\ElvUI\ElvUI" },
        @{ Name = "ElvUI_Libraries"; Target = "..\..\ElvUI\ElvUI_Libraries" },
        @{ Name = "ElvUI_Options"; Target = "..\..\ElvUI\ElvUI_Options" },
        @{ Name = "ElvUI_ToxiUI"; Target = "..\..\toxiui" }
    )

    foreach ($link in $symlinks) {
        $linkPath = "$AddOnsPath\$($link.Name)"
        $targetPath = "$RepoPath\$($link.Target -replace '\.\.\\.\.\\')"

        # Remove existing item if it exists
        if (Test-Path $linkPath) {
            Write-Info "Removing existing item: $linkPath"
            Remove-Item $linkPath -Recurse -Force
        }

        # Check if target exists
        if (Test-Path $targetPath) {
            Write-Info "Creating symlink: $($link.Name) → $($link.Target)"
            New-Item -ItemType SymbolicLink -Path $linkPath -Target $targetPath -Force | Out-Null
        } else {
            Write-Warn "Target not found, skipping: $targetPath"
        }
    }

    Write-Info "Internal symlinks created successfully!"
}

# Verify symlinks are working correctly
function Test-Symlinks {
    Write-Info "Verifying symlink configuration..."
    $allGood = $true

    # Check external symlinks
    $externalLinks = @(
        @{ Path = $WoWInterface; Target = $RepoInterface; Name = "Interface" },
        @{ Path = $WoWWTF; Target = $RepoWTF; Name = "WTF" }
    )

    foreach ($link in $externalLinks) {
        if (Test-Path $link.Path) {
            $item = Get-Item $link.Path
            if ($item.LinkType -eq "SymbolicLink") {
                $actualTarget = $item.Target
                $expectedTarget = (Resolve-Path $link.Target -ErrorAction SilentlyContinue).Path
                if ($actualTarget -eq $expectedTarget) {
                    Write-Info "✓ External symlink OK: $($link.Name)"
                } else {
                    Write-Error "✗ External symlink target mismatch: $($link.Name)"
                    Write-Error "  Expected: $expectedTarget"
                    Write-Error "  Actual: $actualTarget"
                    $allGood = $false
                }
            } else {
                Write-Error "✗ Not a symlink: $($link.Path)"
                $allGood = $false
            }
        } else {
            Write-Error "✗ Missing external symlink: $($link.Name)"
            $allGood = $false
        }
    }

    # Check internal symlinks
    $AddOnsPath = "$RepoInterface\AddOns"
    if (Test-Path $AddOnsPath) {
        $internalLinks = @(
            @{ Name = "ElvUI"; Target = "ElvUI\ElvUI" },
            @{ Name = "ElvUI_Libraries"; Target = "ElvUI\ElvUI_Libraries" },
            @{ Name = "ElvUI_Options"; Target = "ElvUI\ElvUI_Options" },
            @{ Name = "ElvUI_ToxiUI"; Target = "toxiui" }
        )

        foreach ($link in $internalLinks) {
            $linkPath = "$AddOnsPath\$($link.Name)"
            $targetPath = "$RepoPath\$($link.Target)"

            if (Test-Path $linkPath) {
                $item = Get-Item $linkPath
                if ($item.LinkType -eq "SymbolicLink") {
                    if (Test-Path $targetPath) {
                        Write-Info "✓ Internal symlink OK: $($link.Name)"
                    } else {
                        Write-Error "✗ Internal symlink target missing: $($link.Name) → $targetPath"
                        $allGood = $false
                    }
                } else {
                    Write-Error "✗ Not a symlink: $linkPath"
                    $allGood = $false
                }
            } else {
                Write-Warn "✗ Missing internal symlink: $($link.Name)"
                $allGood = $false
            }
        }
    } else {
        Write-Error "✗ Interface/AddOns directory not found"
        $allGood = $false
    }

    if ($allGood) {
        Write-Info "All symlinks are configured correctly!"
    } else {
        Write-Error "Some symlinks need attention. Run 'setup' to fix."
    }

    return $allGood
}

# Show help
function Show-Help {
    Write-Host "WoW Addon Management Script"
    Write-Host ""
    Write-Host "Usage: .\setup.ps1 [-Action <command>] [-WoWPath <path>]"
    Write-Host ""
    Write-Host "Commands:"
    Write-Host "  setup     - Clone repositories and create all symlinks (default)"
    Write-Host "  update    - Pull latest changes from git repositories"
    Write-Host "  symlinks  - Create/recreate all symlinks"
    Write-Host "  verify    - Verify all symlinks are working correctly"
    Write-Host "  help      - Show this help message"
    Write-Host ""
    Write-Host "Parameters:"
    Write-Host "  -WoWPath  - WoW installation path (default: Program Files (x86)\World of Warcraft\_retail_)"
    Write-Host ""
    Write-Host "Examples:"
    Write-Host "  .\setup.ps1                                    # Initial setup"
    Write-Host "  .\setup.ps1 -Action update                     # Update addons"
    Write-Host "  .\setup.ps1 -Action verify                     # Check symlinks"
    Write-Host "  .\setup.ps1 -Action symlinks -WoWPath 'D:\Games\World of Warcraft\_retail_'"
    Write-Host ""
    Write-Host "Note: This script requires administrator privileges to create symlinks."
}

# Main script logic
switch ($Action.ToLower()) {
    "setup" {
        Setup-Repos
        Create-ExternalSymlinks
        Create-InternalSymlinks
        Write-Info "Setup complete! Symlinks created for two-way sync."
    }
    "update" {
        Update-Addons
        Write-Info "Addons updated! Changes are automatically synced via symlinks."
    }
    "symlinks" {
        Create-ExternalSymlinks
        Create-InternalSymlinks
    }
    "verify" { Test-Symlinks }
    "help" { Show-Help }
    default {
        Write-Error "Unknown command: $Action"
        Show-Help
        exit 1
    }
}