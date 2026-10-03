#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
bin_dir="${PREFIX:-${HOME}/.local}/bin"
codex_home="${CODEX_HOME:-${HOME}/.codex}"
skill_dir="${codex_home}/skills/tmux-agent-bridge"

mkdir -p "${bin_dir}" "$(dirname "${skill_dir}")"
install -m 0755 "${repo_dir}/bin/tmux-agent-send" "${bin_dir}/tmux-agent-send"

rm -rf "${skill_dir}"
cp -R "${repo_dir}/skills/tmux-agent-bridge" "${skill_dir}"

printf 'installed: %s\n' "${bin_dir}/tmux-agent-send"
printf 'installed: %s\n' "${skill_dir}"
printf 'try: tmux-agent-send --list\n'
