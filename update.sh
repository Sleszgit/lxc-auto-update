#!/bin/bash
# Manual update script for Claude Code and system packages
# Usage: Just run 'update' in your terminal

echo "=========================================="
echo "  System Update Script"
echo "=========================================="
echo ""

# Update Claude Code
echo "Updating Claude Code..."
if sudo npm i -g @anthropic-ai/claude-code; then
    echo "✓ Claude Code updated successfully"
else
    echo "✗ Failed to update Claude Code"
fi
echo ""

# Update system packages
echo "Updating system packages..."
if sudo apt update; then
    echo "✓ Package list updated"
else
    echo "✗ Failed to update package list"
    exit 1
fi
echo ""

echo "Upgrading packages..."
if sudo apt upgrade -y; then
    echo "✓ System packages upgraded successfully"
else
    echo "✗ Failed to upgrade packages"
    exit 1
fi
echo ""

echo "=========================================="
echo "  Update completed at $(date)"
echo "=========================================="
