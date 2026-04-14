@testable import SpotlightCLI
import XCTest

final class ProcessManagerTests: XCTestCase {
    func testInitState() {
        let manager = ProcessManager()
        XCTAssertFalse(manager.isRunning)
        XCTAssertFalse(manager.isResponseStreaming)
    }

    func testSendInputWhenNotRunning() {
        let manager = ProcessManager()
        manager.sendInput("hello")
    }

    func testSetResponseTimeout() {
        let manager = ProcessManager()
        manager.setResponseTimeout(2.0)
    }
}
