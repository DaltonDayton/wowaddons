#Requires -RunAsAdministrator

<#
.SYNOPSIS
    One-button setup script for WoW addon management with ElvUI and ToxiUI
    
.DESCRIPTION
    Automatically downloads ElvUI release, sets up dependencies, creates symlinks,
    and configures everything needed for the addon management system.
    
.PARAMETER WoWPath
    Custom path to WoW retail installation (default: "C:\Program Files (x86)\World of Warcraft\_retail_")
    
.PARAMETER SkipDownload
    Skip downloading ElvUI release (use existing elvui_latest_release folder)
    
.EXAMPLE
    .\setup-addons.ps1
    Default setup with automatic ElvUI download
    
.EXAMPLE
    .\setup-addons.ps1 -WoWPath "D:\Games\WoW\_retail_"
    Custom WoW path (existing directories automatically backed up if they contain files)
#>

param(
    [Parameter(Mandatory=$false)]
    [string]$WoWPath = "C:\Program Files (x86)\World of Warcraft\_retail_",
    
    [Parameter(Mandatory=$false)]
    [switch]$SkipDownload
)

# Color coding for output
function Write-Success { param($Message) Write-Host "[SUCCESS] $Message" -ForegroundColor Green }
function Write-Info { param($Message) Write-Host "[INFO] $Message" -ForegroundColor Cyan }
function Write-Warning { param($Message) Write-Host "[WARNING] $Message" -ForegroundColor Yellow }
function Write-Error { param($Message) Write-Host "[ERROR] $Message" -ForegroundColor Red }

Write-Info "Starting WoW Addon Management Setup..."

# Environment validation
Write-Info "Validating environment..."

# Check if we're in the right directory
if (-not (Test-Path "ElvUI") -or -not (Test-Path "ToxiUI") -or -not (Test-Path "Interface")) {
    Write-Error "Not in wowaddons directory or missing required folders (ElvUI, ToxiUI, Interface)"
    Write-Error "Please run this script from the wowaddons directory after cloning the repo"
    exit 1
}

# Check WoW installation path
if (-not (Test-Path $WoWPath)) {
    Write-Error "WoW installation not found at: $WoWPath"
    Write-Error "Use -WoWPath parameter to specify correct path"
    exit 1
}

# Check git availability
try {
    git --version | Out-Null
} catch {
    Write-Error "Git not found. Please install Git first."
    exit 1
}

# Check internet connectivity
Write-Info "Checking internet connectivity..."
try {
    $null = Invoke-WebRequest -Uri "https://api.github.com" -UseBasicParsing -TimeoutSec 10
} catch {
    Write-Error "No internet connection. Cannot download ElvUI release."
    exit 1
}

Write-Success "Environment validation complete"

# Handle ElvUI release dependencies
if (Test-Path "elvui_latest_release") {
    Write-Info "Using existing elvui_latest_release folder"
} else {
    Write-Warning "ElvUI release folder not found!"
    Write-Info ""
    Write-Info "Please download ElvUI manually:"
    Write-Info "1. Go to: https://tukui.org/elvui"
    Write-Info "2. Download the latest ElvUI release zip"
    Write-Info "3. Extract it to 'elvui_latest_release' folder in this directory"
    Write-Info "4. Run this script again"
    Write-Info ""
    
    if (-not $SkipDownload) {
        $confirm = Read-Host "Continue without ElvUI dependency setup? This may cause lua errors (y/N)"
        if ($confirm -ne 'y' -and $confirm -ne 'Y') {
            Write-Info "Setup paused. Please download ElvUI release and run script again."
            exit 0
        }
        Write-Warning "Continuing without ElvUI dependency setup - may cause issues"
        $SkipDownload = $true
    } else {
        Write-Info "Skipping ElvUI dependency setup as requested"
    }
}

# Copy dependencies and reset git state
if (-not $SkipDownload -and (Test-Path "elvui_latest_release")) {
    Write-Info "Setting up ElvUI dependencies..."
    
    try {
        # Copy release dependencies to git version
        Write-Info "Copying dependencies from release to git version..."
        robocopy "elvui_latest_release" "ElvUI" /E /XO /NFL /NDL /NJH /NJS | Out-Null
        
        # Reset git state to clean up any conflicts
        Set-Location "ElvUI"
        git reset --hard HEAD | Out-Null
        Set-Location ".."
        
        Write-Success "ElvUI dependencies configured"
        
    } catch {
        Write-Error "Failed to setup ElvUI dependencies: $($_.Exception.Message)"
        exit 1
    }
} else {
    Write-Info "Skipping ElvUI dependency setup"
    Write-Warning "ElvUI may not work correctly without release dependencies"
}

# Create symlinks
Write-Info "Creating WoW symlinks..."

