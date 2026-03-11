# Agent State Workflow

Temporary, in-progress work state stored outside repositories.

## Directory Layout

- `active/` -- in-progress task bundles
- `archive/` -- completed, paused, or cancelled bundles
- `inbox/` -- loose files waiting to be filed

## Bundle Naming

`<YYYY-MM-DD>-<repo-name>-<task-slug>-<agent-id>`

## Bundle Structure

Files: `prompt.md`, `context.json`, `notes.md`, `resume.md`, `commands.log`, `manifest.md`

Subdirectories: `artifacts/`, `outputs/`, `scratch/`

## Commands

| Command | When to use |
|---|---|
| `/state-start` | Starting a new task or resuming an existing bundle |
| `/state-save` | Ending a session (saves context, refreshes status) |
| `/state-summary` | Cross-bundle overview; add `prune=true` for stale cleanup |
| `/state-archive` | Archiving a completed bundle |
| `/state-handoff` | Transferring work to another agent |
| `/state-organize` | Filing a loose file into a bundle |
| `/state-sync-memory` | Persisting decisions into repo memory docs |

## Daily Habit

1. `/state-start` to resume the target bundle.
2. `/state-save` before ending the day.
3. `/state-archive` for completed work.
