# tmux-agent-bridge

A small bridge that lets independent terminal agents — Codex, Claude, Cursor Agent, or any other agent running in its own tmux pane — coordinate with each other as peers: review each other's work, split tasks, and converge on an answer, without a human relaying every message by hand.

## Why not just use native subagents?

If you are spawning a helper inside one agent product, use that product's native subagent or task tool. It is simpler. The parent owns the context, lifecycle, and permissions.

`tmux-agent-bridge` is for a different shape of work: two separate agent sessions already running in tmux.

For example, Claude Code and Codex may each be hours deep in their own context. Each may have different tools, files, permissions, or judgment. Neither is the parent. Neither can call the other through a shared API.

This bridge gives those independent sessions a small, reliable way to talk, review each other's work, split tasks, and converge.

If your agents are not independent peers, you probably do not need this.

## What it does

- Lists available tmux panes.
- Sends a message to a target pane.
- Optionally adds a routing prefix, such as `FOR CLAUDE:`.
- Treats agent panes in the same active tmux session as standing-connected for the current user-approved work scope.
- Supports agent-to-agent review, task splitting, and convergence loops through the installed skill guidance.
- Clears the current input line before paste by default, so messages do not append to half-typed text.
- Presses Enter after pasting the message.
- Waits briefly before Enter, then retries Enter once if the message or a paste placeholder still appears near the pane input area.
- Shows a short receipt from the target pane.

## What it does not do

- No daemon.
- No queue system.
- No dashboard.
- No git worktree manager.
- No agent permission model.

Those are useful in larger orchestration tools, but this project keeps the daily handoff path small and reliable.

## Install

```bash
git clone https://github.com/LxYuan0420/tmux-agent-bridge.git
cd tmux-agent-bridge
./install.sh
```

This installs:

- `tmux-agent-send` into `~/.local/bin`
- the Codex skill into `~/.codex/skills/tmux-agent-bridge`

## Usage

List panes:

```bash
tmux-agent-send --list
```

Send a message:

```bash
tmux-agent-send --target %64 --prefix "FOR CLAUDE:" "Please review the current diff and report blockers only."
```

Use stdin:

```bash
printf '%s\n' "Please check the latest logs and summarize the failure." \
  | tmux-agent-send --target %64 --prefix "FOR AGENT:"
```

Reduce output:

```bash
tmux-agent-send --target %64 --lines 0 "Status?"
tmux-agent-send --target %64 --quiet "Status?"
```

Keep existing input:

```bash
tmux-agent-send --target %64 --no-clear-input "Append only if you really mean to."
```

Use environment defaults:

```bash
export AGENT_TMUX_TARGET=%64
export AGENT_TMUX_CAPTURE_LINES=20
export AGENT_TMUX_CLEAR_INPUT=1
export AGENT_TMUX_SUBMIT_DELAY=0.2
export AGENT_TMUX_RECEIPT_DELAY=0.2
export AGENT_TMUX_RETRY_LINES=5
tmux-agent-send --prefix "FOR CLAUDE:" "Please continue the review."
```

## Design notes

The best existing tools for multi-agent tmux work tend to include session managers, labels, file-backed messages, worktree support, dashboards, or queues. This bridge takes only the parts needed for fast daily coordination:

- stable target selection,
- prompt-line clearing before paste,
- safe paste through a tmux buffer,
- explicit Enter submit,
- small paste-to-submit delay,
- one guarded Enter retry when the message or a paste placeholder still appears near the input area,
- short receipt capture,
- quiet mode for token control.

If you need a full multi-agent workspace manager, use a larger tool. If you only need reliable pane-to-pane communication, use this.
