---
command: /state-organize
description: Organizes loose temporary files into a bundle and updates manifest
alwaysApply: false
---

Move or copy a loose file into a bundle's subfolder and record it in `manifest.md`.

## Required inputs

- `bundle_path` -- absolute path to the active bundle
- `source_path` -- file to intake

## Optional inputs

- `destination_type` -- `artifacts` (default), `outputs`, or `scratch`
- `mode` -- `move` (default) or `copy`
- `purpose` -- short description

## Behavior

1. Place the file into `<bundle_path>/<destination_type>/`. If a name collision exists, add a timestamp suffix.
2. Append a row to `manifest.md`: timestamp, stored path, source, mode, purpose.
3. If the source was in the `inbox/` directory, remove empty parent directories.
