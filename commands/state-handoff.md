---
command: /state-handoff
description: Creates a standardized handoff packet for another agent session
alwaysApply: false
---

Build a concise, actionable handoff so another agent can continue immediately.

## Inputs

All inputs have defaults and only need to be specified when overriding.

- `bundle_path` -- absolute path to an active bundle. Default: most recent active bundle by `last_updated`.
- `target_agent` -- agent identifier to assign

## Behavior

Read `prompt.md`, `context.json`, `notes.md`, `resume.md`, and any patch artifacts from the bundle.

Write `<bundle_path>/handoff.md` with these sections:

- **Task**: one-sentence objective.
- **Current State**: done vs. pending.
- **Decisions**: key decisions and rationale.
- **Blockers**: unresolved issues.
- **Artifacts**: paths to patches/archives.
- **Verification**: commands to validate progress.
- **Next Actions**: ordered checklist, first command ready to run.

If `target_agent` is provided, add `Assigned to: <target_agent>` at the top. Write `Unknown` for any missing
information -- never assume.
