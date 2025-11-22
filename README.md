# LXC Manual Update Setup

Manual update command for Claude Code and system packages on LXC containers.

## Problem Solved

The automatic update script was causing login hangs due to sudo password prompts. This manual update approach gives you full control over when updates happen without any login delays or password prompt issues.

## Solution Overview

Simple manual update command that you run when needed:
- **Claude Code** - Updates to latest version via npm
- **System Packages** - Updates via apt (update && upgrade)
- **Interactive** - Prompts for sudo password when you run it
- **Clean output** - Shows progress and results in your terminal
- **On-demand** - Run updates only when you want them

## Installation

### 1. Copy Manual Update Script

```bash
cp update.sh ~/update.sh
chmod +x ~/update.sh
```

### 2. Add Alias to .bashrc

Add this line to `~/.bashrc`:

```bash
alias update='$HOME/update.sh'
```

### 3. Reload Your Shell

```bash
source ~/.bashrc
```

## Usage

Simply run:

```bash
update
```

You'll be prompted for your sudo password, then the script will:
1. Update Claude Code
2. Update system package lists
3. Upgrade all packages
4. Show you the results

## How It Works

1. **You run `update`** - Bash alias triggers `~/update.sh`
2. **Interactive sudo** - Prompts for password normally (no hanging)
3. **Update Claude Code** - Runs `sudo npm i -g @anthropic-ai/claude-code`
4. **Update System** - Runs `sudo apt update && sudo apt upgrade -y`
5. **Clear output** - See exactly what's happening in your terminal

## Files

- `update.sh` - Manual update script
- `auto-update.sh` - (Deprecated) Old automatic update script
- `sudoers-auto-update` - (Not needed for manual updates)

## Why Manual Instead of Automatic?

**Automatic updates had issues:**
- Required passwordless sudo configuration
- Could hang at login if sudo wasn't configured properly
- Hidden background processes
- Terminal I/O errors from sudo in background

**Manual updates are better:**
- No special sudo configuration needed
- No login delays or hangs
- Full visibility of what's being updated
- You choose when to update
- Simpler and more reliable

## Monitoring

Since updates run interactively in your terminal, you see everything in real-time:

```
==========================================
  System Update Script
==========================================

Updating Claude Code...
✓ Claude Code updated successfully

Updating system packages...
✓ Package list updated

Upgrading packages...
✓ System packages upgraded successfully

==========================================
  Update completed at Sat Nov 22 06:15:00 AM CET 2025
==========================================
```

## Troubleshooting

### Command Not Found

1. Check if script exists:
   ```bash
   ls -l ~/update.sh
   ```

2. Check .bashrc alias:
   ```bash
   grep "update" ~/.bashrc
   ```

3. Reload shell:
   ```bash
   source ~/.bashrc
   ```

### Permission Denied

```bash
chmod +x ~/update.sh
```

### Sudo Password Issues

The script uses normal sudo, so you need to be in the sudo group:
```bash
groups
```
Should include `sudo` in the output.

## Environment

- **Tested on:** Debian 12 (Bookworm) LXC
- **Claude Code:** 2.0.50+
- **Node.js:** 24.x
- **User:** slesz (sudo group member)

## Migration from Auto-Update

If you were using the old auto-update setup:

1. The auto-update script has been disabled in `.bashrc`
2. Old files remain for reference:
   - `~/.auto-update.sh` - Old automatic script
   - `~/.auto-update.log` - Old log file
3. You can safely delete them if desired:
   ```bash
   rm ~/.auto-update.sh ~/.auto-update.log
   ```

## Created

- **Original Date:** 2025-11-22 (Auto-update)
- **Updated Date:** 2025-11-22 (Manual update)
- **Author:** Setup with Claude Code

## License

Public domain - use freely for homelab setups
