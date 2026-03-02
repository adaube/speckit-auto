# speckit-auto

A [Claude Code](https://docs.anthropic.com/en/docs/claude-code) slash command that chains the entire [speckit](https://github.com/github/spec-kit) pipeline into a single invocation:

```
specify → clarify → plan → tasks → analyze → implement
```

All speckit commands are slash commands that run inside Claude Code. Instead of manually invoking each `/speckit.*` command in sequence, run `/speckit.auto` and it handles all transitions for you.

## How it works

- Runs as a Claude Code slash command — all `/speckit.*` commands execute inside your Claude Code session
- Reads the `handoffs` YAML frontmatter from each speckit skill file to determine the next step
- Interactive skills (like `clarify`) still pause for your input — auto only handles transitions *between* skills
- Stops the pipeline if `analyze` reports CRITICAL issues
- Falls back to a small routing table for skills that don't declare handoffs (currently just `analyze → implement`)

## Installation

### Prerequisites

- [Claude Code](https://docs.anthropic.com/en/docs/claude-code) installed and working
- [speckit](https://github.com/github/spec-kit) (`specify` CLI)

### Install

Run the install script to set up speckit and speckit.auto in one step:

**macOS / Linux:**
```bash
./install.sh <your-project>
```

**Windows (PowerShell):**
```powershell
.\install.ps1 <your-project>
```

This runs `specify init . --ai claude` in your project and then copies `speckit.auto.md` into `.claude/commands/`.

If you already have speckit installed, you can just copy the command file directly:

**macOS / Linux:**
```bash
cp commands/speckit.auto.md <your-project>/.claude/commands/
```

**Windows (PowerShell):**
```powershell
Copy-Item commands\speckit.auto.md <your-project>\.claude\commands\
```

## Usage

All commands below are run inside Claude Code.

### 1. Set up a constitution first

Before running the pipeline, your project needs a constitution — it defines the principles and constraints that guide all generated specs, plans, and code. If you don't have one yet, see the [speckit constitution docs](https://github.com/github/spec-kit#constitution) or run inside Claude Code:

```
/speckit.constitution
```

### 2. Describe what you want to build

Once a constitution is in place, describe the feature you want — what it does and why it matters:

```
/speckit.auto Add a score counter HUD that displays points and a combo multiplier so players get real-time feedback on their performance
```

## Survives speckit updates

Speckit updates overwrite `speckit.specify.md`, `speckit.clarify.md`, etc. but never touch `speckit.auto.md` since it's a separate file. The routing is derived dynamically from frontmatter, so if speckit changes its handoff graph, auto adapts automatically.

## Tips

The full pipeline generates substantial context across 6 phases. If your sessions hit context limits during the `implement` phase, [claude-context-mode](https://github.com/mksglu/claude-context-mode) can compress intermediate outputs. It installs globally and works automatically — no per-project setup needed.