$interfacePath = Join-Path $WoWPath "Interface"
$wtfPath = Join-Path $WoWPath "WTF"
$targetInterfacePath = Join-Path (Get-Location) "Interface"
$targetWTFPath = Join-Path (Get-Location) "WTF"

# Smart handling of existing directories with automatic backup
function Handle-ExistingDirectory {
    param($Path, $TargetPath, $Name)
    
    if (Test-Path $Path) {
        $item = Get-Item $Path
        
        # Check if it's already a symlink pointing to the right place
        if ($item.LinkType -eq "SymbolicLink") {
            if ($item.Target -eq $TargetPath) {
                Write-Info "$Name symlink already exists and points to correct target"
                return $false  # No need to create
            } else {
                Write-Info "Removing $Name symlink pointing to wrong target: $($item.Target)"
                Remove-Item $Path -Force
                return $true   # Need to create new symlink
            }
        } else {
            # It's a real directory - check if it has files
            $hasFiles = (Get-ChildItem $Path -Recurse -ErrorAction SilentlyContinue | Measure-Object).Count -gt 0
            
            if ($hasFiles) {
                $backupPath = "${Path}_backup"
                # If backup already exists, add timestamp
                if (Test-Path $backupPath) {
                    $backupPath = "${Path}_backup_$(Get-Date -Format 'yyyyMMdd-HHmmss')"
                }
                
                Write-Info "Backing up existing $Name directory with files to: $backupPath"
                Move-Item $Path $backupPath
                return $true   # Need to create symlink
            } else {
                Write-Info "Removing empty $Name directory"
                Remove-Item $Path -Recurse -Force
                return $true   # Need to create symlink
            }
        }
    } else {
        return $true  # Directory doesn't exist, need to create symlink
    }
}

# Handle existing directories intelligently
Write-Info "Checking existing WoW directories..."

# Handle Interface directory
$needInterfaceSymlink = Handle-ExistingDirectory -Path $interfacePath -TargetPath $targetInterfacePath -Name "Interface"

# Handle WTF directory  
$needWTFSymlink = Handle-ExistingDirectory -Path $wtfPath -TargetPath $targetWTFPath -Name "WTF"

# Create symlinks only if needed
try {
    if ($needInterfaceSymlink) {
        Write-Info "Creating Interface symlink..."
        New-Item -ItemType SymbolicLink -Path $interfacePath -Target $targetInterfacePath | Out-Null
    }
    
    if ($needWTFSymlink) {
        Write-Info "Creating WTF symlink..."
        New-Item -ItemType SymbolicLink -Path $wtfPath -Target $targetWTFPath | Out-Null
    }
    
    if ($needInterfaceSymlink -or $needWTFSymlink) {
        Write-Success "Symlinks created successfully"
    } else {
        Write-Success "Symlinks already configured correctly"
    }
    
} catch {
    Write-Error "Failed to create symlinks: $($_.Exception.Message)"
    Write-Error "Make sure you're running PowerShell as Administrator"
    exit 1
}

# Verification
Write-Info "Verifying setup..."

$errors = @()

# Check symlinks exist and work
if (-not (Test-Path $interfacePath -PathType Container)) {
    $errors += "Interface symlink not working"
}

if (-not (Test-Path $wtfPath -PathType Container)) {
    $errors += "WTF symlink not working"
}

# Check addon folders are accessible
$addonPaths = @(
    (Join-Path $interfacePath "AddOns\ElvUI"),
    (Join-Path $interfacePath "AddOns\ElvUI_Libraries"),
    (Join-Path $interfacePath "AddOns\ElvUI_Options"),
    (Join-Path $interfacePath "AddOns\ElvUI_ToxiUI")
)

foreach ($path in $addonPaths) {
    if (-not (Test-Path $path)) {
        $errors += "Addon folder not accessible: $path"
    }
}

if ($errors.Count -eq 0) {
    Write-Success "Setup verification passed!"
    Write-Info ""
    Write-Success "WoW Addon Management setup complete!"
    Write-Info ""
    Write-Info "Next steps:"
    Write-Info "1. Launch World of Warcraft"
    Write-Info "2. Go to Character Select -> AddOns"
    Write-Info "3. Enable ElvUI and ToxiUI addons"
    Write-Info "4. Enter game and enjoy!"
    Write-Info ""
    Write-Info "To update addons in the future, use: git subtree pull commands"
    Write-Info "See README.md for update instructions"
} else {
    Write-Error "Setup verification failed:"
    foreach ($error in $errors) {
        Write-Error "  - $error"
    }
    Write-Info ""
    Write-Info "Troubleshooting tips:"
    Write-Info "1. Make sure you ran PowerShell as Administrator"
    Write-Info "2. Check that WoW path is correct: $WoWPath"
    Write-Info "3. Verify symlinks were created properly"
    exit 1
}
