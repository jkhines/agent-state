---
command: /state-sync-memory
description: Syncs temporary bundle decisions into project memory documents
alwaysApply: false
---

Copy durable decisions from a temporary bundle into repository memory documents for future sessions.

## Required inputs

- `repo_path` -- absolute path to the repository
- `bundle_path` -- absolute path to the active bundle

## Optional inputs

- `memory_dir` -- default: `<repo_path>/memory-bank`

## Behavior

1. Ensure `memory_dir` exists (create if missing) with core files: `projectbrief.md`, `productContext.md`, `activeContext.md`, `systemPatterns.md`, `techContext.md`, `progress.md`.
2. Read `context.json`, `notes.md`, `resume.md`, and `prompt.md` from the bundle.
3. Update memory files:
   - `activeContext.md`: objective, latest decisions, blockers, next step.
   - `progress.md`: timestamped milestone entry.
   - `systemPatterns.md`: architecture or pattern decisions only.
   - `techContext.md`: environment or dependency constraints only.
4. Keep entries short and factual. Prefer intent over implementation details. Do not duplicate unchanged content.
