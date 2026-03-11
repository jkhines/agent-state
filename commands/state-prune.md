---
command: /state-prune
description: Flags stale active bundles and writes a prune action report
alwaysApply: false
---

## Prune Stale Active Bundles

Identifies stale bundles in `active/`, recommends an action for each one, and saves a report for triage.

## Inputs

When `/state-prune` is invoked:

1. Optional:
   - `state_root` (default: `/home/jkhines/Documents/agent-state`)
   - `stale_days` (default: `3`)
   - `report_file` (default: `<state_root>/reports/prune-<YYYY-MM-DD>.md`)
   - `auto_archive_paused` (default: `false`)

## Execution Steps

1. Validate structure:
   - Ensure `<state_root>/active` exists.
   - Ensure `<state_root>/reports` exists or create it.
2. Enumerate active bundles:
   - For each bundle folder, read `context.json`, `resume.md`, and `notes.md` when present.
3. Determine staleness:
   - Prefer `context.json.last_updated` as the activity timestamp.
   - Fallback to bundle directory modified time if `last_updated` is missing.
   - Mark stale when age is greater than or equal to `stale_days`.
4. Determine suggested action:
   - `refresh`: stale but status is `active` and has a clear next command.
   - `archive`: stale and status is `ready-for-review`, `completed`, or `paused`.
   - `cancel`: stale with no next command and no meaningful progress notes.
   - `needs-triage`: missing metadata or conflicting status.
5. Build prune report:
   - Include summary counts by action.
   - Include one row per stale bundle with:
     - bundle name
     - age in days
     - status
     - next command presence
     - suggested action
     - reason
6. Optional auto-archive:
   - If `auto_archive_paused=true`, invoke `/state-finalize` behavior for stale bundles with status `paused`.
7. Save report:
   - Write markdown report to `report_file`.
8. Return:
   - Report path
   - Total active bundles
   - Total stale bundles
   - Suggested action counts

## Example Commands

```bash
root="/home/jkhines/Documents/agent-state"
report="$root/reports/prune-$(date +%F).md"
mkdir -p "$root/reports"
{
  echo "# State Prune Report ($(date +%F))"
  echo
  echo "| Bundle | Age (days) | Status | Next Command | Suggested Action | Reason |"
  echo "|---|---:|---|---|---|---|"
  for b in "$root"/active/*; do
    [ -d "$b" ] || continue
    echo "| $(basename "$b") | Unknown | Unknown | Unknown | needs-triage | metadata missing |"
  done
} > "$report"
echo "$report"
```
