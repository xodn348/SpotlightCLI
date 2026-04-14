import XCTest
@testable import SpotlightCLI

final class CLIPipeSpikeTests: XCTestCase {
    func testEchoPipe() throws {
        let pm = ProcessManager()
        var outputs: [String] = []
        pm.onOutput = { output, _ in
            outputs.append(output)
        }
        try pm.start(command: "/bin/echo", args: ["hello"], workingDirectory: "/tmp")
        let exp = expectation(description: "echo output")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            exp.fulfill()
            pm.stop()
        }
        wait(for: [exp], timeout: 5)
        XCTAssertFalse(outputs.isEmpty)
    }
}
