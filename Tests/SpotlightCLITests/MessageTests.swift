@testable import SpotlightCLI
import XCTest

final class MessageTests: XCTestCase {
    func testMessageCreation() {
        let msg = Message(role: .user, content: "Hello")
        XCTAssertEqual(msg.role, .user)
        XCTAssertEqual(msg.content, "Hello")
        XCTAssertNotNil(msg.id)
    }

    func testMessageRoles() {
        let userMsg = Message(role: .user, content: "Hi")
        let assistantMsg = Message(role: .assistant, content: "Hello")
        let errorMsg = Message(role: .error, content: "Oops")

        XCTAssertEqual(userMsg.role, .user)
        XCTAssertEqual(assistantMsg.role, .assistant)
        XCTAssertEqual(errorMsg.role, .error)
    }

    func testMessageEquality() {
        let id = UUID()
        let msg1 = Message(id: id, role: .user, content: "Test")
        let msg2 = Message(id: id, role: .user, content: "Test")
        XCTAssertEqual(msg1, msg2)
    }
}
