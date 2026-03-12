---
command: /state-start
description: Starts or resumes a work session, creating a bundle if none exists
alwaysApply: false
---

Start a work session. If an active bundle exists, resume it. If not, create one.

## Inputs

All inputs have defaults and only need to be specified when overriding.

- `bundle_path` -- skip selection if known
- `repo_path` -- absolute path to the workspace. Default: resolve using Workspace Resolution (below).
- `task_slug` -- lowercase kebab-case task name. Default: infer from the primary topic of the current conversation
  (e.g., a conversation about "Update login flow" becomes `update-login-flow`).
- `agent_id` -- first 8 characters of the current session identifier. Derive based on the executing environment:
  - **Claude Code**: find the most recently modified `.jsonl` file in `~/.claude/projects/<project-hash>/` where
    `<project-hash>` is the resolved `repo_path` with `/` replaced by `-` and the leading `-` stripped. The file's
    basename (without `.jsonl`) is the session UUID.
  - **Cursor CLI (cursor-agent)**: read `agentId` from the current conversation's `store.db` metadata (key `0` in
    the `meta` table, hex-decoded JSON).
  - **Cursor IDE (Composer)**: read `composerId` from the current Composer session in the workspace's `state.vscdb`
    (`composer.composerData` key in `ItemTable`).
- `show_summary` -- if `true`, also run `/state-summary`

## Workspace Resolution

Other commands reference this section as the canonical source for resolving workspace context.

- `repo_path`: run `git rev-parse --show-toplevel`. If that fails (not a git repository), use the current working
  directory (`pwd`).
- `branch`: run `git branch --show-current`. If that fails, use `none`.

## Behavior

1. If `bundle_path` is provided, use it. Otherwise, resolve the current `repo_path`, `branch`, and `agent_id`, then
   select a bundle using this precedence:
   a. Exact match on repo_path + branch + agent_id.
   b. If no exact match, list all active bundles matching repo_path + branch. If one exists, display it and ask the
      user whether to adopt it (update its `agent_id` to the current session) or create a new bundle. If multiple
      exist, list them all and ask the user to choose.
   c. If no bundles match repo_path + branch, proceed to step 3 (create a new bundle).
2. If a bundle is found or adopted, resume it:
   a. Restore attachments: if `attachments.json` exists in the bundle and is non-empty, restore each file to its
      `source` path. Create parent directories if needed. Before overwriting an existing local file, compare it to
      the bundled copy. If the local file differs, warn the user with both paths and ask whether to overwrite,
      skip, or view the diff. If the local file does not exist, restore silently.
   b. Read `resume.md` from the target bundle.
   c. Output the full resume: objective, status, decisions, blockers, artifacts, verification, next actions, and
      the list of restored attachments.
3. If no active bundle exists, create one:
   a. Bundle name: `<YYYY-MM-DD>-<repo-basename>-<task_slug>-<agent_id>`
   b. Create the bundle directory under `${HOME}/Documents/agent-state/active` with these files and
      subdirectories:
      - `prompt.md` -- objective and constraints
      - `context.json` -- repo_path, branch, task_slug, agent_id, status (`active`), timestamps
      - `notes.md` -- running log
      - `commands.log` -- significant commands only
      - `resume.md` -- structured resume with objective, status, decisions, blockers, artifacts, verification, and next actions
      - `manifest.md` -- file index (path, source, purpose)
      - `attachments.json` -- external file attachment manifest (initialized as `[]`)
      - `artifacts/`, `outputs/`, `scratch/`, `attachments/`
   c. Report the full bundle path and files created.
4. If `show_summary=true`, run `/state-summary` and include the report path.
