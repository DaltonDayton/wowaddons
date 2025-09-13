# WoW Addon Management with Git

A simplified system for managing World of Warcraft addons using git repositories and Windows symlinks for seamless two-way synchronization.

## Overview

This setup manages your WoW addons by:
- Using **git repositories** for ElvUI and ToxiUI (addon updates)
- Using **CurseForge** for other standard addons
- Using **symlinks** for automatic two-way sync between WoW and your repositories
- Tracking your **addon settings** (WTF folder) in git for easy backup/restore

## Prerequisites

- **Windows** (symlinks require NTFS filesystem)
- **Git** installed and available in PATH
- **PowerShell** with Administrator privileges
- **World of Warcraft** installed

## Installation

1. **Clone this repository** to your preferred location
2. **Run the installer as Administrator**:
   ```powershell
   # Right-click PowerShell -> "Run as Administrator"
   .\install.ps1
   ```

3. **For custom WoW path**:
   ```powershell
   .\install.ps1 -WoWPath "D:\Games\World of Warcraft\_retail_"
   ```

That's it! The script will:
- Clone ElvUI and ToxiUI repositories
- Create all necessary symlinks
- Back up your existing WoW directories safely

## How It Works

### Symlink Structure
The system uses a two-tier symlink approach:

#### External Symlinks (WoW → Repository)
```
WoW/Interface/ → repo/Interface/
WoW/WTF/       → repo/WTF/
```

#### Internal Symlinks (AddOns → Git Repos)
```
Interface/AddOns/ElvUI          → ElvUI/ElvUI/
Interface/AddOns/ElvUI_Libraries → ElvUI/ElvUI_Libraries/
Interface/AddOns/ElvUI_Options  → ElvUI/ElvUI_Options/
Interface/AddOns/ElvUI_ToxiUI   → toxiui/
```

### Result
- WoW reads/writes directly to your git repositories
- Any changes WoW makes are immediately visible in git
- You can commit addon updates and setting changes
- No manual file copying needed

## Daily Workflow

### Updating Git-Managed Addons
```powershell
# Update ElvUI
cd ElvUI
git pull

# Update ToxiUI
cd toxiui
git pull
```
Changes are automatically available to WoW via symlinks!

### Managing Other Addons
- Use **CurseForge** normally - it will update addons in `Interface/AddOns/`
- These changes are tracked in your main repository

### Backing Up Settings
```powershell
# Your WTF folder is automatically synced
# Just commit changes when you want to save them
git add WTF/
git commit -m "Update addon settings"
```

## Repository Structure

```
wowaddons/
├── .gitignore          # Ignores ElvUI/ and toxiui/
├── install.ps1         # Installation script
├── Interface/          # CurseForge addons + symlinks (tracked)
├── WTF/               # Addon settings (tracked)
├── ElvUI/             # Git repo (ignored by main repo)
└── toxiui/            # Git repo (ignored by main repo)
```

## Troubleshooting

### "Access Denied" or Symlink Errors
- **Cause**: Not running as Administrator
- **Solution**: Right-click PowerShell → "Run as Administrator"

### WoW Can't Find Addons
- **Cause**: Symlinks broken or not created
- **Solution**: Re-run `.\install.ps1` as Administrator

### Original Addons/Settings Missing
- **Cause**: Worried about data loss during setup
- **Solution**: Check for `.backup` folders in WoW directory - your data is safe!

### Git Repos Won't Update
- **Cause**: Local changes conflict with remote
- **Solution**:
  ```powershell
  cd ElvUI  # or toxiui
  git status  # Check what changed
  git stash   # Save local changes if needed
  git pull    # Update from remote
  ```

## Benefits

- ✅ **Two-way sync**: WoW updates → Git automatically
- ✅ **Version control**: Track all addon and setting changes
- ✅ **Easy updates**: Simple `git pull` to update addons
- ✅ **Safe setup**: Automatic backups before symlinking
- ✅ **CurseForge compatible**: Standard addons work normally
- ✅ **Portable settings**: Your WTF folder travels with the repo

## Important Notes

- **Admin required**: Windows symlinks need Administrator privileges
- **One-time setup**: Run installer once, then just use git normally
- **Idempotent**: Safe to re-run installer multiple times
- **Backup safety**: Original directories are preserved as `.backup`