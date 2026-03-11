---
command: /state-stop
description: Stops a work session by saving state and writing a clear resume point
alwaysApply: false
---

## Stop Work Session

Ends a session cleanly by forcing a checkpoint and a clear next command for tomorrow.

## Inputs

When `/state-stop` is invoked:

1. Require:
   - `bundle_path` (absolute path under `/home/jkhines/Documents/agent-state/active/...`)
   - `repo_path` (absolute repository path)
2. Optional:
   - `status` (default: `active`; allowed: `active`, `blocked`, `ready-for-review`)
   - `next_command` (exact command to run first on resume)
   - `blockers` (short text)
   - `progress_note` (short text)

## Execution Steps

1. Validate required paths.
2. Run `/state-save` for the bundle and repo.
3. Run `/state-refresh` with `status`, `next_command`, `blockers`, and `progress_note`.
4. If `status=ready-for-review` and work is complete, suggest `/state-finalize`.
5. Return:
   - Checkpoint artifacts written
   - Status recorded
   - First command for next session

## Example Commands

```bash
repo="/home/jkhines/src/my-repo"
bundle="/home/jkhines/Documents/agent-state/active/2026-03-10-my-repo-task-agent3"
echo "Save checkpoint for $repo -> $bundle"
echo "Update resume with next command: git status"
```
