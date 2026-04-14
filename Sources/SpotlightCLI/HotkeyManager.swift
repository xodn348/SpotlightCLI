import AppKit
import HotKey

final class HotkeyManager {
    var onToggle: (() -> Void)?

    private var hotKey: HotKey?
    private let isTestMode: Bool

    init(config: Config.HotkeyConfig) {
        self.isTestMode = ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil
        register(config: config)
    }

    init() {
        self.isTestMode = true
    }

    func register(config: Config.HotkeyConfig) {
        guard !isTestMode else { return }

        let key = mapKey(config.key)
        let modifiers = mapModifiers(config.modifiers)

        hotKey = HotKey(key: key, modifiers: modifiers)
        hotKey?.keyDownHandler = { [weak self] in
            self?.onToggle?()
        }
    }

    func unregister() {
        hotKey = nil
    }

    private func mapKey(_ key: String) -> Key {
        switch key.lowercased() {
        case "space": return .space
        case "k": return .k
        case "l": return .l
        case "return", "enter": return .return
        case "escape", "esc": return .escape
        case "tab": return .tab
        case "delete": return .delete
        case "up": return .upArrow
        case "down": return .downArrow
        case "left": return .leftArrow
        case "right": return .rightArrow
        default:
            if let scalar = key.lowercased().unicodeScalars.first {
                return Key(carbonKeyCode: UInt32(scalar.value)) ?? .space
            }
            return .space
        }
    }

    private func mapModifiers(_ modifiers: [String]) -> NSEvent.ModifierFlags {
        var flags: NSEvent.ModifierFlags = []
        for mod in modifiers {
            switch mod.lowercased() {
            case "command": flags.insert(.command)
            case "shift": flags.insert(.shift)
            case "option": flags.insert(.option)
            case "control": flags.insert(.control)
            default: break
            }
        }
        return flags
    }
}
