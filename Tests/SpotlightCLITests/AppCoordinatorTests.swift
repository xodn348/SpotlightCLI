@testable import SpotlightCLI
import XCTest

@MainActor
final class AppCoordinatorTests: XCTestCase {
    func testCoordinatorInit() {
        let coordinator = AppCoordinator()
        XCTAssertNotNil(coordinator)
    }

    func testErrorHandling() {
        let vm = ConversationViewModel()
        vm.addErrorMessage("Test error")
        XCTAssertEqual(vm.messages.count, 1)
        XCTAssertEqual(vm.messages[0].role, .error)
    }
}
