#!/usr/bin/env bash
set -euo pipefail

if [ $# -eq 0 ]; then
  echo "Usage: ./install.sh <project-path>"
  echo "Installs speckit and speckit.auto into <project-path>"
  exit 1
fi

PROJECT="$1"

# Install speckit skills
echo "Installing speckit skills..."
if ! (cd "$PROJECT" && specify init . --ai claude); then
  echo "speckit installation exited — skipping speckit.auto"
  exit 0
fi

# Layer speckit.auto on top
TARGET="$PROJECT/.claude/commands"
mkdir -p "$TARGET"
cp commands/speckit.auto.md "$TARGET/"
echo "Installed speckit.auto.md to $TARGET/"
