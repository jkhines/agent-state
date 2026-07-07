---
name: state-save
description: >-
  Saves session state with a checkpoint and a clear resume point. Use when the
  user invokes /state-save, ends a session, checkpoints progress, or queues the
  next command for resume.
disable-model-invocation: true
---

# State Save

End a session cleanly with a checkpoint and an unambiguous restart point. Incorporates save and status refresh in one step.

## Execution requirement

This skill MUST write files to disk. Every invocation must produce a bundle directory under `${HOME}/Documents/agent-state/active/` with updated `context.json`, `notes.md`, and `resume.md`. Printing a summary to the conversation without writing these files is not valid execution. If you find yourself composing a summary without having written to the bundle directory, stop and start over from step 1 of the Behavior section.

## Inputs

All inputs have defaults and only need to be specified when overriding.

- **Positional**: any text after `/state-save` that is not a named parameter is the next command to run on resume. Example: `/state-save run the integration tests`
- `bundle_path` — absolute path to the active bundle. Default: [Bundle Selection](reference.md).
- `status` — `active` (default), `blocked`, or `ready-for-review`
- `blockers` — short description
- `progress_note` — short description
- `target_agent` — optional agent identifier to assign for the next session

## Behavior

1. Check for an active bundle using [Bundle Selection](reference.md). If no bundle is found, run state-start to create one before continuing.
2. Update `context.json` with status, `last_updated`, next command (positional arg), blockers, and `target_agent` (if provided).
3. Refresh attachments: if `attachments.json` exists in the bundle and is non-empty, re-copy each file from its `source` path into the bundle's `attachments/` directory. If a source file no longer exists, log a warning in `notes.md` and keep the last bundled copy.
4. Append a timestamped log entry to `notes.md` with progress and blockers.
5. Read `prompt.md`, `context.json`, `notes.md`, and any patch artifacts from the bundle, then rewrite `resume.md` with these sections:
   - **Objective**: one-sentence task description.
   - **Status**: current status and what is done vs. pending.
   - **Decisions**: key decisions made and their rationale.
   - **Blockers**: unresolved issues. Write `None` if clear.
   - **Artifacts**: paths to patches, outputs, or other generated files.
   - **Attachments**: list of attached external files (from `attachments.json`) with original source paths.
   - **Verification**: commands to validate progress so far.
   - **Next Actions**: ordered checklist of remaining steps, first command ready to run.
   - If `target_agent` is set, add `Assigned to: <target_agent>` at the top.
   - Write `Unknown` for any section where information is missing — never assume.
6. Verify the save: confirm that `context.json`, `notes.md`, and `resume.md` exist in the bundle directory and that `last_updated` in `context.json` reflects the current timestamp. If any file is missing, the save failed — report the error and do not continue.
7. If `status=ready-for-review`, suggest state-archive.
8. If no next command was provided, note it in the output as a reminder.
