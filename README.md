# tmux-agent-bridge

A small bridge that lets independent terminal agents — Codex, Claude, Cursor Agent, or any other agent running in its own tmux pane — coordinate with each other as peers: review each other's work, split tasks, and converge on an answer, without a human relaying every message by hand.

## Why not just use native subagents?

If you are spawning a helper inside one agent product, use that product's native subagent or task tool. It is simpler. The parent owns the context, lifecycle, and permissions.

`tmux-agent-bridge` is for a different shape of work: two separate agent sessions already running in tmux.

For example, Claude Code and Codex may each be hours deep in their own context. Each may have different tools, files, permissions, or judgment. Neither is the parent. Neither can call the other through a shared API.

This bridge gives those independent sessions a small, reliable way to talk, review each other's work, split tasks, and converge.

If your agents are not independent peers, you probably do not need this.

## What it does

- Connects independent coding-agent panes inside one tmux session.
- Lets the active agent coordinate, delegate, split work, request review, and converge with the other agents.
- Keeps the terminal plumbing reliable in the background: pane discovery, safe paste, Enter submit, retry, and receipt check.

## Install

```bash
git clone https://github.com/LxYuan0420/tmux-agent-bridge.git
cd tmux-agent-bridge
./install.sh
```

## Usage

```text
/tmux-agent-bridge work with the other agents in this tmux session to complete this task
```

That starts the bridge: agents discover each other, coordinate inside the approved task, split useful work, cross-review, and loop until agreement or a real blocker.
