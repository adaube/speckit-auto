# speckit-auto

A single-command orchestrator that chains the entire [speckit](https://github.com/speckai/speckit) pipeline automatically:

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

Copy the command file into your project's `.claude/commands/` directory (where your speckit skills already live):

```bash
cp commands/speckit.auto.md <your-project>/.claude/commands/
```

Or use the install script:

```bash
./install.sh <your-project>
```

## Usage

```
/speckit.auto Add a score counter HUD that displays points and a combo multiplier
```

## Survives speckit updates

Speckit updates overwrite `speckit.specify.md`, `speckit.clarify.md`, etc. but never touch `speckit.auto.md` since it's a separate file. The routing is derived dynamically from frontmatter, so if speckit changes its handoff graph, auto adapts automatically.

## Requirements

- [speckit](https://github.com/speckai/speckit) skills installed in `.claude/commands/`
- Claude Code
