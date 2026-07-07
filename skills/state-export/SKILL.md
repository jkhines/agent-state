---
name: state-export
description: >-
  Exports durable decisions from an agent-state bundle into repository memory
  documents. Use when the user invokes /state-export or asks to persist bundle
  decisions to the repo memory bank.
disable-model-invocation: true
---

# State Export

Copy durable decisions from a temporary bundle into repository memory documents for future sessions.

## Inputs

All inputs have defaults and only need to be specified when overriding.

- `repo_path` — absolute path to the workspace. Default: resolve using [Workspace Resolution](../state-start/reference.md).
- `bundle_path` — absolute path to the active bundle. Default: [Bundle Selection](../state-save/reference.md).
- `memory_dir` — default: `<repo_path>/memory-bank`

## Behavior

1. Ensure `memory_dir` exists (create if missing) with core files: `projectbrief.md`, `productContext.md`, `activeContext.md`, `systemPatterns.md`, `techContext.md`, `progress.md`.
2. Read `context.json`, `notes.md`, `resume.md`, and `prompt.md` from the bundle.
3. Update memory files:
   - `activeContext.md`: objective, latest decisions, blockers, next step.
   - `progress.md`: timestamped milestone entry.
   - `systemPatterns.md`: architecture or pattern decisions only.
   - `techContext.md`: environment or dependency constraints only.
4. Keep entries short and factual. Prefer intent over implementation details. Do not duplicate unchanged content.
5. If the workspace is not a git repository, warn the user that the exported memory files will not be version-controlled unless they take action.
