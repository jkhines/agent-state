# Agent State

Agent State provides cognitive load management for developers running multiple AI coding agents. When you have multiple agent sessions in flight and dozens of commits landing per day, Agent State gives you a single place to track what each task is doing, what decisions were made, and what to do next—without holding any of it in your head.

## Table of Contents

- [The Problem](#the-problem)
- [How It Works](#how-it-works)
- [Installation](#installation)
- [Usage](#usage)
  - [Commands](#commands)
  - [Typical Workflow](#typical-workflow)
- [Storage Layout](#storage-layout)
- [Comparison with Similar Tools](#comparison-with-similar-tools)
- [Contributing](#contributing)
- [License](#license)

## The Problem

The bottleneck in AI-assisted development is not the agent. It is the developer keeping track of everything the agents are doing.

Running four or five simultaneous agent sessions means four or five threads of decisions, progress, and unfinished work. If a conversation gets lost—context window fills, terminal crashes, session times out—you have to reconstruct what happened from commit diffs and memory. The next morning is worse: yesterday produced dozens of commits across multiple branches, and there is no record of which tasks are done, which are blocked, and which were abandoned mid-thought.

The agent does not remember. Git log does not capture intent. And your own memory does not scale to the parallelism that AI-assisted development makes possible.

## How It Works

Agent State organizes each task into a **bundle**—a self-contained directory that holds everything needed to understand and resume the work. Bundles live in `~/Documents/agent-state/`, outside your repository, so they never pollute version control.

A bundle contains:
- **prompt.md** — the objective and constraints
- **context.json** — repo path, branch, status, timestamps
- **notes.md** — running log of decisions and progress
- **resume.md** — structured handoff (current status, blockers, next actions)
- **attachments/** — copies of external files that travel with the bundle

The developer's workflow is two commands. `/state-start` loads a bundle into the agent so it picks up where the last session left off. `/state-save` writes the current state back before the session ends. Everything in between is normal work. `/state-summary` gives a cross-task overview so you can see all active work at a glance without context-switching into each session.

## Installation

```bash
git clone https://github.com/jkhines/agent-state.git
cd agent-state
bash setup.sh
```

The setup script configures git hooks for the repository. Commands are invoked as slash commands within your AI coding assistant.

## Usage

### Commands

| Command | Purpose |
|---|---|
| `/state-start` | Start a new task or resume an existing bundle |
| `/state-save` | Save session state with a checkpoint; optionally queue next command |
| `/state-attach` | Copy external files into the bundle so they persist across sessions |
| `/state-detach` | Remove attached files from the bundle (originals untouched) |
| `/state-files` | List all attachments and their status |
| `/state-summary` | Overview of all active bundles; flag stale work |
| `/state-archive` | Move a completed bundle to the archive |
| `/state-export` | Push durable decisions into repository memory documents |

### Typical Workflow

1. `/state-summary` — see what is active, what is stale, and what needs attention.
2. `/state-start` — pick a task and resume it. The agent reads the bundle and knows what happened last time.
3. Work normally across multiple sessions. Each task has its own bundle.
4. `/state-save` — checkpoint before ending each session. Optionally queue the next step: `/state-save run the integration tests`.
5. `/state-archive` — when a task is done, move it out of active work.

Tomorrow morning, `/state-summary` tells you exactly where everything stands—no git log archaeology required.

## Storage Layout

```text
~/Documents/agent-state/
  active/    -- in-progress bundles
  archive/   -- completed, paused, or cancelled bundles
  inbox/     -- loose files waiting to be filed
```

Bundles are named `<YYYY-MM-DD>-<repo-name>-<task-slug>-<agent-id>` for easy identification and sorting.

## Comparison with Similar Tools

Two widely-used projects solve related problems but focus on the agent's context window rather than the developer's cognitive load.

### Context Mode

[Context Mode](https://github.com/mksglu/context-mode) is an MCP server that indexes every file edit, git operation, and decision into a per-project SQLite database. When the context window compacts, it rebuilds working state by retrieving relevant events via full-text search. Its goal is extending the useful lifetime of a single session.

**Where Agent State differs:** Context Mode helps the agent remember within a session. Agent State helps the developer remember across sessions and across tasks. Context Mode solves a machine problem (context window limits). Agent State solves a human problem (tracking parallel workstreams). The two are complementary—Context Mode keeps your current session efficient while Agent State keeps you oriented across all of them.

### Continuous Claude

[Continuous Claude](https://github.com/parcadei/Continuous-Claude-v3) is a multi-agent orchestration system that uses ledgers and lifecycle hooks to maintain context across Claude Code sessions. It automates state capture and coordinates specialized sub-agents with isolated context windows.

**Where Agent State differs:** Continuous Claude automates state preservation through hooks and manages agent coordination. Agent State is deliberately simpler: explicit commands, plain files, no runtime. Continuous Claude captures what the agent did automatically. Agent State captures what the developer needs to know, when the developer asks for it. If you want always-on automated capture with multi-agent orchestration, Continuous Claude is more opinionated. If you want portable, human-readable state that works across any tool and keeps the developer in control, Agent State stays out of the way.

### Summary

| | Agent State | Context Mode | Continuous Claude |
|---|---|---|---|
| Core problem | Developer cognitive load | Agent context window limits | Agent session continuity |
| Primary user | The developer | The agent | The agent |
| State format | Plain Markdown and JSON | SQLite with FTS5 indexing | Ledgers and handoff documents |
| Automation | Explicit commands | MCP hooks (automatic) | Lifecycle hooks (automatic) |
| Agent support | Any agent that can read files | MCP-compatible agents | Claude Code |
| Runtime dependency | None | MCP server | Python runtime + hooks |

## Contributing

Contributions are welcome. Please open an issue or submit a pull request with your improvements.

## License

[CC BY 4.0](LICENSE)
