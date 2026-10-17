#!/usr/bin/env bash
set -e
REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"

for TARGET in "$HOME/.gemini/config/skills" "$HOME/.agents/skills" "$HOME/.claude/skills"; do
  mkdir -p "$TARGET"
  cp -r "$REPO_ROOT/skills/cloudflare-workers-d1" "$TARGET/"
  cp -r "$REPO_ROOT/skills/cloudflare-workers-d1-en" "$TARGET/"
  echo "✅ Installed Cloudflare skills to: $TARGET"
done

echo ""
echo "🎉 Installation complete! Open a new chat to use /cloudflare-workers-d1 or /cloudflare-workers-d1-en."
