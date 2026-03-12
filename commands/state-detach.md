---
command: /state-detach
description: Removes one or more attached files from the active bundle
alwaysApply: false
---

Remove one or more previously attached files from the active bundle. This deletes the bundled copy and removes the
entry from `attachments.json`. It does not delete the original file at the source path.

## Inputs

- `paths` (required) -- one or more file paths matching entries in `attachments.json`. Accepts the original source
  path, the bundle-relative path (e.g., `attachments/src--project--file.md`), or a glob pattern matching source paths.
  Resolve relative paths to absolute before matching.

## Bundle Selection

Same as `/state-save`: resolve `repo_path` and `branch` using Workspace Resolution (see `/state-start`), and
`agent_id`, then match against active bundles. If no bundle is found, report that there is no active bundle and stop.

## Behavior

1. Locate the active bundle (see Bundle Selection above). If none exists, report and stop.
2. Read `attachments.json` from the bundle root. If it does not exist or is empty, report that there are no
   attachments and stop.
3. For each path argument:
   a. Resolve to an absolute path if relative.
   b. Match against `attachments.json` entries by `source` path. If no match, try matching against `bundle_path`.
      If still no match, expand as a glob against source paths. Warn and skip any path that matches nothing.
   c. For each matched entry, delete the file at `bundle_path` inside the bundle directory and remove the entry
      from `attachments.json`.
4. Write the updated `attachments.json` to the bundle root.
5. Update `manifest.md` to remove the detached files.
6. Output a confirmation listing each detached file and its original source path.
