---
name: tmux-agent-bridge
description: Send work to another tmux-hosted coding agent or model, and verify the message was submitted, using a reusable helper instead of manual tmux send-keys.
---

# Tmux Agent Bridge

Use this skill when the user asks you to coordinate with another agent or model that is running in a tmux pane.

The target can be Codex, Claude, Cursor Agent, or any other terminal-based agent. The exact pane position can change. The rule is the same: find the pane, send the message, press Enter, and check the receipt when useful.

## Rule

Do not type raw `tmux send-keys` sequences manually for agent messages. Use the helper so the message is submitted with Enter and a short receipt check can be shown. The helper clears the current input line before paste by default, waits briefly before Enter, and retries Enter once if the message or a paste placeholder still appears near the pane input area. This avoids common failures where text appends to old input or is pasted but not submitted.

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

## Convergence loop

When the user asks to coordinate, review, compare opinions, or "use this skill" for another agent's input, do not treat the first send as completion.

Keep the conversation going until one of these terminal states is reached:

- Agreement: the other agent clearly agrees, approves, or says the result is stable enough.
- Concrete blocker: the other agent gives a blocker that needs user input, credentials, external access, or a decision outside the current scope.
- No response: the target does not produce a useful answer after a reasonable wait and one concise nudge.
- User override: the user asks to stop, switch tasks, or take a different direction.

Loop shape:

1. Send a compact request with the goal, scope, evidence needed, and expected verdict.
2. Wait and capture the target pane output. Waiting can mean checking back periodically or after doing other useful work. Do not block synchronously on long-running agent work.
3. Read the actual response, not only the helper receipt.
4. If the other agent flags a concrete issue, fix it or respond with evidence.
5. Send the update back for re-review.
6. Repeat until agreement or a terminal blocker.
7. Report the final shared state to the user, including what both agents agreed on and any remaining caveat.

Do not loop forever. If the other agent is busy, silent, or only gives vague feedback, nudge once. Then report that the review is pending and continue only if the user wants more waiting.

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
- prompt-line clearing before paste,
- safe paste through a tmux buffer,
- separate Enter submit,
- small paste-to-submit delay,
- one guarded Enter retry when the message or a paste placeholder still appears near the input area,
- short receipt capture.

## Splitting work

When a task is large enough to involve another agent, do not only hand it off. First look for a useful split that improves speed, quality, or verification.

- Decompose first: identify which parts are genuinely independent and which parts must happen in order. Split only the independent parts.
- Assign by strength: give each agent work that fits its current context, access, or ability to verify. Do not split by line count.
- Make boundaries explicit: state what this agent owns, what the other agent owns, and what neither should touch yet.
- State the handback contract: define what done means, what evidence is expected back, and whether the sender is blocked or can continue in parallel.
- Cross-check results: when work is split, have the agent that did not perform the work spot-check or re-review before the combined result is called done.
- Check capacity first: do not pile a new task onto an agent that is still deep in another task unless it is clearly safe to queue.
- Keep dispatch human-directed: the script must not become an automatic dispatcher, queue, or scheduler. Splitting is a judgment call made before using `tmux-agent-send`.

## Safety

The helper only sends text and presses Enter in the target pane. It does not grant permission for the other agent to do actions outside the user's current scope.

If the delegated task would mutate external systems, make the authorization and stop condition explicit in the message.
