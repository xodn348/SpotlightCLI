#!/bin/bash
# SpotlightCLI Setup
# Creates Automator app launchers in /Applications/ for oc, claude, and codex.
# After running, search for them in Spotlight (⌘+Space).

set -e

create_launcher() {
  local name="$1"
  local cmd="$2"
  local dest="/Applications/${name}.app"

  echo "Creating ${name}.app..."
  tmpfile=$(mktemp /tmp/launcher_XXXXXX.applescript)
  cat > "$tmpfile" <<APPLESCRIPT
tell application "Terminal"
    activate
    do script "${cmd}"
end tell
APPLESCRIPT
  osacompile -o "$dest" "$tmpfile"
  rm "$tmpfile"
  echo "  → $dest"
}

create_launcher "OpenCode"    "oc"
create_launcher "Claude Code" "claude"
create_launcher "Codex"       "codex"

echo ""
echo "Done! Open Spotlight (⌘+Space) and search for OpenCode, Claude Code, or Codex."
