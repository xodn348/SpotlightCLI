import XCTest
@testable import SpotlightCLI

final class ConfigTests: XCTestCase {
    func testDefaultConfig() {
        let config = Config.default
        XCTAssertEqual(config.cliTool, "opencode")
        XCTAssertEqual(config.cliArgs, [])
        XCTAssertEqual(config.hotkey.key, "space")
        XCTAssertEqual(config.hotkey.modifiers, ["command", "shift"])
        XCTAssertEqual(config.responseTimeout, 1.5)
        XCTAssertEqual(config.maxMessages, 100)
    }

    func testMissingFileReturnsDefaults() throws {
        let url = URL(fileURLWithPath: "/nonexistent/path/config.json")
        let config = try Config.load(from: url)
        XCTAssertEqual(config.cliTool, "opencode")
    }

    func testInvalidJSONThrows() throws {
        let tempDir = FileManager.default.temporaryDirectory
        let configURL = tempDir.appendingPathComponent("invalid_config_\(UUID().uuidString).json")
        try! "not json {}}}".data(using: .utf8)!.write(to: configURL)
        defer { try? FileManager.default.removeItem(at: configURL) }

        do {
            _ = try Config.load(from: configURL)
            XCTFail("Should throw")
        } catch let error as ConfigError {
            XCTAssertTrue(error.localizedDescription.contains(configURL.path))
        }
    }

    func testPartialJSONFillsDefaults() throws {
        let json = """
        {
            "cliTool": "/custom/tool"
        }
        """.data(using: .utf8)!
        let config = try JSONDecoder().decode(Config.self, from: json)
        XCTAssertEqual(config.cliTool, "/custom/tool")
        XCTAssertEqual(config.hotkey.key, "space")
    }
}
