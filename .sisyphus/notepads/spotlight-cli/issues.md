
- 2026-04-13 F4: Default hotkey is noncompliant and likely broken in practice: `HotkeyConfig.default` uses `key: "k"` plus modifier `"cmd"`, while `HotkeyManager` only maps `"command"`.
- 2026-04-13 F4: Multi-turn UI flow is broken after the first response because AppCoordinator sets `viewModel.isStreaming = true` and never clears it on normal response completion, leaving InputFieldView disabled.
- 2026-04-13 F4: Task scope gaps remain in T2/T6/T8/T9/T10/T11 even though build/tests pass.
