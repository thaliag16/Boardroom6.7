#!/usr/bin/env bash
# Boardroom installer — links /boardroom and the gstack-partner agent into Claude Code.
#   ./setup.sh             install (symlinks)
#   ./setup.sh --uninstall
set -euo pipefail
REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SK="$HOME/.claude/skills/boardroom"
AG="$HOME/.claude/agents/gstack-partner.md"

if [[ "${1:-}" == "--uninstall" ]]; then
  for t in "$SK" "$AG"; do [[ -L "$t" ]] && rm "$t" && echo "  - $t"; done
  echo "Boardroom uninstalled. Transcripts in ~/.boardroom were left alone."
  exit 0
fi

mkdir -p "$HOME/.claude/skills" "$HOME/.claude/agents" "$HOME/.boardroom"
for pair in "$REPO/skills/boardroom:$SK" "$REPO/agents/gstack-partner.md:$AG"; do
  src="${pair%%:*}"; dst="${pair#*:}"
  if [[ -e "$dst" && ! -L "$dst" ]]; then echo "  ! $dst exists and isn't a symlink; skipping" >&2; continue; fi
  ln -sfn "$src" "$dst"; echo "  + $dst"
done

echo
echo "Panel check:"
for a in paul-graham damodaran gstack-partner; do
  if [[ -e "$HOME/.claude/agents/$a.md" ]]; then echo "  ✓ $a"; else echo "  ✗ $a (not installed)"; fi
done
[[ -d "$HOME/.claude/skills/gstack/office-hours" ]] && echo "  ✓ gstack skills found" || echo "  ✗ gstack not found (gstack-partner needs it)"
echo
echo "Restart Claude Code, then: /boardroom <your question>"
