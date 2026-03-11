---
command: /state-restore
description: Restores previously saved temporary work state into a repository
alwaysApply: false
---

Restore a saved checkpoint into a clean working tree.

## Required inputs

- `repo_path` -- absolute path to a git repository
- `bundle_path` -- absolute path to the saved bundle

## Behavior

1. Check that the working tree is clean (`git status --short`). If dirty, stop and ask the user.
2. Apply `repo.patch` if present and non-empty: `git apply <bundle_path>/repo.patch`
3. Apply `repo.staged.patch` if present: `git apply --index <bundle_path>/repo.staged.patch`
4. Extract `untracked.tar.gz` into repo root if present.
5. Show `git status --short` and display `resume.md` as continuation context.
