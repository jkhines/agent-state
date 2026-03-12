---
command: /state-files
description: Lists all files attached to the active bundle with their source paths and bundle paths
alwaysApply: false
---

List all files currently attached to the active bundle. This is a read-only command that does not modify the bundle.

## Optional inputs

- `bundle_path` -- absolute path to the active bundle. Default: match active bundles by repo_path + branch +
  agent_id (see Bundle Selection below).

## Bundle Selection

Same as `/state-save`: resolve `repo_path` and `branch` using Workspace Resolution (see `/state-start`), and
`agent_id`, then match against active bundles. If no bundle is found, report that there is no active bundle and stop.

## Behavior

1. Locate the active bundle (see Bundle Selection above). If none exists, report and stop.
2. Read `attachments.json` from the bundle root. If it does not exist or is empty, report that there are no
   attachments and stop.
3. For each entry in `attachments.json`:
   a. Check whether the bundled copy at `bundle_path` exists inside the bundle directory.
   b. Check whether the original file at `source` still exists.
4. Output a table with columns: source path, bundle path, and status. Status is one of:
   - `ok` -- both source and bundled copy exist.
   - `source missing` -- bundled copy exists but the original source file does not.
   - `bundle copy missing` -- source exists but the bundled copy is missing from the bundle.
   - `both missing` -- neither the source nor the bundled copy exist.
5. Below the table, print the total count of attachments.
