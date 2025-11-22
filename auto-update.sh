#!/bin/bash
# Automatic update script for Claude Code and system packages
# Runs on login to keep everything up to date

LOG_FILE="/home/slesz/.auto-update.log"
LOCK_FILE="/tmp/auto-update.lock"

# Prevent multiple simultaneous updates
if [ -f "$LOCK_FILE" ]; then
    exit 0
fi

touch "$LOCK_FILE"

# Function to clean up lock file
cleanup() {
    rm -f "$LOCK_FILE"
}
trap cleanup EXIT

# Start logging
echo "=== Auto-update started at $(date) ===" >> "$LOG_FILE" 2>&1

# Update Claude Code (requires sudo for global npm package)
echo "Updating Claude Code..." >> "$LOG_FILE" 2>&1
sudo npm i -g @anthropic-ai/claude-code >> "$LOG_FILE" 2>&1

# Update system packages
echo "Updating system packages..." >> "$LOG_FILE" 2>&1
sudo apt update >> "$LOG_FILE" 2>&1
sudo apt upgrade -y >> "$LOG_FILE" 2>&1

echo "=== Auto-update completed at $(date) ===" >> "$LOG_FILE" 2>&1
echo "" >> "$LOG_FILE" 2>&1
