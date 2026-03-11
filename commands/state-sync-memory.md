---
command: /state-sync-memory
description: Syncs temporary bundle decisions into project memory documents
alwaysApply: false
---

## Sync Bundle to Memory Docs

Copies durable context from a temporary state bundle into repository memory documents so future sessions can
resume with both code state and decision history.

## Inputs

When `/state-sync-memory` is invoked:

1. Require:
   - `repo_path` (absolute path to repository)
   - `bundle_path` (absolute path in `/home/jkhines/Documents/agent-state/active/...`)
2. Optional:
   - `memory_dir` (default: `<repo_path>/memory-bank`)
   - `create_if_missing` (`true` or `false`, default `true`)

## Execution Steps

1. Validate paths:
   - Ensure `repo_path` exists.
   - Ensure `bundle_path` exists and has at least `notes.md` and `resume.md`.
2. Resolve memory directory:
   - Use `memory_dir` if provided, otherwise `<repo_path>/memory-bank`.
   - If directory is missing and `create_if_missing=true`, create it.
3. Ensure core memory files exist:
   - `projectbrief.md`
   - `productContext.md`
   - `activeContext.md`
   - `systemPatterns.md`
   - `techContext.md`
   - `progress.md`
4. Read bundle sources:
   - `context.json`, `notes.md`, `resume.md`, and `prompt.md` if present.
5. Update memory files with concise entries:
   - `activeContext.md`: current objective, latest decisions, blockers, and exact next step from `resume.md`.
   - `progress.md`: milestone entry with timestamp and what changed since last checkpoint.
   - `systemPatterns.md`: only architecture or pattern decisions that should persist.
   - `techContext.md`: only environment, tooling, or dependency constraints discovered during work.
6. Rules for content quality:
   - Keep entries short and factual.
   - Avoid file-by-file diff details.
   - Prefer intent and rationale over implementation minutiae.
   - Do not duplicate unchanged content.
7. Return:
   - Files updated
   - Brief summary of key synced decisions

## Example Commands

```bash
repo="/home/jkhines/src/my-repo"
bundle="/home/jkhines/Documents/agent-state/active/2026-03-10-my-repo-task-agent3"
memory="$repo/memory-bank"
mkdir -p "$memory"
touch "$memory"/{projectbrief.md,productContext.md,activeContext.md,systemPatterns.md,techContext.md,progress.md}
printf "\n## %s\n- Synced from bundle: %s\n" "$(date -Iseconds)" "$bundle" >> "$memory/progress.md"
```
