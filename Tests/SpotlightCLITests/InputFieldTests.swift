@testable import SpotlightCLI
import XCTest

final class InputFieldTests: XCTestCase {
    func testEmptySubmit() {
        XCTAssertTrue("".trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        XCTAssertTrue("   ".trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
    }

    func testNonEmptySubmit() {
        let text = "Hello world"
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        XCTAssertFalse(trimmed.isEmpty)
        XCTAssertEqual(trimmed, "Hello world")
    }

    func testTrimmedSubmit() {
        let text = "  Hello  "
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        XCTAssertEqual(trimmed, "Hello")
    }

    func testShouldSubmitValid() {
        let text = "Hello"
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        XCTAssertFalse(trimmed.isEmpty)
    }

    func testShouldSubmitEmpty() {
        let text = ""
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        XCTAssertTrue(trimmed.isEmpty)
    }
}
