---
command: /state-save
description: Saves a checkpoint of in-progress repo work without committing
alwaysApply: false
---

Capture tracked, staged, and untracked changes for later restore. Usually called by `/state-stop`; use
directly only for mid-session checkpoints.

## Required inputs

- `repo_path` -- absolute path to a git repository
- `bundle_path` -- absolute path to the active bundle

## Optional inputs

- `label` -- short checkpoint label

## Behavior

1. `git -C <repo_path> diff > <bundle_path>/repo.patch`
2. `git -C <repo_path> diff --staged > <bundle_path>/repo.staged.patch`
3. Archive untracked files (`git ls-files --others --exclude-standard`) into `<bundle_path>/untracked.tar.gz` if any exist.
4. Update `context.json` with branch, HEAD SHA, timestamp, and label.
5. Append short status to `notes.md`.
