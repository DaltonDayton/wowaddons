# CLAUDE.md

This file provides guidance to Claude Code when working with this WoW addon management repository.

## Repository Purpose

This repository manages World of Warcraft addons using a simplified symlink-based approach. It combines git repositories for specific addons (ElvUI, ToxiUI) with CurseForge addon management, using Windows symlinks to create seamless two-way synchronization between WoW and the version-controlled addon files.

## Key Architecture

### Symlink-Based Two-Tier System
The system uses Windows symbolic links in two layers:

1. **External Symlinks** (WoW Installation → Repository):
   - `C:\Program Files (x86)\World of Warcraft\_retail_\Interface` → `repo\Interface`
   - `C:\Program Files (x86)\World of Warcraft\_retail_\WTF` → `repo\WTF`

2. **Internal Symlinks** (Interface/AddOns → Git Repositories):
   - `Interface\AddOns\ElvUI` → `ElvUI\ElvUI`
   - `Interface\AddOns\ElvUI_Libraries` → `ElvUI\ElvUI_Libraries`
   - `Interface\AddOns\ElvUI_Options` → `ElvUI\ElvUI_Options`
   - `Interface\AddOns\ElvUI_ToxiUI` → `toxiui`

### Git Repository Structure
- **Main repository**: Tracks `Interface/`, `WTF/`, and management scripts
- **ElvUI/**: Separate git repository (ignored by main repo via .gitignore)
- **toxiui/**: Separate git repository (ignored by main repo via .gitignore)

## Essential Commands

### Initial Setup
```powershell
# Must run as Administrator (Windows symlinks requirement)
.\install.ps1

# Custom WoW path if needed
.\install.ps1 -WoWPath "D:\Games\World of Warcraft\_retail_"
```

### Addon Updates
```bash
# Update ElvUI
cd ElvUI && git pull

# Update ToxiUI
cd toxiui && git pull
```

### Settings Management
```bash
# Addon settings are automatically synced via symlinks
# Commit when you want to save setting changes
git add WTF/
git commit -m "Update addon settings"
```

## Critical Technical Details

### Windows Symlink Requirements
- **Administrator privileges required**: Windows NTFS symlinks need admin rights
- **PowerShell execution**: The install script must run in PowerShell as Administrator
- **Idempotent design**: `install.ps1` can be run multiple times safely

### Git Repository Isolation
- `.gitignore` contains `ElvUI/` and `toxiui/` to prevent nested git issues
- Each addon repository operates independently
- Main repository only tracks settings, interface structure, and scripts

### Two-Way Synchronization
- **WoW → Git**: Any changes WoW makes to addon files appear immediately in git repos
- **Git → WoW**: Any git updates are immediately available to WoW
- **No file copying**: All operations use symlinks for real-time sync

## Development Workflow

### Adding New Git-Managed Addons
1. Clone the addon repository: `git clone <repo-url> <addon-name>`
2. Add directory to `.gitignore`: `echo "<addon-name>/" >> .gitignore`
3. Create symlink in `Interface/AddOns/`:
   ```powershell
   New-Item -ItemType SymbolicLink -Path "Interface\AddOns\<AddonName>" -Target "<addon-name>"
   ```

### Troubleshooting Symlinks
- **Verify symlinks**: Use `Get-Item <path> | Select-Object LinkType, Target` in PowerShell
- **Recreate if broken**: Re-run `.\install.ps1` as Administrator
- **Check permissions**: Ensure PowerShell is running as Administrator

### Backup System
The install script automatically backs up existing WoW directories:
- `Interface` → `Interface.backup`
- `WTF` → `WTF.backup`

## Important Constraints

### Windows-Specific Design
- **NTFS filesystem required**: Symlinks don't work on FAT32
- **Administrator mandatory**: No workaround for Windows symlink permissions
- **PowerShell preferred**: Batch files don't handle complex symlink operations as well

### Git Considerations
- **Never commit git repos**: ElvUI/ and toxiui/ must remain in .gitignore
- **Symlinks in git**: The symlinks in Interface/AddOns/ are NOT committed (they're created by the install script)
- **Only track settings**: Main repo should only version control WTF/ and Interface/ contents

## Maintenance Commands

### Repository Health
```bash
# Check git status of main repo
git status

# Check git status of addon repos
cd ElvUI && git status && cd ..
cd toxiui && git status && cd ..
```

### Symlink Verification
```powershell
# Check if symlinks are working
Get-Item "C:\Program Files (x86)\World of Warcraft\_retail_\Interface" | Select-Object LinkType, Target
Get-Item "Interface\AddOns\ElvUI" | Select-Object LinkType, Target
```

## Common Issues and Solutions

### Symlinks Not Working
- **Cause**: Not running as Administrator
- **Solution**: Always run PowerShell as Administrator for symlink operations

### Addon Updates Not Syncing
- **Cause**: Symlinks broken or not created
- **Solution**: Re-run `.\install.ps1` as Administrator

### Git Conflicts in Addon Repos
- **Cause**: Local addon modifications conflict with upstream
- **Solution**: Use `git stash` to save local changes, then `git pull`

## Best Practices

1. **Always run installer as Administrator**
2. **Commit WTF changes regularly** to save addon settings
3. **Update addon repos frequently** to get latest versions
4. **Don't modify .gitignore** without understanding the repository isolation
5. **Backup before major changes** (installer does this automatically)

## Architecture Benefits

- **Simplified management**: No complex git subtrees or submodules
- **Real-time sync**: Changes flow immediately in both directions
- **Version control**: All settings and changes are trackable
- **CurseForge compatibility**: Standard addon workflow unchanged
- **Safe setup**: Automatic backups prevent data loss