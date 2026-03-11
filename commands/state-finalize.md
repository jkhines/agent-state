---
command: /state-finalize
description: Finalizes completed state bundles and updates an archive index
alwaysApply: false
---

Move a finished bundle from `active/` to `archive/` and record it in the archive index.

## Inputs

All inputs have defaults and only need to be specified when overriding.

- `bundle_path` -- absolute path under `.../agent-state/active/`. Default: most recent active bundle by
  `last_updated`.
- `status` -- `completed` (default), `paused`, or `cancelled`
- `result_summary` -- one-line outcome

## Behavior

1. Move the bundle folder to `/home/jkhines/Documents/agent-state/archive/<bundle-name>`. If the destination already exists, append a timestamp suffix.
2. Append an entry to `archive/index.md` with: bundle name, timestamp, status, repo, branch, and summary. Create the index file with a header if it does not exist.
