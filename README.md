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

### 1. Start with a constitution

The constitution describes your project's governing principles and development guidelines that will guide all subsequent development. It's created once per project and covers things like:

- **Application context** — what the project is and the user experience it delivers
- **Development guidelines** — how code gets written (e.g. must implement using red/green TDD)
- **Stack constraints** — languages, frameworks, and tooling decisions

We recommend starting with some battle-hardened defaults: describe your application and user experience, and require red/green TDD for all implementation. You can always refine later.

If your project already has a constitution, skip to step 2. Otherwise, create one by running `/speckit.constitution` inside Claude Code — or just go straight to step 2 and speckit.auto will walk you through it automatically.

### 2. Describe what you want to build

Describe the feature you want — what it does and why it matters:

```
/speckit.auto Add a score counter HUD that displays points and a combo multiplier so players get real-time feedback on their performance
```

## Survives speckit updates

Speckit updates overwrite `speckit.specify.md`, `speckit.clarify.md`, etc. but never touch `speckit.auto.md` since it's a separate file. The routing is derived dynamically from frontmatter, so if speckit changes its handoff graph, auto adapts automatically.

## Tips

The full pipeline generates substantial context across 6 phases. 
I recommend using [claude-context-mode](https://github.com/mksglu/claude-context-mode) to compress intermediate outputs.

Inside Claude Code...
1. add the plugin:
```bash
/plugin marketplace add mksglu/claude-context-mode
```
2. install the plugin:
```bash
/plugin marketplace add mksglu/claude-context-mode
```
3. restart claude code to load plugin and begin using
