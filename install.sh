#!/usr/bin/env bash
set -euo pipefail

if [ $# -eq 0 ]; then
  echo "Usage: ./install.sh <project-path>"
  echo "Copies speckit.auto.md into <project-path>/.claude/commands/"
  exit 1
fi

TARGET="$1/.claude/commands"
mkdir -p "$TARGET"
cp commands/speckit.auto.md "$TARGET/"
echo "Installed speckit.auto.md to $TARGET/"
