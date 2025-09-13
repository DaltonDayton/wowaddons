# WoW Addon Installation Script
# Clones git repos and creates symlinks for two-way sync

param([string]$WoWPath = "$env:ProgramFiles(x86)\World of Warcraft\_retail_")

# Check admin privileges (required for symlinks)
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "Error: Administrator privileges required for symlinks" -ForegroundColor Red
    Write-Host "Please run PowerShell as Administrator" -ForegroundColor Yellow
    exit 1
}

Write-Host "Installing WoW addons with symlinks..." -ForegroundColor Green

# Clone repositories if they don't exist
if (-not (Test-Path "ElvUI")) {
    Write-Host "Cloning ElvUI..." -ForegroundColor Cyan
    git clone https://github.com/tukui-org/ElvUI.git
}

if (-not (Test-Path "toxiui")) {
    Write-Host "Cloning ToxiUI..." -ForegroundColor Cyan
    git clone -b development https://github.com/Toxicom/toxiui.git
}

# Verify WoW installation
if (-not (Test-Path $WoWPath)) {
    Write-Host "Error: WoW not found at: $WoWPath" -ForegroundColor Red
    Write-Host "Use: .\install.ps1 -WoWPath 'Your\WoW\Path'" -ForegroundColor Yellow
    exit 1
}

$RepoPath = Get-Location
$WoWInterface = "$WoWPath\Interface"
$WoWWTF = "$WoWPath\WTF"

# Create external symlinks (backup existing directories first)
foreach ($link in @(@{Wow = $WoWInterface; Repo = ".\Interface"}, @{Wow = $WoWWTF; Repo = ".\WTF"})) {
    if (Test-Path $link.Wow) {
        $item = Get-Item $link.Wow
        if ($item.LinkType -ne "SymbolicLink") {
            Write-Host "Backing up existing directory: $($link.Wow)" -ForegroundColor Yellow
            Move-Item $link.Wow "$($link.Wow).backup" -Force
        } else {
            Remove-Item $link.Wow -Force
        }
    }

    if (Test-Path $link.Repo) {
        Write-Host "Creating symlink: $($link.Wow) -> $(Resolve-Path $link.Repo)" -ForegroundColor Cyan
        New-Item -ItemType SymbolicLink -Path $link.Wow -Target (Resolve-Path $link.Repo).Path -Force | Out-Null
    }
}

# Create Interface/AddOns directory if needed
$AddOnsPath = ".\Interface\AddOns"
if (-not (Test-Path $AddOnsPath)) {
    New-Item -ItemType Directory -Path $AddOnsPath -Force | Out-Null
}

# Create internal symlinks
$symlinks = @(
    @{Name = "ElvUI"; Target = "ElvUI\ElvUI"},
    @{Name = "ElvUI_Libraries"; Target = "ElvUI\ElvUI_Libraries"},
    @{Name = "ElvUI_Options"; Target = "ElvUI\ElvUI_Options"},
    @{Name = "ElvUI_ToxiUI"; Target = "toxiui"}
)

foreach ($link in $symlinks) {
    $linkPath = "$AddOnsPath\$($link.Name)"
    $targetPath = "$RepoPath\$($link.Target)"

    if (Test-Path $linkPath) {
        Remove-Item $linkPath -Recurse -Force
    }

    if (Test-Path $targetPath) {
        Write-Host "Creating addon symlink: $($link.Name)" -ForegroundColor Cyan
        New-Item -ItemType SymbolicLink -Path $linkPath -Target $targetPath -Force | Out-Null
    }
}

Write-Host "Installation complete! Addon changes will sync automatically." -ForegroundColor Green