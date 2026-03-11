---
command: /state-organize
description: Organizes loose temporary files into a bundle and updates manifest
alwaysApply: false
---

## Organize Temporary Files

Moves or copies loose files into a bundle so saved artifacts stay discoverable and tied to the right task.

## Inputs

When `/state-organize` is invoked:

1. Require:
   - `bundle_path` (absolute path under `/home/jkhines/Documents/agent-state/active/...`)
   - `source_path` (file path to intake)
2. Optional:
   - `destination_type` (default: `artifacts`; allowed: `artifacts`, `outputs`, `scratch`)
   - `mode` (default: `move`; allowed: `move`, `copy`)
   - `purpose` (short description)

## Execution Steps

1. Validate:
   - Ensure `bundle_path` exists.
   - Ensure `source_path` exists.
   - Ensure destination subfolder exists, or create it.
2. Compute destination:
   - `<bundle_path>/<destination_type>/<file-name>`
   - If file exists, add timestamp suffix before extension.
3. Transfer file:
   - `move` mode: move the source file.
   - `copy` mode: copy and preserve the original.
4. Update `manifest.md`:
   - Append one row with:
     - timestamp
     - stored path
     - source path
     - mode
     - purpose (`Unknown` if omitted)
5. Optional cleanup:
   - If source was from `/home/jkhines/Documents/agent-state/inbox`, remove empty parent directories.
6. Return:
   - Final stored path
   - Whether move/copy was used

## Example Commands

```bash
bundle="/home/jkhines/Documents/agent-state/active/2026-03-10-my-repo-task-agent3"
src="/home/jkhines/Documents/agent-state/inbox/error-log.txt"
dst="$bundle/artifacts/$(basename "$src")"
mkdir -p "$bundle/artifacts"
mv "$src" "$dst"
[ -f "$bundle/manifest.md" ] || printf "| Timestamp | Stored Path | Source | Mode | Purpose |\n|---|---|---|---|---|\n" > "$bundle/manifest.md"
printf "| %s | %s | %s | move | %s |\n" "$(date -Iseconds)" "$dst" "$src" "debug log capture" >> "$bundle/manifest.md"
```
