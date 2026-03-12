---
command: /state-summary
description: Builds a concise summary of active and recently archived work bundles
alwaysApply: false
---

Generate a restart-friendly overview of all bundles. Optionally flag stale bundles for cleanup.

## Optional inputs

- `state_root` -- default: `${HOME}/Documents/agent-state`
- `days` -- recent archive window, default: `2`
- `prune` -- if `true`, flag stale bundles (inactive >= `stale_days`) with suggested actions
- `stale_days` -- staleness threshold when pruning, default: `3`
- `auto_archive_paused` -- if `true` and `prune=true`, auto-finalize stale paused bundles

## Behavior

1. Scan `active/` bundles. For each, read `context.json`, `resume.md`, `notes.md`. Extract: repo, branch, agent, status, last_updated, blockers, next command.
2. Scan `archive/` bundles modified within `days`.
3. Display a markdown summary with sections:
   - **Today Focus**: active bundles sorted by recency.
   - **Needs Attention**: bundles missing a next step or with stale timestamps.
   - **Recently Completed**: archived bundles within window.
   - **Suggested First Task**: most recent active bundle with a clear next action.
4. If `prune=true`, append a **Prune Candidates** section. For each stale bundle, suggest: `refresh` (has next command), `archive` (completed/paused/ready-for-review), `cancel` (no progress), or `needs-triage` (missing metadata). If `auto_archive_paused=true`, run `/state-archive` on stale paused bundles.
