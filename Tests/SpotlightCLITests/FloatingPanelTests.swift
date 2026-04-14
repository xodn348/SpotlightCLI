@testable import SpotlightCLI
import XCTest
import SwiftUI

final class FloatingPanelTests: XCTestCase {
    func testPanelInstantiation() {
        let panel = FloatingPanel(contentView: Text("Test"))
        XCTAssertNotNil(panel)
    }

    func testCanBecomeKey() {
        let panel = FloatingPanel(contentView: Text("Test"))
        XCTAssertTrue(panel.canBecomeKey)
    }

    func testIsFloatingPanel() {
        let panel = FloatingPanel(contentView: Text("Test"))
        XCTAssertTrue(panel.isFloatingPanel)
    }

    func testStyleMask() {
        let panel = FloatingPanel(contentView: Text("Test"))
        let styleMask = panel.styleMask
        XCTAssertTrue(styleMask.contains(.nonactivatingPanel))
        XCTAssertTrue(styleMask.contains(.titled))
        XCTAssertTrue(styleMask.contains(.resizable))
    }
}
