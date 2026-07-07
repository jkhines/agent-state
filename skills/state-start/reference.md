# Workspace Resolution

Canonical source for resolving workspace context. Other state skills reference this section.

- `repo_path`: run `git rev-parse --show-toplevel`. If that fails (not a git repository), use the current working directory (`pwd`).
- `branch`: run `git branch --show-current`. If that fails, use `none`.

## Agent ID Derivation

Derive `agent_id` as the first 8 characters of the current session identifier:

- **Claude Code**: find the most recently modified `.jsonl` file in `~/.claude/projects/<project-hash>/` where `<project-hash>` is the resolved `repo_path` with `/` replaced by `-` and the leading `-` stripped. The file's basename (without `.jsonl`) is the session UUID.
- **Cursor CLI (cursor-agent)**: read `agentId` from the current conversation's `store.db` metadata (key `0` in the `meta` table, hex-decoded JSON).
- **Cursor IDE (Composer)**: read `composerId` from the current Composer session in the workspace's `state.vscdb` (`composer.composerData` key in `ItemTable`).
