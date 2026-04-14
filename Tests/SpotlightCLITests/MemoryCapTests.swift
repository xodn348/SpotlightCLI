@testable import SpotlightCLI
import XCTest

@MainActor
final class MemoryCapTests: XCTestCase {
    func testMemoryCapEnforced() {
        let vm = ConversationViewModel(maxMessages: 100)
        for i in 0..<101 {
            vm.addUserMessage("Message \(i)")
        }
        XCTAssertEqual(vm.messages.count, 100)
    }

    func testOldestMessageRemoved() {
        let vm = ConversationViewModel(maxMessages: 100)
        for i in 0..<110 {
            vm.addUserMessage("Message \(i)")
        }
        XCTAssertEqual(vm.messages.first?.content, "Message 10")
        XCTAssertEqual(vm.messages.last?.content, "Message 109")
    }

    func testUnderCapNoTrim() {
        let vm = ConversationViewModel(maxMessages: 100)
        for i in 0..<50 {
            vm.addUserMessage("Message \(i)")
        }
        XCTAssertEqual(vm.messages.count, 50)
    }

    func testFIFORemoval() {
        let vm = ConversationViewModel(maxMessages: 3)
        vm.addUserMessage("First")
        vm.addUserMessage("Second")
        vm.addUserMessage("Third")
        vm.addUserMessage("Fourth")
        XCTAssertEqual(vm.messages.count, 3)
        XCTAssertEqual(vm.messages[0].content, "Second")
        XCTAssertEqual(vm.messages[1].content, "Third")
        XCTAssertEqual(vm.messages[2].content, "Fourth")
    }
}
