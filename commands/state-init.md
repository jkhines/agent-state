---
command: /state-init
description: Creates a standardized temporary work-state bundle in Documents
alwaysApply: false
---

Create a new task bundle under `/home/jkhines/Documents/agent-state/active`.

## Required inputs

- `repo_path` -- absolute path to the repository
- `task_slug` -- lowercase kebab-case task name
- `agent_id` -- lowercase kebab-case agent identifier

## Optional inputs

- `ticket` -- Jira ticket (e.g., `PROJ-123`)

## Behavior

Bundle name: `<YYYY-MM-DD>-<repo-basename>-<task_slug>-<agent_id>`

Create the bundle directory with these files and subdirectories:

- `prompt.md` -- objective and constraints
- `context.json` -- repo_path, branch, task_slug, agent_id, status (`active`), ticket, timestamps
- `notes.md` -- running log
- `commands.log` -- significant commands only
- `resume.md` -- one-paragraph handoff with exact next step
- `manifest.md` -- file index (path, source, purpose)
- `artifacts/`, `outputs/`, `scratch/`

Report the full bundle path and files created.
