import SwiftUI

struct ConversationView: View {
    @ObservedObject var viewModel: ConversationViewModel

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 8) {
                    ForEach(viewModel.messages) { message in
                        let isLastStreaming = viewModel.isStreaming && message.role == .assistant && viewModel.messages.last?.id == message.id
                        MessageBubble(message: message, isStreaming: isLastStreaming)
                            .id(message.id)
                    }
                }
                .padding()
            }
            .onChange(of: viewModel.messages.count) { _ in
                if let lastId = viewModel.messages.last?.id {
                    proxy.scrollTo(lastId, anchor: .bottom)
                }
            }
        }
    }
}

struct MessageBubble: View {
    let message: Message
    let isStreaming: Bool

    var body: some View {
        HStack {
            if message.role == .user {
                Spacer(minLength: 60)
            }

            VStack(alignment: message.role == .user ? .trailing : .leading, spacing: 4) {
                Group {
                    if message.role == .assistant {
                        Text(MarkdownRenderer.render(message.content))
                    } else {
                        Text(message.content)
                    }
                }
                .font(.body)
                .foregroundColor(foregroundColor)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(backgroundColor)
                .cornerRadius(12)

                if isStreaming {
                    ProgressView()
                        .scaleEffect(0.5)
                        .frame(width: 16, height: 8)
                }
            }

            if message.role != .user {
                Spacer(minLength: 60)
            }
        }
    }

    private var foregroundColor: Color {
        switch message.role {
        case .user: return .primary
        case .assistant: return .primary
        case .error: return .red
        }
    }

    private var backgroundColor: Color {
        switch message.role {
        case .user: return Color.blue.opacity(0.2)
        case .assistant: return Color.gray.opacity(0.15)
        case .error: return Color.red.opacity(0.1)
        }
    }
}
