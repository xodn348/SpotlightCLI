import Foundation

final class CLIPipeSpike {
    static func runEchoTest() -> String? {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/bin/echo")
        process.arguments = ["hello"]

        let pipe = Pipe()
        process.standardOutput = pipe

        do {
            try process.run()
            process.waitUntilExit()
            let data = pipe.fileHandleForReading.readDataToEndOfFile()
            return String(data: data, encoding: .utf8)
        } catch {
            return nil
        }
    }

    static func runCatMultiTurn(lines: [String]) -> [String] {
        var results: [String] = []
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/bin/cat")

        let stdinPipe = Pipe()
        let stdoutPipe = Pipe()
        process.standardInput = stdinPipe
        process.standardOutput = stdoutPipe
        process.standardError = FileHandle.nullDevice

        let group = DispatchGroup()

        stdoutPipe.fileHandleForReading.readabilityHandler = { handle in
            let data = handle.availableData
            if data.isEmpty {
                stdoutPipe.fileHandleForReading.readabilityHandler = nil
                group.leave()
            } else if let line = String(data: data, encoding: .utf8) {
                results.append(line.trimmingCharacters(in: .newlines))
            }
        }

        do {
            try process.run()
            group.enter()
            for line in lines {
                let inputData = (line + "\n").data(using: .utf8)!
                stdinPipe.fileHandleForWriting.write(inputData)
            }
            stdinPipe.fileHandleForWriting.closeFile()
            group.wait()
            process.waitUntilExit()
        } catch {
            return []
        }

        return results
    }
}
