import Foundation
import AppKit

enum StreamType {
    case stdout
    case stderr
}

final class ProcessManager: ObservableObject {
    @Published private(set) var isRunning: Bool = false
    @Published private(set) var isResponseStreaming: Bool = false

    var onOutput: ((String, StreamType) -> Void)?
    var onResponseComplete: (() -> Void)?
    var onProcessExit: ((Int32) -> Void)?

    private var process: Process?
    private var stdinPipe: Pipe?
    private var stdoutPipe: Pipe?
    private var stderrPipe: Pipe?
    private var silenceTimer: DispatchSourceTimer?
    private var silenceTimeout: TimeInterval = 1.5
    private var queuedInputs: [String] = []
    private let isTestMode: Bool

    func setResponseTimeout(_ timeout: TimeInterval) {
        silenceTimeout = timeout
    }

    init() {
        self.isTestMode = ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil
    }

    func start(command: String, args: [String] = [], workingDirectory: String) throws {
        guard !isTestMode else { return }

        stop()

        process = Process()
        process?.executableURL = URL(fileURLWithPath: "/usr/bin/env")
        process?.arguments = [command] + args
        process?.currentDirectoryURL = URL(fileURLWithPath: workingDirectory)
        process?.environment = ProcessInfo.processInfo.environment

        stdinPipe = Pipe()
        stdoutPipe = Pipe()
        stderrPipe = Pipe()

        process?.standardInput = stdinPipe
        process?.standardOutput = stdoutPipe
        process?.standardError = stderrPipe

        setupReadHandler(pipe: stdoutPipe!, type: .stdout)
        setupReadHandler(pipe: stderrPipe!, type: .stderr)

        process?.terminationHandler = { [weak self] proc in
            DispatchQueue.main.async {
                self?.handleTermination(exitCode: proc.terminationStatus)
            }
        }

        try process?.run()
        DispatchQueue.main.async {
            self.isRunning = true
        }
    }

    func sendInput(_ text: String) {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        if isResponseStreaming {
            queuedInputs.append(trimmed)
            return
        }

        writeToStdin(trimmed)
    }

    func stop() {
        silenceTimer?.cancel()
        silenceTimer = nil
        process?.terminate()
        process = nil
        stdinPipe = nil
        stdoutPipe = nil
        stderrPipe = nil
        DispatchQueue.main.async {
            self.isRunning = false
            self.isResponseStreaming = false
        }
    }

    private func setupReadHandler(pipe: Pipe, type: StreamType) {
        pipe.fileHandleForReading.readabilityHandler = { [weak self] handle in
            let data = handle.availableData
            guard !data.isEmpty else {
                handle.readabilityHandler = nil
                return
            }
            let output = String(data: data, encoding: .utf8) ?? ""
            let stripped = ANSIStripper.strip(output)
            DispatchQueue.main.async {
                self?.onOutput?(stripped, type)
                self?.resetSilenceTimer()
            }
        }
    }

    private func resetSilenceTimer() {
        silenceTimer?.cancel()
        silenceTimer = DispatchSource.makeTimerSource(queue: .main)
        silenceTimer?.schedule(deadline: .now() + silenceTimeout)
        silenceTimer?.setEventHandler { [weak self] in
            self?.handleSilenceTimeout()
        }
        silenceTimer?.resume()
    }

    private func handleSilenceTimeout() {
        guard isResponseStreaming else { return }
        DispatchQueue.main.async {
            self.isResponseStreaming = false
            self.onResponseComplete?()
            self.processQueuedInput()
        }
    }

    private func handleTermination(exitCode: Int32) {
        DispatchQueue.main.async {
            self.isRunning = false
            self.isResponseStreaming = false
            self.silenceTimer?.cancel()
            self.silenceTimer = nil
            self.onProcessExit?(exitCode)
        }
    }

    private func writeToStdin(_ text: String) {
        guard let pipe = stdinPipe else { return }
        let data = (text + "\n").data(using: .utf8)!
        pipe.fileHandleForWriting.write(data)
        DispatchQueue.main.async {
            self.isResponseStreaming = true
        }
        resetSilenceTimer()
    }

    private func processQueuedInput() {
        guard !queuedInputs.isEmpty else { return }
        let next = queuedInputs.removeFirst()
        writeToStdin(next)
    }
}
