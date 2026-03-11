---
command: /state-handoff
description: Creates a standardized handoff packet for another agent session
alwaysApply: false
---

## Create Agent Handoff Packet

Builds a concise, actionable handoff from an active state bundle so another agent can continue work immediately.

## Inputs

When `/state-handoff` is invoked:

1. Require:
   - `bundle_path` (absolute path in `/home/jkhines/Documents/agent-state/active/...`)
2. Optional:
   - `target_agent` (example: `agent4`)
   - `output_file` (default: `<bundle_path>/handoff.md`)

## Execution Steps

1. Validate:
   - Ensure `bundle_path` exists.
   - Ensure at least one of `resume.md`, `notes.md`, or `context.json` exists.
2. Gather handoff sources:
   - `prompt.md`
   - `context.json`
   - `notes.md`
   - `resume.md`
   - patch artifacts (`repo.patch`, `repo.staged.patch`, `untracked.tar.gz`) if present.
3. Generate `handoff.md` with this structure:
   - `Task`: one sentence objective.
   - `Current State`: what is done and what is pending.
   - `Decisions`: important decisions and why.
   - `Blockers`: unresolved issues and required inputs.
   - `Artifacts`: paths to patch/archive files.
   - `Verification`: exact commands to validate current progress.
   - `Next Actions`: ordered checklist with the first command ready to run.
4. Safety and clarity rules:
   - Make no assumptions not supported by source files.
   - If information is missing, write `Unknown` explicitly.
   - Keep each section concise and operational.
5. If `target_agent` is provided:
   - Add a top line: `Assigned to: <target_agent>`.
6. Return:
   - Handoff file path
   - Short summary of immediate next action

## Example Commands

```bash
bundle="/home/jkhines/Documents/agent-state/active/2026-03-10-my-repo-task-agent3"
out="$bundle/handoff.md"
{
  echo "# Agent Handoff"
  echo
  echo "Task: Unknown"
  echo
  echo "Current State:"
  echo "- Unknown"
  echo
  echo "Next Actions:"
  echo "1. Open $bundle/resume.md and run the first command listed."
} > "$out"
```
