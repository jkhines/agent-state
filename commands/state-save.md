---
command: /state-save
description: Saves a checkpoint of in-progress repo work without committing
alwaysApply: false
---

## Save Temporary Work State

Saves tracked and untracked work for later restore. Use this when work is in progress and should not be
committed.

## Inputs

When `/state-save` is invoked:

1. Require:
   - `repo_path` (absolute path to repository)
   - `bundle_path` (absolute path in `/home/jkhines/Documents/agent-state/active/...`)
2. Optional:
   - `label` (short checkpoint label)

## Execution Steps

1. Validate:
   - `repo_path` exists and is a git repository.
   - `bundle_path` exists.
2. Save tracked file changes:
   - `git -C "<repo_path>" diff > "<bundle_path>/repo.patch"`
3. Save staged changes:
   - `git -C "<repo_path>" diff --staged > "<bundle_path>/repo.staged.patch"`
4. Save untracked files:
   - Read untracked file list:
     - `git -C "<repo_path>" ls-files --others --exclude-standard`
   - If list is not empty, archive paths relative to repo root into:
     - `"<bundle_path>/untracked.tar.gz"`
5. Save repo state metadata:
   - branch name
   - short HEAD SHA
   - timestamp
   - optional `label`
   - write into `"<bundle_path>/context.json"` (merge or append safely)
6. Append short status to:
   - `"<bundle_path>/notes.md"`
   - `"<bundle_path>/resume.md"` with exact next command
7. Return:
   - Files written
   - Count of tracked and untracked files captured

## Example Commands

```bash
repo="/home/jkhines/src/my-repo"
bundle="/home/jkhines/Documents/agent-state/active/2026-03-10-my-repo-auth-token-refresh-agent3"
git -C "$repo" diff > "$bundle/repo.patch"
git -C "$repo" diff --staged > "$bundle/repo.staged.patch"
mapfile -t untracked < <(git -C "$repo" ls-files --others --exclude-standard)
if [ "${#untracked[@]}" -gt 0 ]; then
  tar -C "$repo" -czf "$bundle/untracked.tar.gz" "${untracked[@]}"
fi
```
