# speckit-auto

A single-command orchestrator that chains the entire [speckit](https://github.com/github/spec-kit) pipeline automatically:

```
specify → clarify → plan → tasks → analyze → implement
```

Instead of manually invoking each `/speckit.*` skill in sequence, run `/speckit.auto "your feature description"` and it handles all transitions for you.

## How it works

- Reads the `handoffs` YAML frontmatter from each speckit skill file to determine the next step
- Interactive skills (like `clarify`) still pause for your input — auto only handles transitions *between* skills
- Stops the pipeline if `analyze` reports CRITICAL issues
- Falls back to a small routing table for skills that don't declare handoffs (currently just `analyze → implement`)

## Installation

Run the install script to set up speckit and speckit.auto in one step:

```bash
./install.sh <your-project>
```

This runs `specify init . --ai claude` in your project and then copies `speckit.auto.md` into `.claude/commands/`.

If you already have speckit installed, you can just copy the command file directly:

```bash
cp commands/speckit.auto.md <your-project>/.claude/commands/
```

## Usage

### 1. Set up a constitution first

Before running the pipeline, your project needs a constitution — it defines the principles and constraints that guide all generated specs, plans, and code. If you don't have one yet, see the [speckit constitution docs](https://github.com/github/spec-kit#constitution) or run:

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

## Requirements

- [speckit](https://github.com/github/spec-kit) (`specify` CLI)
- Claude Code
