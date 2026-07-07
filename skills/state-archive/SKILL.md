---
name: state-archive
description: >-
  Moves a completed agent-state bundle from active to archive and updates the
  archive index. Use when the user invokes /state-archive, finishes a task, or
  asks to archive a bundle.
disable-model-invocation: true
---

# State Archive

Move a finished bundle from `active/` to `archive/` and record it in the archive index.

## Inputs

All inputs have defaults and only need to be specified when overriding.

- `bundle_path` — absolute path under `.../agent-state/active/`. Default: [Bundle Selection](../state-save/reference.md).
- `status` — `completed` (default), `paused`, or `cancelled`
- `result_summary` — one-line outcome

## Behavior

1. Resolve the target bundle using [Bundle Selection](../state-save/reference.md). If no bundle is found, report an error and stop.
2. Move the bundle folder to `${HOME}/Documents/agent-state/archive/<bundle-name>`. If the destination already exists, append a timestamp suffix.
3. Append an entry to `archive/index.md` with: bundle name, timestamp, status, repo, branch, and summary. Create the index file with a header if it does not exist.
