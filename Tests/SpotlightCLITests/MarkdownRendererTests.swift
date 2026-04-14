@testable import SpotlightCLI
import XCTest

final class MarkdownRendererTests: XCTestCase {
    func testEmptyString() {
        let result = MarkdownRenderer.render("")
        XCTAssertEqual(result.characters.count, 0)
    }

    func testPlainText() {
        let result = MarkdownRenderer.render("Hello, World!")
        let str = String(result.characters)
        XCTAssertTrue(str.contains("Hello"))
    }

    func testBoldRendering() {
        let result = MarkdownRenderer.render("**bold** text")
        let str = String(result.characters)
        XCTAssertTrue(str.contains("bold"))
    }

    func testFallbackForInvalidMarkdown() {
        let result = MarkdownRenderer.render("[[[invalid")
        let str = String(result.characters)
        XCTAssertTrue(str.contains("[[[invalid"))
    }

    func testMonospacedFont() {
        let result = MarkdownRenderer.render("`code` text")
        let str = String(result.characters)
        XCTAssertTrue(str.contains("code"))
    }
}
