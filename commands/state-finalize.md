---
command: /state-finalize
description: Finalizes completed state bundles and updates an archive index
alwaysApply: false
---

## Finalize Completed State Bundle

Moves a finished bundle from `active` to `archive` and records a searchable index entry.

## Inputs

When `/state-finalize` is invoked:

1. Require:
   - `bundle_path` (absolute path under `/home/jkhines/Documents/agent-state/active/...`)
2. Optional:
   - `status` (default: `completed`; allowed: `completed`, `paused`, `cancelled`)
   - `result_summary` (short one-line outcome)
   - `archive_root` (default: `/home/jkhines/Documents/agent-state/archive`)
   - `index_file` (default: `/home/jkhines/Documents/agent-state/archive/index.md`)

## Execution Steps

1. Validate inputs:
   - Ensure `bundle_path` exists.
   - Ensure `bundle_path` is within `/home/jkhines/Documents/agent-state/active`.
   - Validate `status` is one of: `completed`, `paused`, `cancelled`.
2. Ensure archive location exists:
   - Create `archive_root` if missing.
   - Create `index_file` if missing, including a short header.
3. Build archive destination:
   - Keep original bundle folder name.
   - Destination: `<archive_root>/<bundle-folder-name>`
   - If destination exists, append timestamp suffix:
     - `<bundle-folder-name>-<YYYYMMDD-HHMMSS>`
4. Capture archive metadata:
   - Archive timestamp in ISO format.
   - Bundle name.
   - Extract repo path and branch from `context.json` when available.
   - Include `status` and `result_summary` (`Unknown` if omitted).
5. Move bundle:
   - Move folder from `active` to archive destination atomically.
6. Update archive index:
   - Append one section per bundle to `index_file` with:
     - bundle name
     - archive timestamp
     - status
     - repo path
     - branch
     - summary
     - archived path
7. Return:
   - Archived path
   - Index file path
   - Status entry written

## Example Commands

```bash
bundle="/home/jkhines/Documents/agent-state/active/2026-03-10-my-repo-task-agent3"
archive_root="/home/jkhines/Documents/agent-state/archive"
index="$archive_root/index.md"
mkdir -p "$archive_root"
[ -f "$index" ] || printf "# Agent State Archive Index\n\n" > "$index"
name="$(basename "$bundle")"
dest="$archive_root/$name"
if [ -e "$dest" ]; then
  dest="$archive_root/${name}-$(date +%Y%m%d-%H%M%S)"
fi
mv "$bundle" "$dest"
{
  printf "## %s\n" "$(date -Iseconds)"
  printf "- Bundle: `%s`\n" "$name"
  printf "- Status: `completed`\n"
  printf "- Summary: `Unknown`\n"
  printf "- Path: `%s`\n\n" "$dest"
} >> "$index"
```
