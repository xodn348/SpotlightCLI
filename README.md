# SpotlightCLI

Launch AI coding tools directly from macOS Spotlight — no Accessibility permission required.

## How it works

Creates three `.app` launchers in `/Applications/` using AppleScript + `osacompile`. macOS automatically indexes any app in `/Applications/`, so they appear instantly in Spotlight (⌘+Space).

| Spotlight search | Opens |
|-----------------|-------|
| `OpenCode` | Terminal running `oc` |
| `Claude Code` | Terminal running `claude` |
| `Codex` | Terminal running `codex` |

## Quick Start

```bash
git clone https://github.com/xodn348/SpotlightCLI.git
cd SpotlightCLI
chmod +x setup.sh
./setup.sh
```

Then press **⌘+Space**, type `opencode` (or `claude code` / `codex`), and hit Return.

## Requirements

- macOS (any recent version)
- `oc`, `claude`, and/or `codex` installed and in your PATH
- No Accessibility permission needed

## What setup.sh does

```bash
osacompile -o "/Applications/OpenCode.app"    # runs: oc
osacompile -o "/Applications/Claude Code.app" # runs: claude
osacompile -o "/Applications/Codex.app"       # runs: codex
```

Each app is a minimal AppleScript bundle that tells Terminal to open and run the command.

## Customization

To add your own launcher, edit `setup.sh` and add:

```bash
create_launcher "MyTool" "mytool-command"
```

Then re-run `./setup.sh`.

## License

MIT
