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
- `agent_id` -- first 8 characters of the current session identifier. Derive based on the executing environment:
  - **Claude Code**: find the most recently modified `.jsonl` file in `~/.claude/projects/<project-hash>/` where
    `<project-hash>` is the repo's absolute path with `/` replaced by `-` and the leading `-` stripped. The file's
    basename (without `.jsonl`) is the session UUID.
  - **Cursor CLI (cursor-agent)**: read `agentId` from the current conversation's `store.db` metadata (key `0` in
    the `meta` table, hex-decoded JSON).
  - **Cursor IDE (Composer)**: read `composerId` from the current Composer session in the workspace's `state.vscdb`
    (`composer.composerData` key in `ItemTable`).
- `show_summary` -- if `true`, also run `/state-summary`

## Behavior

1. If `bundle_path` is provided, use it. Otherwise, resolve the current `repo_path`, `branch`, and `agent_id`, then
   select a bundle using this precedence:
   a. Exact match on repo_path + branch + agent_id.
   b. If no exact match, list all active bundles matching repo_path + branch. If one exists, display it and ask the
      user whether to adopt it (update its `agent_id` to the current session) or create a new bundle. If multiple
      exist, list them all and ask the user to choose.
   c. If no bundles match repo_path + branch, proceed to step 3 (create a new bundle).
2. If a bundle is found or adopted, resume it:
   a. Read `resume.md` from the target bundle.
   b. Output the full resume: objective, status, decisions, blockers, artifacts, verification, and next actions.
3. If no active bundle exists, create one:
   a. Bundle name: `<YYYY-MM-DD>-<repo-basename>-<task_slug>-<agent_id>`
   b. Create the bundle directory under `/home/jkhines/Documents/agent-state/active` with these files and
      subdirectories:
      - `prompt.md` -- objective and constraints
      - `context.json` -- repo_path, branch, task_slug, agent_id, status (`active`), timestamps
      - `notes.md` -- running log
      - `commands.log` -- significant commands only
      - `resume.md` -- structured resume with objective, status, decisions, blockers, artifacts, verification, and next actions
      - `manifest.md` -- file index (path, source, purpose)
      - `artifacts/`, `outputs/`, `scratch/`
   c. Report the full bundle path and files created.
4. If `show_summary=true`, run `/state-summary` and include the report path.
