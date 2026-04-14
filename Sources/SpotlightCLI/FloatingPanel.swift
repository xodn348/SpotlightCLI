import AppKit
import SwiftUI

final class FloatingPanel: NSPanel {

    convenience init(contentView: some View) {
        let screenFrame = NSScreen.main?.visibleFrame ?? NSRect(x: 0, y: 0, width: 800, height: 600)
        let panelWidth: CGFloat = 600
        let panelHeight: CGFloat = 400
        let x = screenFrame.midX - panelWidth / 2
        let topThird = screenFrame.maxY - screenFrame.height / 3
        let y = topThird - panelHeight
        let panelRect = NSRect(x: x, y: y, width: panelWidth, height: panelHeight)

        self.init(
            contentRect: panelRect,
            styleMask: [.nonactivatingPanel, .titled, .resizable, .closable, .fullSizeContentView],
            backing: .buffered,
            defer: false
        )

        isFloatingPanel = true
        level = .floating
        collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        isReleasedWhenClosed = false
        titleVisibility = .hidden
        titlebarAppearsTransparent = true
        hidesOnDeactivate = true
        isMovableByWindowBackground = true

        self.contentView = NSHostingView(rootView: AnyView(contentView))
    }

    override var canBecomeKey: Bool { true }
    override var canBecomeMain: Bool { false }

    func show() {
        center()
        makeKeyAndOrderFront(nil)
    }

    func hide() {
        orderOut(nil)
    }

    func registerEscapeHandler(handler: @escaping () -> Void) {
        NSEvent.addLocalMonitorForEvents(matching: .keyDown) { [weak self] event in
            guard let self = self, self.isVisible else { return event }
            if event.keyCode == 53 {
                self.hide()
                handler()
                return nil
            }
            return event
        }
    }
}
