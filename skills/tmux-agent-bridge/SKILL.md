---
name: tmux-agent-bridge
description: Send work to another tmux-hosted coding agent or model, and verify the message was submitted, using a reusable helper instead of manual tmux send-keys.
---

# Tmux Agent Bridge

Use this skill when the user asks you to coordinate with another agent or model that is running in a tmux pane.

The target can be Codex, Claude, Cursor Agent, or any other terminal-based agent. The exact pane position can change. The rule is the same: find the pane, send the message, press Enter, and check the receipt when useful.

## Rule

Do not type raw `tmux send-keys` sequences manually for agent messages. Use the helper so the message is submitted with Enter and a short receipt check can be shown. This avoids the common failure where text is pasted into the pane but not submitted.

```bash
tmux-agent-send --target TARGET --prefix PREFIX "message"
```

## How to use

1. If the target pane is unknown, list panes:

```bash
tmux-agent-send --list
```

2. Choose a stable target. Prefer pane IDs such as `%64` when available, because they are less ambiguous than visual pane position.
3. Use a short routing prefix when helpful, for example `FOR CLAUDE:` or `FOR CODEX:`.
4. Keep the handoff compact: goal, scope, constraints, expected output, and stop condition.
5. Read the helper's receipt output. If it only shows typed text and no agent processing, inspect the pane or send again.

## Token discipline

- Prefer one precise message over many partial messages.
- Ask the other agent for exact evidence, links, tests, and blockers.
- Do not paste long logs unless the other agent needs them; point to files or commands instead.
- Use `--quiet` or `--lines 0` when receipt output is not needed.

## Design boundary

Keep this as a small bridge, not a full orchestration framework.

Larger tmux agent tools can add useful ideas such as queues, labels, dashboards, hooks, worktrees, and status daemons. Use those only when the user asks for a larger multi-agent system.

For day-to-day handoffs, keep the best low-cost parts only:

- stable target pane,
- optional prefix,
- safe paste through a tmux buffer,
- separate Enter submit,
- short receipt capture.

## Safety

The helper only sends text and presses Enter in the target pane. It does not grant permission for the other agent to do actions outside the user's current scope.

If the delegated task would mutate external systems, make the authorization and stop condition explicit in the message.
