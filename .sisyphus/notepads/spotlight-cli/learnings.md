
- 2026-04-13 F4: Passing `swift test` did not guarantee scope compliance; the audit found multi-turn UI state and hotkey-default mismatches despite 65/65 passing tests.
- 2026-04-13 F4: In this codebase, `ConversationViewModel.isStreaming` and `ProcessManager.isResponseStreaming` drift apart because there is no response-complete callback from ProcessManager back to AppCoordinator.
