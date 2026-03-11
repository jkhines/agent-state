# Agent State Workflow

This directory stores temporary, in-progress work state outside repositories.

## Directory Layout

- `active/`: In-progress task bundles.
- `archive/`: Completed, paused, or cancelled bundles.
- `inbox/`: Loose files waiting to be filed into a bundle.
- `reports/`: Daily overviews and restart summaries.
- `templates/task-bundle/`: Starter structure for every new bundle.

## Bundle Naming

Use:

`<YYYY-MM-DD>-<repo-name>-<task-slug>-<agent-id>`

Example:

`2026-03-10-api-auth-refresh-agent3`

## Bundle Required Files

- `prompt.md`: Objective and constraints.
- `context.json`: Repo path, branch, status, ticket, timestamps.
- `notes.md`: Running notes, decisions, blockers.
- `resume.md`: One-screen handoff with exact next command.
- `commands.log`: Important commands only.
- `manifest.md`: Index of files stored in this bundle.

## Bundle Subdirectories

- `artifacts/`: External files, exports, payload samples, logs.
- `outputs/`: Generated analysis or reports.
- `scratch/`: Temporary working files.

## Daily Habit

1. Run `/state-start` to resume one target bundle quickly.
2. Run `/state-summary` only when you want a cross-bundle view.
3. Use `/state-organize` for any loose file.
4. Run `/state-stop` before ending the day.
5. Move finished work with `/state-finalize`.
