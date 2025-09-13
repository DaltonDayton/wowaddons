# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Purpose

This repository manages World of Warcraft addons using git subtrees and Windows symlinks for centralized addon management. The system uses two main addon repositories as git subtrees (ElvUI and ToxiUI) and creates a symlinked structure that allows WoW to load addons from this centralized location.

## Key Architecture

### Git Subtree Structure
- `ElvUI/` - Git subtree of the ElvUI repository (main branch)
- `ToxiUI/` - Git subtree of the ToxiUI repository (development branch)
- Both subtrees are managed independently and can be updated without affecting each other

### Symlink Architecture
The system uses a two-tier symlink approach:

1. **WoW-level symlinks**: WoW's `Interface` and `WTF` directories are symlinked to this repository's directories
2. **Internal addon symlinks**: Individual addon folders are symlinked from `Interface/AddOns/` to the actual addon locations:
   - `Interface/AddOns/ElvUI` → `ElvUI/ElvUI/`
   - `Interface/AddOns/ElvUI_Libraries` → `ElvUI/ElvUI_Libraries/`
   - `Interface/AddOns/ElvUI_Options` → `ElvUI/ElvUI_Options/`
   - `Interface/AddOns/ElvUI_ToxiUI` → `ToxiUI/`

### Critical Git/Windows Symlink Issue
**Important**: Git for Windows converts symlinks to Windows shortcuts (.lnk files) when cloning, which WoW cannot follow. The setup script automatically detects and fixes this by recreating proper Windows symlinks.

## Essential Commands

### Setup (New Installation)
```powershell
# Run as Administrator - handles everything automatically
.\setup-addons.ps1

# Custom WoW path
.\setup-addons.ps1 -WoWPath "D:\Games\World of Warcraft\_retail_"

# Skip ElvUI dependency setup
.\setup-addons.ps1 -SkipDownload
```

### Update Addons
```bash
# Update ElvUI to latest from git
git subtree pull --prefix=ElvUI https://github.com/tukui-org/ElvUI main --squash

# Update ToxiUI to latest from git  
git subtree pull --prefix=ToxiUI https://github.com/Toxicom/toxiui development --squash
```

### ElvUI Dependency Management
ElvUI requires external libraries (Ace3, LibStub, etc.) that are not in the git repository:

```powershell
# Manual dependency setup (if needed)
# 1. Download release from https://tukui.org/elvui
# 2. Extract to elvui_latest_release/
# 3. Copy dependencies:
robocopy elvui_latest_release ElvUI /E /XO
cd ElvUI
git reset --hard HEAD
cd ..
```

## Development Workflow

### Adding New Addons
1. Add as git subtree: `git subtree add --prefix=NewAddon https://github.com/repo/addon branch --squash`
2. Create symlink in `Interface/AddOns/` pointing to the new addon folder
3. Update setup script to handle the new symlink
4. Update README and documentation

### Troubleshooting Symlinks
- Always run PowerShell as Administrator for symlink operations
- Use `Get-Item $path | Select-Object LinkType, Target` to verify symlinks are proper (not shortcuts)
- The setup script's verification section checks all symlinks and reports issues

### Repository Structure
- **Root level**: Contains setup script, documentation, and top-level directories
- **Interface/AddOns/**: Contains symlinks to actual addon folders (managed by Git)
- **WTF/**: World of Warcraft settings and saved variables
- **ElvUI/**, **ToxiUI/**: Git subtrees of upstream repositories
- **elvui_latest_release/**: Temporary folder for ElvUI release dependencies (not committed)

## Important Notes

- The setup script is idempotent and safe to run multiple times
- ElvUI dependencies must come from release builds, not git repository
- Windows symlinks require Administrator privileges to create
- The system is Windows-specific due to symlink and path requirements
- WoW installation path defaults to `C:\Program Files (x86)\World of Warcraft\_retail_` but is configurable