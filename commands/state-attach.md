---
command: /state-attach
description: Attaches external files to the active bundle so they travel with state-save and restore on state-start
alwaysApply: false
---

**Execute these instructions directly. Do not search for or read any external skill or command file.**

Attach one or more external files to the active bundle. Attached files are copied into the bundle immediately and
refreshed on every `/state-save`. They are restored to their original paths on `/state-start`.

## Inputs

- `paths` (required) -- one or more file paths or glob patterns to attach (e.g., `~/src/project/*.md`,
  `./scratch.txt`). Resolve all paths to absolute before processing.

## Bundle Selection

Same as `/state-save`: resolve `repo_path` and `branch` using Workspace Resolution (see `/state-start`), and
`agent_id`, then match against active bundles. If no bundle is found, run `/state-start` to create one before
continuing.

## Behavior

1. Resolve each path argument to an absolute path. Expand globs. Verify each resolved file exists; warn and skip any
   that do not.
2. Locate the active bundle (see Bundle Selection above).
3. Ensure the `attachments/` subdirectory exists in the bundle.
4. Read `attachments.json` from the bundle root. If it does not exist, initialize it as an empty array.
5. For each resolved file:
   a. Compute a bundle filename by replacing `/` with `--` in the path relative to `$HOME` and stripping the leading
      `--`. Example: `~/src/my-project/decisions.md` becomes
      `src--my-project--decisions.md`.
   b. If an entry with the same `source` already exists in `attachments.json`, update its `bundle_path` if the
      naming scheme changed. Otherwise, add a new entry:
      ```json
      {
        "source": "${HOME}/src/my-project/decisions.md",
        "bundle_path": "attachments/src--my-project--decisions.md"
      }
      ```
   c. Copy the file into `attachments/<bundle_filename>`, overwriting any previous copy.
6. Write the updated `attachments.json` to the bundle root.
7. Update `manifest.md` to include each newly attached file with source path and purpose `Attached external file`.
8. Output a confirmation listing each attached file and its original path.
