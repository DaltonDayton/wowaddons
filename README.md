# WoW Addon Management

This repository manages World of Warcraft addons using git subtrees and symlinks for easy updates and centralized configuration.

## Quick Setup (New Users)

### Prerequisites
- Windows with PowerShell
- World of Warcraft Retail installation
- Git

### Setup Steps

1. **Clone this repository**
   ```bash
   git clone <your-repo-url> C:\wowaddons
   cd C:\wowaddons
   ```

2. **Download ElvUI dependencies**
   - Download the latest ElvUI release from [ElvUI Releases](https://github.com/tukui-org/ElvUI/releases)
   - Extract to `./elvui_latest_release/`
   - Copy dependencies to resolve missing libraries:
   ```powershell
   robocopy elvui_latest_release ElvUI /E /XO
   cd ElvUI
   git reset --hard HEAD
   cd ..
   ```

3. **Create WoW symlinks** (Run PowerShell as Administrator)
   ```powershell
   New-Item -ItemType SymbolicLink -Path "C:\Program Files (x86)\World of Warcraft\_retail_\Interface" -Target "C:\wowaddons\Interface"
   New-Item -ItemType SymbolicLink -Path "C:\Program Files (x86)\World of Warcraft\_retail_\WTF" -Target "C:\wowaddons\WTF"
   ```

4. **Done!** Launch WoW and your addons should be available.

## Updating Addons

### Update ElvUI
```bash
git subtree pull --prefix=ElvUI https://github.com/tukui-org/ElvUI main --squash
```

After updating ElvUI, you may need to repeat step 2 from setup if new dependencies were added.

### Update ToxiUI
```bash
git subtree pull --prefix=ToxiUI https://github.com/Toxicom/toxiui development --squash
```

## Repository Structure

```
C:\wowaddons\
├── Interface/
│   └── AddOns/
│       ├── ElvUI -> ../../ElvUI/ElvUI/
│       ├── ElvUI_Libraries -> ../../ElvUI/ElvUI_Libraries/
│       ├── ElvUI_Options -> ../../ElvUI/ElvUI_Options/
│       └── ElvUI_ToxiUI -> ../../ToxiUI/
├── ElvUI/ (git subtree)
├── ToxiUI/ (git subtree)
├── WTF/ (addon settings & saved variables)
└── README.md
```

## How It Works

- **Git subtrees** track upstream addon repositories for easy updates
- **Internal symlinks** connect addon folders to the Interface/AddOns directory
- **External symlink** connects WoW's Interface directory to our managed Interface directory
- **Dependencies** are copied from release versions to resolve build requirements

## Troubleshooting

### ElvUI not loading / Lua errors
The git version requires dependencies from a release build. Make sure you've completed step 2 of the setup.

### Symlinks not working
- Ensure PowerShell is run as Administrator when creating the WoW symlink
- Verify paths are correct for your WoW installation

### Updates not working
- Use `git subtree pull` commands as shown above
- After ElvUI updates, re-copy dependencies if needed

## Development

See `SETUP_PLAN.md` for detailed setup process and future phases (ToxiUI, WTF directory, automation scripts).