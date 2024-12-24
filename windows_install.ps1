# Update and initialize git submodules
git submodule update --init --recursive
if ($LASTEXITCODE -ne 0) {
    Write-Host "Failed to initialize git submodules. Please ensure Git is installed and configured correctly."
    exit 1
}

# Default WoW _retail_ directory
$defaultWowPath = "C:\Program Files (x86)\World of Warcraft\_retail_"

# Check if the default path exists
if (Test-Path -Path $defaultWowPath -PathType Container) {
    $wowRetailPath = $defaultWowPath
    Write-Host "Using default WoW _retail_ directory: $wowRetailPath"
} else {
    # Prompt for the WoW _retail_ directory if the default is not valid
    $wowRetailPath = Read-Host "Default path not found. Enter the path to your WoW _retail_ directory"
    if (-Not (Test-Path -Path $wowRetailPath -PathType Container)) {
        Write-Host "The provided path does not exist. Please ensure you have the correct path."
        exit 1
    }
}

# Define the paths to the Interface and WTF directories
$interfaceDir = Join-Path $wowRetailPath "Interface"
$wtfDir = Join-Path $wowRetailPath "WTF"

# Function to check if a symbolic link exists and points to the correct target
function Is-Symlink {
    param (
        [string]$LinkPath,
        [string]$TargetPath
    )
    if ((Test-Path $LinkPath) -and (Get-Item $LinkPath).Attributes -match "ReparsePoint") {
        return ((Resolve-Path $LinkPath).Path -eq (Resolve-Path $TargetPath).Path)
    }
    return $false
}

# Function to create symbolic links idempotently
function Create-Symlink {
    param (
        [string]$LinkPath,
        [string]$TargetPath
    )

    if (Is-Symlink -LinkPath $LinkPath -TargetPath $TargetPath) {
        Write-Host "Symlink already exists and is correct: $LinkPath -> $TargetPath"
    } else {
        # Remove existing link or file if necessary
        if (Test-Path $LinkPath) {
            Remove-Item $LinkPath -Force -Recurse
        }
        New-Item -ItemType SymbolicLink -Path $LinkPath -Target $TargetPath
        Write-Host "Created symlink: $LinkPath -> $TargetPath"
    }
}

# Create symlinks for Interface and WTF directories
Create-Symlink -LinkPath $interfaceDir -TargetPath (Join-Path (Get-Location) "Interface")
Create-Symlink -LinkPath $wtfDir -TargetPath (Join-Path (Get-Location) "WTF")

# Define AddOns paths
$addonsPath = Join-Path $interfaceDir "AddOns"
$toxuiPath = Join-Path (Get-Location) "ToxiUI"
$elvuiPath = Join-Path (Get-Location) "ElvUI"

# Ensure AddOns directory exists
if (-Not (Test-Path $addonsPath -PathType Container)) {
    New-Item -ItemType Directory -Path $addonsPath
    Write-Host "Created AddOns directory: $addonsPath"
} else {
    Write-Host "AddOns directory already exists: $addonsPath"
}

# Create symlinks for ToxiUI and ElvUI addons
Create-Symlink -LinkPath (Join-Path $addonsPath "ElvUI_ToxiUI") -TargetPath $toxuiPath
Create-Symlink -LinkPath (Join-Path $addonsPath "ElvUI") -TargetPath (Join-Path $elvuiPath "ElvUI")
Create-Symlink -LinkPath (Join-Path $addonsPath "ElvUI_Libraries") -TargetPath (Join-Path $elvuiPath "ElvUI_Libraries")
Create-Symlink -LinkPath (Join-Path $addonsPath "ElvUI_Options") -TargetPath (Join-Path $elvuiPath "ElvUI_Options")

# Extract the path up to drive_c\
$driveCPath = $wowRetailPath -replace "(.*drive_c\\).*", '$1'

# Symlink battlenet_tsm.bat to the extracted drive_c path
$battlenetTSMPath = Join-Path $driveCPath "battlenet_tsm.bat"
Create-Symlink -LinkPath $battlenetTSMPath -TargetPath (Join-Path (Get-Location) "battlenet_tsm.bat")

Write-Host "Installation complete. All operations were idempotent and safe."

