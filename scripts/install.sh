#!/usr/bin/env bash
set -e
REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"

for TARGET in "$HOME/.config/opencode/skills" "$HOME/.agents/skills" "$HOME/.gemini/config/skills" "$HOME/.claude/skills"; do
  mkdir -p "$TARGET"
  cp -r "$REPO_ROOT/skills/cloudflare-workers-d1" "$TARGET/"
  cp -r "$REPO_ROOT/skills/cloudflare-workers-d1-en" "$TARGET/"
  echo "✅ Installed Cloudflare skills to: $TARGET"
done

echo ""
echo "🎉 Installation complete! Launch OpenCode (with AGENTS.md in your project root) to use cloudflare-workers-d1 or cloudflare-workers-d1-en."
