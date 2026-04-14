@testable import SpotlightCLI
import XCTest

@MainActor
final class ConversationViewModelTests: XCTestCase {
    func testAddUserMessage() {
        let vm = ConversationViewModel()
        vm.addUserMessage("Hello")
        XCTAssertEqual(vm.messages.count, 1)
        XCTAssertEqual(vm.messages[0].content, "Hello")
        XCTAssertEqual(vm.messages[0].role, .user)
    }

    func testAddAssistantMessage() {
        let vm = ConversationViewModel()
        vm.addAssistantMessage("Hi there")
        XCTAssertEqual(vm.messages.count, 1)
        XCTAssertEqual(vm.messages[0].content, "Hi there")
        XCTAssertEqual(vm.messages[0].role, .assistant)
    }

    func testAddErrorMessage() {
        let vm = ConversationViewModel()
        vm.addErrorMessage("Something went wrong")
        XCTAssertEqual(vm.messages.count, 1)
        XCTAssertEqual(vm.messages[0].role, .error)
    }

    func testMemoryCap() {
        let vm = ConversationViewModel(maxMessages: 100)
        for i in 0..<110 {
            vm.addUserMessage("Message \(i)")
        }
        XCTAssertEqual(vm.messages.count, 100)
        XCTAssertEqual(vm.messages.first?.content, "Message 10")
    }

    func testEmptyPromptIgnored() {
        let vm = ConversationViewModel()
        vm.addUserMessage("")
        vm.addUserMessage("   ")
        XCTAssertEqual(vm.messages.count, 0)
    }

    func testAppendToLastAssistant() {
        let vm = ConversationViewModel()
        vm.addAssistantMessage("Hello")
        vm.appendToLastAssistant(" World")
        XCTAssertEqual(vm.messages.count, 1)
        XCTAssertEqual(vm.messages[0].content, "Hello World")
    }

    func testStreamingState() {
        let vm = ConversationViewModel()
        XCTAssertFalse(vm.isStreaming)
        vm.setStreaming(true)
        XCTAssertTrue(vm.isStreaming)
        vm.setStreaming(false)
        XCTAssertFalse(vm.isStreaming)
    }
}
