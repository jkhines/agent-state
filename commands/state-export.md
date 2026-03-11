---
command: /state-export
description: Exports bundle decisions into repository memory documents
alwaysApply: false
---

Copy durable decisions from a temporary bundle into repository memory documents for future sessions.

## Inputs

All inputs have defaults and only need to be specified when overriding.

- `repo_path` -- absolute path to the repository. Default: run `git rev-parse --show-toplevel` in the current
  working directory.
- `bundle_path` -- absolute path to the active bundle. Default: match active bundles by repo_path + branch +
  agent_id (see Bundle Selection below).
- `memory_dir` -- default: `<repo_path>/memory-bank`

## Bundle Selection

When `bundle_path` is not provided, resolve the current `repo_path` (via `git rev-parse --show-toplevel`), `branch`
(via `git branch --show-current`), and `agent_id` (see `/state-start` for derivation per environment). Then:

1. Exact match on repo_path + branch + agent_id -- use it.
2. If no exact match, list active bundles matching repo_path + branch. Present the list and ask the user which bundle
   to target. Do not silently pick one.
3. If no bundles match repo_path + branch, report an error -- there is nothing to export.

## Behavior

1. Ensure `memory_dir` exists (create if missing) with core files: `projectbrief.md`, `productContext.md`, `activeContext.md`, `systemPatterns.md`, `techContext.md`, `progress.md`.
2. Read `context.json`, `notes.md`, `resume.md`, and `prompt.md` from the bundle.
3. Update memory files:
   - `activeContext.md`: objective, latest decisions, blockers, next step.
   - `progress.md`: timestamped milestone entry.
   - `systemPatterns.md`: architecture or pattern decisions only.
   - `techContext.md`: environment or dependency constraints only.
4. Keep entries short and factual. Prefer intent over implementation details. Do not duplicate unchanged content.
