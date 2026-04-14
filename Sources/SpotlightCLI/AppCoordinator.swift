import AppKit
import SwiftUI

@MainActor
final class AppCoordinator: ObservableObject {
    private var panel: FloatingPanel?
    private let processManager: ProcessManager
    private let hotkeyManager: HotkeyManager
    private let viewModel: ConversationViewModel
    private var config: Config = .default

    init() {
        processManager = ProcessManager()
        hotkeyManager = HotkeyManager(config: Config.HotkeyConfig(key: "space", modifiers: ["command", "shift"]))
        viewModel = ConversationViewModel()
    }

    func setup() {
        do {
            config = try Config.load()
        } catch {
            config = .default
        }

        hotkeyManager.register(config: config.hotkey)

        processManager.setResponseTimeout(config.responseTimeout)

        let contentView = ConversationPanelView(
            viewModel: viewModel,
            onSubmit: { [weak self] text in
                self?.handleSubmit(text)
            }
        )

        panel = FloatingPanel(contentView: contentView)

        panel?.registerEscapeHandler { [weak self] in
            self?.hidePanel()
        }

        hotkeyManager.onToggle = { [weak self] in
            self?.togglePanel()
        }

        processManager.onOutput = { [weak self] text, streamType in
            Task { @MainActor in
                switch streamType {
                case .stdout:
                    self?.viewModel.appendToLastAssistant(text)
                case .stderr:
                    self?.viewModel.addErrorMessage(text)
                }
            }
        }

        processManager.onResponseComplete = { [weak self] in
            Task { @MainActor in
                self?.viewModel.setStreaming(false)
            }
        }

        processManager.onProcessExit = { [weak self] code in
            Task { @MainActor in
                if code != 0 {
                    self?.viewModel.addErrorMessage("Process exited with code \(code)")
                }
            }
        }

        startCLI()
    }

    private func startCLI() {
        let cliPath = resolveCLIPath(config.cliTool)

        do {
            try processManager.start(
                command: cliPath,
                args: config.cliArgs,
                workingDirectory: config.workingDirectory
            )
        } catch {
            viewModel.addErrorMessage("Failed to start CLI: \(error.localizedDescription)")
        }
    }

    private func resolveCLIPath(_ tool: String) -> String {
        if FileManager.default.isExecutableFile(atPath: tool) {
            return tool
        }
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/which")
        process.arguments = [tool]
        let pipe = Pipe()
        process.standardOutput = pipe
        try? process.run()
        process.waitUntilExit()
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let path = String(data: data, encoding: .utf8) ?? ""
        let trimmed = path.trimmingCharacters(in: .whitespacesAndNewlines)
        if FileManager.default.isExecutableFile(atPath: trimmed) {
            return trimmed
        }
        return tool
    }

    private func handleSubmit(_ text: String) {
        viewModel.addUserMessage(text)
        viewModel.addAssistantMessage("")
        viewModel.setStreaming(true)
        processManager.sendInput(text)
    }

    func showPanel() {
        panel?.show()
        viewModel.shouldFocusInput = true
    }

    func hidePanel() {
        panel?.hide()
    }

    func togglePanel() {
        if panel?.isVisible == true {
            processManager.stop()
            panel?.hide()
        } else {
            showPanel()
        }
    }
}

struct ConversationPanelView: View {
    @ObservedObject var viewModel: ConversationViewModel
    var onSubmit: (String) -> Void
    @State private var inputText: String = ""

    var body: some View {
        VStack(spacing: 0) {
            ConversationView(viewModel: viewModel)

            Divider()

            InputFieldView(
                text: $inputText,
                onSubmit: { text in
                    onSubmit(text)
                },
                isDisabled: viewModel.isStreaming,
                shouldFocus: $viewModel.shouldFocusInput
            )
            .padding(.vertical, 8)
        }
        .background(Color(nsColor: .windowBackgroundColor))
    }
}
