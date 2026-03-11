---
command: /state-start
description: Starts or resumes a work session, creating a bundle if none exists
alwaysApply: false
---

Start a work session. If an active bundle exists, resume it. If not, create one.

## Inputs

All inputs have defaults and only need to be specified when overriding.

- `bundle_path` -- skip selection if known
- `repo_path` -- absolute path to the repository. Default: run `git rev-parse --show-toplevel` in the current
  working directory.
- `task_slug` -- lowercase kebab-case task name. Default: infer from the primary topic of the current conversation
  (e.g., a conversation about "Update login flow" becomes `update-login-flow`).
- `agent_id` -- first 8 characters of the current Claude Code session UUID. Derive by finding the most recently
  modified `.jsonl` file in `~/.claude/projects/<project-hash>/` where `<project-hash>` is the repo's absolute path
  with `/` replaced by `-` and the leading `-` stripped. The file's basename (without `.jsonl`) is the session UUID.
- `show_summary` -- if `true`, also run `/state-summary`

## Behavior

1. If `bundle_path` is provided, use it. Otherwise list active bundles sorted by `last_updated` and select the most
   recent.
2. If a bundle is found, resume it:
   a. Read `resume.md` and `context.json` from the target bundle.
   b. Output a start brief: objective, status, first command to run, next 2 actions.
3. If no active bundle exists, create one:
   a. Bundle name: `<YYYY-MM-DD>-<repo-basename>-<task_slug>-<agent_id>`
   b. Create the bundle directory under `/home/jkhines/Documents/agent-state/active` with these files and
      subdirectories:
      - `prompt.md` -- objective and constraints
      - `context.json` -- repo_path, branch, task_slug, agent_id, status (`active`), timestamps
      - `notes.md` -- running log
      - `commands.log` -- significant commands only
      - `resume.md` -- one-paragraph handoff with exact next step
      - `manifest.md` -- file index (path, source, purpose)
      - `artifacts/`, `outputs/`, `scratch/`
   c. Report the full bundle path and files created.
4. If `show_summary=true`, run `/state-summary` and include the report path.
