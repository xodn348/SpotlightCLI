@testable import SpotlightCLI
import XCTest

final class ANSIStripperTests: XCTestCase {
    func testPlainTextPassesThrough() {
        let input = "Hello, World!"
        let result = ANSIStripper.strip(input)
        XCTAssertEqual(result, input)
    }

    func testSGRColorCodesStripped() {
        let input = "\u{1B}[31mRed\u{1B}[0m"
        let result = ANSIStripper.strip(input)
        XCTAssertEqual(result, "Red")
    }

    func testBoldUnderlineStripped() {
        let input = "\u{1B}[1m\u{1B}[4mBold\u{1B}[0m"
        let result = ANSIStripper.strip(input)
        XCTAssertEqual(result, "Bold")
    }

    func testCursorMovementStripped() {
        let input = "\u{1B}[2A\u{1B}[3B"
        let result = ANSIStripper.strip(input)
        XCTAssertEqual(result, "")
    }

    func testOSCSequencesStripped() {
        let input = "\u{1B}]0;Terminal Title\u{07}"
        let result = ANSIStripper.strip(input)
        XCTAssertEqual(result, "")
    }

    func testCarriageReturnStripped() {
        let input = "Loading...\rDone!"
        let result = ANSIStripper.strip(input)
        XCTAssertEqual(result, "Loading...Done!")
    }

    func testMixedContent() {
        let input = "\u{1B}[32mSuccess\u{1B}[0m: \u{1B}[1mBold text\u{1B}[0m"
        let result = ANSIStripper.strip(input)
        XCTAssertEqual(result, "Success: Bold text")
    }

    func testEmptyString() {
        let result = ANSIStripper.strip("")
        XCTAssertEqual(result, "")
    }

    func testUnicodePreservation() {
        let input = "🎉 Hello 世界 你好"
        let result = ANSIStripper.strip(input)
        XCTAssertEqual(result, input)
    }
}
