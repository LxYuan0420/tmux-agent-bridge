# tmux-agent-bridge

Small tmux bridge for sending messages to coding agents that run in tmux panes.

It is useful when you run several agents at the same time, such as Codex, Claude, Cursor Agent, or another terminal agent. It avoids the common mistake where text is pasted into a pane but not submitted.

## What it does

- Lists available tmux panes.
- Sends a message to a target pane.
- Optionally adds a routing prefix, such as `FOR CLAUDE:`.
- Presses Enter after pasting the message.
- Waits briefly before Enter, then retries Enter once if the message still appears near the pane input area.
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

Use environment defaults:

```bash
export AGENT_TMUX_TARGET=%64
export AGENT_TMUX_CAPTURE_LINES=20
export AGENT_TMUX_SUBMIT_DELAY=0.2
export AGENT_TMUX_RECEIPT_DELAY=0.2
export AGENT_TMUX_RETRY_LINES=5
tmux-agent-send --prefix "FOR CLAUDE:" "Please continue the review."
```

## Design notes

The best existing tools for multi-agent tmux work tend to include session managers, labels, file-backed messages, worktree support, dashboards, or queues. This bridge takes only the parts needed for fast daily coordination:

- stable target selection,
- safe paste through a tmux buffer,
- explicit Enter submit,
- small paste-to-submit delay,
- one guarded Enter retry when the message still appears near the input area,
- short receipt capture,
- quiet mode for token control.

If you need a full multi-agent workspace manager, use a larger tool. If you only need reliable pane-to-pane communication, use this.
