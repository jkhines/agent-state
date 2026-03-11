---
command: /state-refresh
description: Refreshes a bundle with current status, blockers, and exact next action
alwaysApply: false
---

## Refresh Bundle Status

Updates a bundle before pause/end-of-day so tomorrow's restart is fast and unambiguous.

## Inputs

When `/state-refresh` is invoked:

1. Require:
   - `bundle_path` (absolute path under `/home/jkhines/Documents/agent-state/active/...`)
2. Optional:
   - `status` (default: `active`; allowed: `active`, `blocked`, `ready-for-review`)
   - `next_command` (exact command to run first when resuming)
   - `blockers` (short text)
   - `progress_note` (short text)

## Execution Steps

1. Validate:
   - Ensure `bundle_path` exists.
   - Ensure `context.json`, `notes.md`, and `resume.md` exist or create them.
2. Update `context.json` fields:
   - `status`
   - `last_updated` (ISO timestamp)
   - `next_command` (if provided)
   - `blockers` (if provided)
3. Append concise log entry to `notes.md`:
   - timestamp
   - progress note
   - blockers
4. Rewrite top section of `resume.md`:
   - Current objective
   - Status
   - First command to run
   - Immediate next 2-3 actions
5. Optional consistency check:
   - If `next_command` is empty, mark bundle as `Needs Attention` in the output summary.
6. Return:
   - Updated files
   - Status
   - First command for next session

## Example Commands

```bash
bundle="/home/jkhines/Documents/agent-state/active/2026-03-10-my-repo-task-agent3"
ts="$(date -Iseconds)"
printf "\n## %s\n- Status: active\n- Next command: git status\n" "$ts" >> "$bundle/notes.md"
cat > "$bundle/resume.md" <<EOF
Current objective: Continue in-progress task.
Status: active
First command: git status
Next actions:
1. Review pending changes.
2. Continue implementation.
3. Save checkpoint with /state-save.
EOF
```
