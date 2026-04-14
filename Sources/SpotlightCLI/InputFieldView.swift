import SwiftUI

struct InputFieldView: View {
    @Binding var text: String
    var onSubmit: (String) -> Void
    var isDisabled: Bool = false
    @Binding var shouldFocus: Bool

    @FocusState private var isFocused: Bool

    var body: some View {
        HStack(spacing: 8) {
            TextField("Ask anything...", text: $text, axis: .vertical)
                .textFieldStyle(.plain)
                .font(.system(size: 14))
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color(nsColor: .controlBackgroundColor))
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
                .focused($isFocused)
                .disabled(isDisabled)
                .onSubmit {
                    submitText()
                }

            Button(action: submitText) {
                Image(systemName: "arrow.up.circle.fill")
                    .font(.system(size: 20))
                    .foregroundColor(isDisabled ? .gray : .blue)
            }
            .disabled(isDisabled || text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .onChange(of: shouldFocus) { newValue in
            if newValue {
                isFocused = true
            }
        }
    }

    private func submitText() {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        onSubmit(trimmed)
        text = ""
    }

    func focus() {
        isFocused = true
    }
}
