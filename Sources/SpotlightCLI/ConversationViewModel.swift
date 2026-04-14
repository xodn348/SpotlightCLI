import Foundation
import Combine

@MainActor
final class ConversationViewModel: ObservableObject {
    @Published private(set) var messages: [Message] = []
    @Published private(set) var isStreaming: Bool = false
    @Published var shouldFocusInput: Bool = false

    private let maxMessages: Int

    init(maxMessages: Int = 100) {
        self.maxMessages = maxMessages
    }

    func addUserMessage(_ text: String) {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        appendMessage(Message(role: .user, content: trimmed))
    }

    func addAssistantMessage(_ text: String) {
        appendMessage(Message(role: .assistant, content: text))
    }

    func addErrorMessage(_ text: String) {
        appendMessage(Message(role: .error, content: ANSIStripper.strip(text)))
    }

    func appendToLastAssistant(_ text: String) {
        let stripped = ANSIStripper.strip(text)
        guard !stripped.isEmpty else { return }
        if let lastIndex = messages.lastIndex(where: { $0.role == .assistant }) {
            messages[lastIndex].content += stripped
        } else {
            addAssistantMessage(stripped)
        }
    }

    func setStreaming(_ streaming: Bool) {
        isStreaming = streaming
    }

    private func appendMessage(_ message: Message) {
        messages.append(message)
        enforceMemoryCap()
    }

    private func enforceMemoryCap() {
        if messages.count > maxMessages {
            messages.removeFirst(messages.count - maxMessages)
        }
    }
}
