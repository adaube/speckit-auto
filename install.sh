#!/usr/bin/env bash
set -euo pipefail

SCRIPT_SOURCE="$0"
while [ -L "$SCRIPT_SOURCE" ]; do
  SCRIPT_DIR="$(cd "$(dirname "$SCRIPT_SOURCE")" && pwd -P)"
  SCRIPT_SOURCE="$(readlink "$SCRIPT_SOURCE")"
  [[ "$SCRIPT_SOURCE" != /* ]] && SCRIPT_SOURCE="$SCRIPT_DIR/$SCRIPT_SOURCE"
done
SCRIPT_DIR="$(cd "$(dirname "$SCRIPT_SOURCE")" && pwd -P)"

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
cp "$SCRIPT_DIR/commands/speckit.auto.md" "$TARGET/"
echo "Installed speckit.auto.md to $TARGET/"
