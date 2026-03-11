---
command: /state-restore
description: Restores previously saved temporary work state into a repository
alwaysApply: false
---

Restore a saved checkpoint into a clean working tree.

## Inputs

All inputs have defaults and only need to be specified when overriding.

- `repo_path` -- absolute path to a git repository. Default: run `git rev-parse --show-toplevel` in the current
  working directory.
- `bundle_path` -- absolute path to the saved bundle. Default: most recent active bundle by `last_updated`.

## Behavior

1. Check that the working tree is clean (`git status --short`). If dirty, stop and ask the user.
2. Apply `repo.patch` if present and non-empty: `git apply <bundle_path>/repo.patch`
3. Apply `repo.staged.patch` if present: `git apply --index <bundle_path>/repo.staged.patch`
4. Extract `untracked.tar.gz` into repo root if present.
5. Show `git status --short` and display `resume.md` as continuation context.
