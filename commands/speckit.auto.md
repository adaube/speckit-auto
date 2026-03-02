---
description: Full-pipeline orchestrator that auto-chains specify → clarify → plan → tasks → analyze → implement. Pass your feature description as the argument.
---

## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty). If the input is empty, **STOP** and tell the user:

> Use `/speckit.auto` the same way you'd use `/speckit.specify` — describe what you want to build and why. For example:
>
> `/speckit.auto Build an application that can help me organize my photos in separate photo albums. Albums are grouped by date and can be re-organized by dragging and dropping on the main page.`

## Purpose

You are an orchestrator that runs the full speckit pipeline automatically. You invoke each skill in sequence, using the `handoffs` frontmatter in each skill file to determine the next step. Interactive skills (like clarify) still pause for user input — you only automate the *transitions between* skills.

## Execution

### Step 0: Check for a constitution

Before doing anything else, check if a constitution file exists (e.g. `.speckit/constitution.md` or similar).

- If a constitution exists: proceed to Step 1.
- If no constitution is found: inform the user that a constitution is needed and you will create one now. Invoke `/speckit.constitution` using the Skill tool. After it completes, continue to Step 2 (the routing loop) — the constitution skill's handoff frontmatter will route to `speckit.specify`. When the handoff prompt is used for specify, append the user's original feature description (`$ARGUMENTS`) so it carries through.

### Step 1: Start the pipeline

Invoke `/speckit.specify` using the Skill tool, passing the user's feature description (`$ARGUMENTS`) as the args.

### Step 2: Routing loop

After each skill completes, determine the next skill to invoke:

1. **Read** the skill file that just ran: `.claude/commands/speckit.<name>.md`
2. **Parse** the YAML frontmatter and extract the `handoffs` array
3. **Select next skill**:
   - If handoffs exist: pick the **first entry with `send: true`**. If none have `send: true`, pick the first entry overall.
   - If no handoffs in frontmatter: consult the **fallback table** below
   - If no route found at all: **STOP** — the pipeline is complete
4. **Check for blockers** (see Blocker Detection below)
5. **Invoke** the next skill using the Skill tool with the handoff's `prompt` value as args
6. **Repeat** from step 2

### Fallback Table

Only used when a skill's frontmatter has no `handoffs` field:

| Completed Skill | Next Skill | Prompt |
|---|---|---|
| analyze | speckit.implement | Start the implementation in phases |

### Blocker Detection

Before each transition, check for blockers:

- **After `speckit.analyze`**: Review the analysis output. If there are any **CRITICAL** severity issues reported, **STOP the pipeline**. Inform the user of the critical issues and tell them to resolve them before running `/speckit.auto` again or manually invoking `/speckit.implement`.
- **After any skill**: If the skill produced an error or explicitly aborted, **STOP the pipeline** and report what happened.
- **After any skill that writes markdown**: Check every markdown file the skill created or modified for HTML comments (`<!-- ... -->`). If any are found, **STOP the pipeline** and tell the user which files contain HTML comments. HTML comments are not allowed in any markdown artifacts produced by the pipeline. The user must remove them before the pipeline can continue.

If no blockers are detected, proceed to the next skill.

### Expected Route

Given current speckit frontmatter, the typical route is:

```
specify → clarify → plan → tasks → analyze → implement
```

But you must always derive the route dynamically from frontmatter, not hardcode it. The above is just for reference.

## Rules

- **Never modify existing speckit files.** You only read them to determine routing.
- **Never skip interactive steps.** When clarify runs, let it ask its questions and wait for user answers naturally.
- **Always use the Skill tool** to invoke each speckit skill. Do not try to inline their logic.
- **Track which skill just completed** so you can read the correct file for routing.
- **One skill at a time.** Do not invoke multiple skills in parallel.
- **Report progress.** Before each transition, briefly tell the user which skill just finished and which one you're invoking next.
- **No HTML comments in markdown.** After each skill completes, scan any markdown files it produced for HTML comments (`<!-- ... -->`). If found, stop the pipeline and report the offending files and line numbers. This applies to all markdown artifacts — specs, plans, tasks, analysis, and implementation notes.
