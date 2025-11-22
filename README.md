# LXC Auto-Update Setup

Automatic updates for Claude Code and system packages on LXC containers.

## Problem Solved

Fixed the recurring Claude Code auto-update error:
```
✗ Auto-update failed · Try claude doctor or npm i -g @anthropic-ai/claude-code
```

## Solution Overview

Implemented automatic background updates that run on every login:
- **Claude Code** - Updates to latest version via npm
- **System Packages** - Updates via apt (update && upgrade)
- **No password prompts** - Configured sudoers for passwordless updates
- **Background execution** - No login delay
- **Logging** - All updates tracked in `~/.auto-update.log`

## Installation

### 1. Copy Auto-Update Script

```bash
cp auto-update.sh ~/.auto-update.sh
chmod +x ~/.auto-update.sh
```

### 2. Configure Sudoers (Passwordless Updates)

As root:

```bash
printf "slesz ALL=(ALL) NOPASSWD: /usr/bin/npm i -g @anthropic-ai/claude-code\nslesz ALL=(ALL) NOPASSWD: /usr/bin/apt update\nslesz ALL=(ALL) NOPASSWD: /usr/bin/apt upgrade -y\n" > /etc/sudoers.d/auto-update

chmod 440 /etc/sudoers.d/auto-update

visudo -c
```

**Replace `slesz` with your username if different.**

### 3. Add to .bashrc

Add these lines to `~/.bashrc`:

```bash
# Auto-update Claude Code and system packages on login
# Runs in background to avoid delaying login
# Check log at: ~/.auto-update.log
if [ -f "$HOME/.auto-update.sh" ]; then
    "$HOME/.auto-update.sh" &
fi
```

### 4. Test

```bash
# Run manually to test
bash ~/.auto-update.sh

# Check the log
cat ~/.auto-update.log
```

Expected output should show successful updates without password prompts.

## How It Works

1. **On Login** - `.bashrc` triggers `~/.auto-update.sh` in background
2. **Lock File** - Prevents multiple simultaneous updates (`/tmp/auto-update.lock`)
3. **Update Claude Code** - Runs `sudo npm i -g @anthropic-ai/claude-code`
4. **Update System** - Runs `sudo apt update && sudo apt upgrade -y`
5. **Logging** - All output logged to `~/.auto-update.log`

## Files

- `auto-update.sh` - Main update script
- `sudoers-auto-update` - Sudoers configuration template

## Security Considerations

The sudoers configuration allows **only these specific commands** to run without password:
- `/usr/bin/npm i -g @anthropic-ai/claude-code`
- `/usr/bin/apt update`
- `/usr/bin/apt upgrade -y`

This is safe for personal homelab systems and follows standard practices for automated updates.

## Monitoring

### Check Update Log

```bash
# View full log
cat ~/.auto-update.log

# View last 20 lines
tail -20 ~/.auto-update.log

# Monitor in real-time
tail -f ~/.auto-update.log
```

### Log Format

```
=== Auto-update started at Sat Nov 22 05:07:33 AM CET 2025 ===
Updating Claude Code...
[npm output]
Updating system packages...
[apt output]
=== Auto-update completed at Sat Nov 22 05:07:42 AM CET 2025 ===
```

## Troubleshooting

### Updates Not Running

1. Check if script is executable:
   ```bash
   ls -l ~/.auto-update.sh
   ```

2. Check .bashrc configuration:
   ```bash
   grep "auto-update" ~/.bashrc
   ```

3. Run manually and check for errors:
   ```bash
   bash ~/.auto-update.sh
   cat ~/.auto-update.log
   ```

### Password Prompts Still Appearing

1. Verify sudoers file exists and has correct permissions:
   ```bash
   ls -l /etc/sudoers.d/auto-update
   ```
   Should show: `-r--r----- 1 root root`

2. Validate sudoers syntax:
   ```bash
   sudo visudo -c
   ```

3. Check file ownership:
   ```bash
   sudo ls -l /etc/sudoers.d/auto-update
   ```
   Owner must be `root:root`, not your user

## Environment

- **Tested on:** Debian 12 (Bookworm) LXC
- **Claude Code:** 2.0.50+
- **Node.js:** 24.x
- **User:** slesz (sudo group member)

## Created

- **Date:** 2025-11-22
- **Author:** Automated setup with Claude Code

## License

Public domain - use freely for homelab setups
