---
command: /state-restore
description: Restores previously saved temporary work state into a repository
alwaysApply: false
---

## Restore Temporary Work State

Restores a saved checkpoint into a repository working tree without using commits.

## Inputs

When `/state-restore` is invoked:

1. Require:
   - `repo_path` (absolute path to repository)
   - `bundle_path` (absolute path to saved bundle)
2. Optional:
   - `apply_staged_patch` (`true` or `false`, default `true`)

## Execution Steps

1. Validate:
   - `repo_path` exists and is a git repository.
   - `bundle_path` exists.
   - Files `repo.patch` and/or `repo.staged.patch` are present.
2. Pre-flight safety:
   - Run `git -C "<repo_path>" status --short`.
   - If working tree is not clean, stop and ask user to choose a clean target tree.
3. Apply tracked change patches:
   - `git -C "<repo_path>" apply "<bundle_path>/repo.patch"` if file exists and not empty.
   - If `apply_staged_patch=true`, apply staged patch:
     - `git -C "<repo_path>" apply --index "<bundle_path>/repo.staged.patch"`
4. Restore untracked files:
   - If `"<bundle_path>/untracked.tar.gz"` exists:
     - `tar -C "<repo_path>" -xzf "<bundle_path>/untracked.tar.gz"`
5. Verify restore:
   - Run `git -C "<repo_path>" status --short`
   - Summarize restored changes.
6. Handoff:
   - Read and show `"<bundle_path>/resume.md"` as the continuation context.

## Example Commands

```bash
repo="/home/jkhines/src/my-repo"
bundle="/home/jkhines/Documents/agent-state/active/2026-03-10-my-repo-auth-token-refresh-agent3"
git -C "$repo" status --short
git -C "$repo" apply "$bundle/repo.patch"
git -C "$repo" apply --index "$bundle/repo.staged.patch"
if [ -f "$bundle/untracked.tar.gz" ]; then
  tar -C "$repo" -xzf "$bundle/untracked.tar.gz"
fi
git -C "$repo" status --short
```
