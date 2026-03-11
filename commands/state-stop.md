---
command: /state-stop
description: Stops a work session by saving state and writing a clear resume point
alwaysApply: false
---

End a session cleanly with a checkpoint and an unambiguous restart point. Incorporates save and status refresh
in one step.

## Required inputs

- `bundle_path` -- absolute path to the active bundle
- `repo_path` -- absolute path to the repository

## Optional inputs

- `status` -- `active` (default), `blocked`, or `ready-for-review`
- `next_command` -- exact first command to run on resume
- `blockers` -- short description
- `progress_note` -- short description

## Behavior

1. Run `/state-save` to capture repo diffs and untracked files.
2. Update `context.json` with status, `last_updated`, `next_command`, and blockers.
3. Append a timestamped log entry to `notes.md` with progress and blockers.
4. Rewrite the top of `resume.md`: objective, status, first command, next 2-3 actions.
5. If `status=ready-for-review`, suggest `/state-finalize`.
6. If `next_command` is empty, flag the bundle as needing attention in output.
