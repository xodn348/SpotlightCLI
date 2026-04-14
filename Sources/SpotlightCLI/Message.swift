import Foundation

struct Message: Identifiable, Equatable {
    let id: UUID
    let role: MessageRole
    var content: String
    let timestamp: Date

    init(id: UUID = UUID(), role: MessageRole, content: String, timestamp: Date = Date()) {
        self.id = id
        self.role = role
        self.content = content
        self.timestamp = timestamp
    }

    static func ==(lhs: Message, rhs: Message) -> Bool {
        lhs.id == rhs.id
    }
}

enum MessageRole: String, Codable {
    case user
    case assistant
    case error
}
