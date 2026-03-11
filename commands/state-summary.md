---
command: /state-summary
description: Builds a concise summary of active and recently archived work bundles
alwaysApply: false
---

## Work State Summary

Creates a restart-friendly daily report so you can quickly remember what each agent was doing and what to do
next.

## Inputs

When `/state-summary` is invoked:

1. Optional:
   - `state_root` (default: `/home/jkhines/Documents/agent-state`)
   - `days` (default: `2`) for recent archive window
   - `output_file` (default: `<state_root>/reports/daily-<YYYY-MM-DD>.md`)

## Execution Steps

1. Validate structure:
   - Ensure `<state_root>/active` and `<state_root>/archive` exist.
   - Ensure `<state_root>/reports` exists or create it.
2. Enumerate active bundles:
   - For each folder in `active/`, read `context.json`, `resume.md`, and `notes.md` if present.
   - Extract: repo, branch, agent, status, last_updated, blocker summary, next command.
3. Enumerate recent archives:
   - Read bundles in `archive/` modified in the last `days`.
   - Extract status and summary from `context.json` and `archive/index.md` when available.
4. Produce report sections:
   - `Today Focus`: active bundles sorted by `last_updated` descending.
   - `Needs Attention`: active bundles missing `resume.md` next step or stale `last_updated`.
   - `Recently Completed`: archived bundles within `days`.
   - `Suggested First Task`: one recommended starting point (most recent active with clear next action).
5. Save report:
   - Write markdown to `output_file`.
6. Return:
   - Report path
   - Count of active bundles
   - Count of stale or incomplete bundles

## Example Commands

```bash
root="/home/jkhines/Documents/agent-state"
out="$root/reports/daily-$(date +%F).md"
mkdir -p "$root/reports"
{
  echo "# Agent State Summary ($(date +%F))"
  echo
  echo "## Today Focus"
  for b in "$root"/active/*; do
    [ -d "$b" ] || continue
    echo "- $(basename "$b")"
  done
} > "$out"
```
