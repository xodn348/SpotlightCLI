import Foundation

struct Config: Codable {
    let cliTool: String
    let cliArgs: [String]
    let workingDirectory: String
    let hotkey: HotkeyConfig
    let responseTimeout: Double
    let maxMessages: Int

    struct HotkeyConfig: Codable {
        let key: String
        let modifiers: [String]
    }

    static var `default`: Config {
        Config(
            cliTool: "opencode",
            cliArgs: [],
            workingDirectory: NSHomeDirectory(),
            hotkey: HotkeyConfig(key: "space", modifiers: ["command", "shift"]),
            responseTimeout: 1.5,
            maxMessages: 100
        )
    }

    static var defaultConfigURL: URL {
        let home = FileManager.default.homeDirectoryForCurrentUser
        return home
            .appendingPathComponent(".config")
            .appendingPathComponent("spotlight-cli")
            .appendingPathComponent("config.json")
    }

    static func load(from url: URL = Config.defaultConfigURL) throws -> Config {
        guard FileManager.default.fileExists(atPath: url.path) else {
            return .default
        }

        do {
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode(Config.self, from: data)
        } catch {
            throw ConfigError.invalidJSON(path: url.path, underlying: error)
        }
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        cliTool = try container.decodeIfPresent(String.self, forKey: .cliTool) ?? "opencode"
        cliArgs = try container.decodeIfPresent([String].self, forKey: .cliArgs) ?? []
        workingDirectory = try container.decodeIfPresent(String.self, forKey: .workingDirectory) ?? NSHomeDirectory()
        hotkey = try container.decodeIfPresent(HotkeyConfig.self, forKey: .hotkey) ?? HotkeyConfig(key: "space", modifiers: ["command", "shift"])
        responseTimeout = try container.decodeIfPresent(Double.self, forKey: .responseTimeout) ?? 1.5
        maxMessages = try container.decodeIfPresent(Int.self, forKey: .maxMessages) ?? 100
    }

    init(cliTool: String, cliArgs: [String], workingDirectory: String, hotkey: HotkeyConfig, responseTimeout: Double, maxMessages: Int) {
        self.cliTool = cliTool
        self.cliArgs = cliArgs
        self.workingDirectory = workingDirectory
        self.hotkey = hotkey
        self.responseTimeout = responseTimeout
        self.maxMessages = maxMessages
    }

    private enum CodingKeys: String, CodingKey {
        case cliTool, cliArgs, workingDirectory, hotkey, responseTimeout, maxMessages
    }
}

enum ConfigError: Error, LocalizedError {
    case invalidJSON(path: String, underlying: Error)

    var errorDescription: String? {
        switch self {
        case .invalidJSON(let path, let underlying):
            return "Invalid JSON at \(path): \(underlying.localizedDescription)"
        }
    }
}
