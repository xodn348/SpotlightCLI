# SpotlightCLI

A macOS floating panel for interactive multi-turn AI coding sessions. Summon your AI CLI tool from anywhere with a global hotkey — no terminal switching required.

## Demo

<!-- Record a demo and replace this placeholder -->
<!-- To record: QuickTime → File → New Screen Recording → select panel area → save as demo.gif -->
<!-- Or: brew install ffmpeg && screencapture -v demo.mov -->

> **TODO**: Add demo.gif here after recording
>
> ```
> ⌘+Shift+Space  →  panel appears
> Type a question →  streamed response
> Escape          →  panel hides
> ```

## Features

- **Global hotkey** — Toggle the panel from any app with `⌘ Shift Space`
- **Floating panel** — Stays on top, no Dock icon, never steals focus
- **Multi-turn chat** — Full conversation history per session
- **Streaming output** — See responses as they arrive, with ANSI stripping
- **Markdown rendering** — Code blocks, bold, inline code rendered properly
- **Any CLI tool** — Works with `opencode`, `claude`, `codex`, or any interactive CLI
- **JSON config** — Customize hotkey, CLI command, working directory

## Requirements

- macOS 13 (Ventura) or later
- Swift 5.9+ / Xcode 15+
- An AI CLI tool installed (`opencode`, `claude`, etc.)

## Quick Start

### 1. Clone and build

```bash
git clone https://github.com/xodn348/SpotlightCLI.git
cd SpotlightCLI
swift build -c release
```

### 2. Grant Accessibility permission

The global hotkey requires Accessibility access:

1. Open **System Settings → Privacy & Security → Accessibility**
2. Toggle **ON** for Terminal (or whichever app you run SpotlightCLI from)

### 3. Fix hotkey conflict (if needed)

`⌘ Shift Space` may conflict with macOS input source switching:

1. Open **System Settings → Keyboard → Keyboard Shortcuts → Input Sources**
2. Disable "Select the previous input source"

### 4. Run

```bash
.build/release/SpotlightCLI
```

The app runs silently in the background (no Dock icon). Press **`⌘ Shift Space`** to open the panel.

### 5. Use it

| Key | Action |
|-----|--------|
| `⌘ Shift Space` | Toggle panel open/closed |
| `Return` | Send message |
| `Escape` | Hide panel |

## Configuration

Config file is auto-created on first run. Edit it to customize:

```
~/.config/spotlight-cli/config.json
```

```json
{
  "cliTool": "opencode",
  "cliArgs": [],
  "workingDirectory": "/Users/you/projects/myapp",
  "hotkey": {
    "key": "space",
    "modifiers": ["command", "shift"]
  },
  "responseTimeout": 1.5,
  "maxMessages": 100
}
```

### Config options

| Field | Default | Description |
|-------|---------|-------------|
| `cliTool` | `"opencode"` | CLI tool name or full path |
| `cliArgs` | `[]` | Extra arguments passed to the CLI |
| `workingDirectory` | `~` | Working directory for the CLI process |
| `hotkey.key` | `"space"` | Trigger key: `space`, `k`, `l`, `return`, etc. |
| `hotkey.modifiers` | `["command","shift"]` | Modifier keys: `command`, `shift`, `option`, `control` |
| `responseTimeout` | `1.5` | Seconds of silence before response is considered complete |
| `maxMessages` | `100` | Max messages to keep in conversation history |

### Use with claude or codex

```json
{
  "cliTool": "claude",
  "cliArgs": ["--dangerously-skip-permissions"]
}
```

```json
{
  "cliTool": "codex",
  "cliArgs": ["--quiet"]
}
```

## Recording a Demo

To add a demo GIF to this README:

**Option A — QuickTime**
1. Open QuickTime → File → New Screen Recording
2. Click the dropdown arrow → select your microphone (optional)
3. Drag to select the SpotlightCLI panel area
4. Record your session, stop, and save
5. Convert: `ffmpeg -i demo.mov -vf "fps=15,scale=800:-1" demo.gif`

**Option B — screencapture (built-in)**
```bash
# Start recording (Ctrl+C to stop)
screencapture -v demo.mov

# Convert to GIF
ffmpeg -i demo.mov -vf "fps=15,scale=800:-1:flags=lanczos" -loop 0 demo.gif
```

**Option C — Kap** (free, macOS)
```bash
brew install --cask kap
```
Open Kap → record → export as GIF.

Once you have `demo.gif`, place it in the repo root and update the Demo section above:
```markdown
![SpotlightCLI Demo](demo.gif)
```

## Architecture

```
SpotlightCLI/
├── AppDelegate.swift          # NSApplication entry, LSUIElement setup
├── AppCoordinator.swift       # Top-level wiring: hotkey → panel → process
├── FloatingPanel.swift        # NSPanel subclass (nonactivating, floating)
├── HotkeyManager.swift        # Global hotkey via soffes/HotKey (Carbon)
├── ProcessManager.swift       # Foundation.Process + Pipe, streaming stdout
├── ConversationViewModel.swift # @MainActor state: messages, streaming flag
├── ConversationView.swift     # SwiftUI scroll view for message list
├── InputFieldView.swift       # Text input, Return to submit
├── MarkdownRenderer.swift     # AttributedString markdown → NSFont monospace
├── ANSIStripper.swift         # Strips ANSI escape codes from CLI output
├── Message.swift              # Message model (user / assistant / error)
├── Config.swift               # JSON config with defaults
└── main.swift                 # Bootstrap
```

**Key design decisions:**
- `LSUIElement = YES` — no Dock icon, background-only app
- `NSPanel` with `.nonactivatingPanel` — panel appears without stealing focus from your editor
- `RegisterEventHotKey` (via HotKey library) — system-wide Carbon hotkey
- 1.5s silence timeout — heuristic to detect when the CLI has finished streaming

## Troubleshooting

**Hotkey doesn't work**
- Grant Accessibility permission (see Quick Start step 2)
- Check for hotkey conflict with Input Sources (step 3)
- Restart the app after granting permission

**Panel doesn't appear**
- The app is running in the background — check Activity Monitor for `SpotlightCLI`
- Make sure you press the correct hotkey combination

**CLI tool not found**
- Verify the tool is in your PATH: `which opencode`
- Use the full path in config: `"cliTool": "/opt/homebrew/bin/opencode"`

## License

MIT
