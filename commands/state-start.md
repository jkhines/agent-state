---
command: /state-start
description: Starts a focused work session without requiring a full summary
alwaysApply: false
---

Resume work on one target bundle quickly. Does not run `/state-summary` by default.

## Optional inputs

- `bundle_path` -- skip selection if known
- `show_summary` -- if `true`, also run `/state-summary`

## Behavior

1. If no `bundle_path`, list active bundles sorted by `last_updated` and select the most recent.
2. Read `resume.md` and `context.json` from the target bundle.
3. Output a start brief: objective, status, first command to run, next 2 actions.
4. If `show_summary=true`, run `/state-summary` and include the report path.
