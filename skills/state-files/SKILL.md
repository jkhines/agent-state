---
name: state-files
description: >-
  Lists all files attached to the active agent-state bundle with source paths,
  bundle paths, and sync status. Use when the user invokes /state-files or asks
  to see bundle attachments.
disable-model-invocation: true
---

# State Files

List all files currently attached to the active bundle. This is a read-only skill that does not modify the bundle.

## Optional inputs

- `bundle_path` — absolute path to the active bundle. Default: [Bundle Selection](../state-save/reference.md).

## Behavior

1. Locate the active bundle using [Bundle Selection](../state-save/reference.md). If none exists, report that there is no active bundle and stop.
2. Read `attachments.json` from the bundle root. If it does not exist or is empty, report that there are no attachments and stop.
3. For each entry in `attachments.json`:
   a. Check whether the bundled copy at `bundle_path` exists inside the bundle directory.
   b. Check whether the original file at `source` still exists.
4. Output a table with columns: source path, bundle path, and status. Status is one of:
   - `ok` — both source and bundled copy exist.
   - `source missing` — bundled copy exists but the original source file does not.
   - `bundle copy missing` — source exists but the bundled copy is missing from the bundle.
   - `both missing` — neither the source nor the bundled copy exist.
5. Below the table, print the total count of attachments.
