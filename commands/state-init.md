---
command: /state-init
description: Creates a standardized temporary work-state bundle in Documents
alwaysApply: false
---

## Temporary State Bundle Initialization

Creates a new task bundle under `/home/jkhines/Documents/agent-state/active` for in-progress work that should
not be committed.

## Inputs

When `/state-init` is invoked:

1. Require:
   - `repo_path` (example: `/home/jkhines/src/my-repo`)
   - `task_slug` (example: `auth-token-refresh`)
   - `agent_id` (example: `agent3`)
2. Optional:
   - `ticket` (example: `PROJ-123`)
   - `owner` (example: `jkhines`)

## Execution Steps

1. Validate inputs:
   - Ensure `repo_path` exists.
   - Ensure `task_slug` and `agent_id` are lowercase kebab-case.
2. Build bundle name:
   - `<YYYY-MM-DD>-<repo-name>-<task-slug>-<agent-id>`
3. Create bundle folder:
   - `/home/jkhines/Documents/agent-state/active/<bundle-name>/`
4. Create these files if missing:
   - `prompt.md`
   - `context.json`
   - `notes.md`
   - `commands.log`
   - `resume.md`
   - `manifest.md`
5. Create these subfolders:
   - `artifacts/`
   - `outputs/`
   - `scratch/`
6. Populate `context.json` with:
   - `repo_path`
   - current git branch (if repo)
   - `task_slug`
   - `agent_id`
   - `status` (set to `active`)
   - `last_updated`
   - `ticket` (if provided)
   - current timestamp
7. Add starter text:
   - `prompt.md`: current objective and constraints.
   - `resume.md`: one-paragraph handoff with exact next step.
   - `manifest.md`: file table with path, source, and purpose.
8. Return:
   - Full bundle path
   - Files created

## Example Commands

```bash
bundle="/home/jkhines/Documents/agent-state/active/$(date +%F)-my-repo-auth-token-refresh-agent3"
mkdir -p "$bundle"
mkdir -p "$bundle"/{artifacts,outputs,scratch}
touch "$bundle"/{prompt.md,context.json,notes.md,commands.log,resume.md,manifest.md}
```
