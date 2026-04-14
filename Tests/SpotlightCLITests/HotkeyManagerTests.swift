import XCTest
@testable import SpotlightCLI

final class HotkeyManagerTests: XCTestCase {
    func testInitDoesNotCrash() {
        let manager = HotkeyManager()
        XCTAssertNotNil(manager)
    }

    func testOnToggleCallbackSettable() {
        let manager = HotkeyManager()
        var called = false
        manager.onToggle = { called = true }
        manager.onToggle?()
        XCTAssertTrue(called)
    }

    func testTestModeGuard() {
        let manager = HotkeyManager()
        XCTAssertNotNil(manager)
        manager.register(config: Config.HotkeyConfig(key: "space", modifiers: ["command"]))
    }
}
