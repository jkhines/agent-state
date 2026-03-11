---
command: /state-start
description: Starts a focused work session without requiring a full summary
alwaysApply: false
---

## Start Work Session

Starts work quickly on one target bundle. This command does not automatically run `/state-summary`.

## Inputs

When `/state-start` is invoked:

1. Optional:
   - `bundle_path` (if known, use this directly)
   - `state_root` (default: `/home/jkhines/Documents/agent-state`)
   - `show_summary` (default: `false`)

## Execution Steps

1. Resolve target bundle:
   - If `bundle_path` is provided, use it.
   - Otherwise list active bundles sorted by recent activity and select one.
2. Load quick context from target:
   - Read `resume.md` first.
   - Read `context.json` for status, branch, and repo path.
3. Produce start brief:
   - Objective
   - Current status
   - First command to run
   - Immediate next 2 actions
4. Optional summary:
   - If `show_summary=true`, run `/state-summary` and include report path.
5. Return:
   - Target bundle path
   - Start brief
   - Optional summary report path

## Example Commands

```bash
bundle="/home/jkhines/Documents/agent-state/active/2026-03-10-my-repo-task-agent3"
echo "Starting bundle: $bundle"
[ -f "$bundle/resume.md" ] && sed -n '1,12p' "$bundle/resume.md"
```
