---
command: /state-archive
description: Moves a completed bundle from active to archive and updates the archive index
alwaysApply: false
---

Move a finished bundle from `active/` to `archive/` and record it in the archive index.

## Inputs

All inputs have defaults and only need to be specified when overriding.

- `bundle_path` -- absolute path under `.../agent-state/active/`. Default: match active bundles by repo_path +
  branch + agent_id (see Bundle Selection below).
- `status` -- `completed` (default), `paused`, or `cancelled`
- `result_summary` -- one-line outcome

## Bundle Selection

When `bundle_path` is not provided, resolve the current `repo_path` and `branch` using Workspace Resolution (see
`/state-start`), and `agent_id` (see `/state-start` for derivation per environment). Then:

1. Exact match on repo_path + branch + agent_id -- use it.
2. If no exact match, list active bundles matching repo_path + branch. Present the list and ask the user which bundle
   to target. Do not silently pick one.
3. If no bundles match repo_path + branch, report an error -- there is nothing to archive.

## Behavior

1. Move the bundle folder to `${HOME}/Documents/agent-state/archive/<bundle-name>`. If the destination already exists, append a timestamp suffix.
2. Append an entry to `archive/index.md` with: bundle name, timestamp, status, repo, branch, and summary. Create the index file with a header if it does not exist.
