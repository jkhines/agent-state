# Bundle Selection

Canonical source for locating the active bundle. Other state skills reference this section.

When `bundle_path` is not provided, resolve the current `repo_path` and `branch` using [Workspace Resolution](../state-start/reference.md), and `agent_id` (see Agent ID Derivation in that file). Then:

1. Exact match on repo_path + branch + agent_id — use it.
2. If no exact match, list active bundles matching repo_path + branch. Present the list and ask the user which bundle to target. Do not silently pick one.
3. If no bundles match repo_path + branch, no bundle is found.
