import AppKit

struct PanelDismissHandler {
    static func shouldDismiss(for event: NSEvent) -> Bool {
        if event.type == .keyDown && event.keyCode == 53 {
            return true
        }
        return false
    }

    static func isClickOutside(panel: NSPanel, event: NSEvent) -> Bool {
        let clickLocation = event.locationInWindow
        let panelFrame = panel.frame
        let windowLocation = panel.convertToScreen(NSRect(origin: clickLocation, size: .zero)).origin
        return !NSPointInRect(windowLocation, panelFrame)
    }
}
