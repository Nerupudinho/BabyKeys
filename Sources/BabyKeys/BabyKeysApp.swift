import SwiftUI

@main
struct BabyKeysApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .windowStyle(.hiddenTitleBar)
        .commands {
            CommandGroup(replacing: .appInfo) {}
            CommandGroup(replacing: .newItem) {}
            CommandGroup(replacing: .undoRedo) {}
            CommandGroup(replacing: .pasteboard) {}
            CommandGroup(replacing: .windowSize) {}
            CommandGroup(replacing: .windowList) {}
            CommandGroup(replacing: .help) {}
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    private var modalTouchBar: NSTouchBar?

    func applicationDidFinishLaunching(_ notification: Notification) {
        let screens = NSScreen.screens.map { "\($0.frame.width)x\($0.frame.height)@(\($0.frame.origin.x),\($0.frame.origin.y))" }
        BKLog.log("LAUNCH — \(NSScreen.screens.count) screen(s): \(screens.joined(separator: ", "))")
        NSApp.presentationOptions = [
            .hideDock,
            .hideMenuBar,
            .disableAppleMenu,
            .disableProcessSwitching,
            .disableHideApplication,
            .disableForceQuit
        ]
        NSApp.isAutomaticCustomizeTouchBarMenuItemEnabled = false
        NSApp.activate(ignoringOtherApps: true)
        lockDownWindows(attempt: 0)

        // Focus loss is the prime suspect for "getting impacted": if the overlay
        // stops being active, keystrokes no longer spawn shapes and the baby can
        // reach whatever is behind it. Record every focus transition.
        let nc = NotificationCenter.default
        nc.addObserver(forName: NSApplication.didResignActiveNotification, object: nil, queue: .main) { _ in
            BKLog.log("RESIGNED ACTIVE — overlay lost focus (front app: \(NSWorkspace.shared.frontmostApplication?.localizedName ?? "?"))")
        }
        nc.addObserver(forName: NSApplication.didBecomeActiveNotification, object: nil, queue: .main) { _ in
            BKLog.log("BECAME ACTIVE — overlay regained focus")
        }
        nc.addObserver(forName: NSApplication.didChangeScreenParametersNotification, object: nil, queue: .main) { [weak self] _ in
            BKLog.log("SCREEN PARAMS CHANGED — re-applying lockdown")
            self?.lockDownWindows(attempt: 0)
        }
    }

    /// Wait until SwiftUI has actually created the content window, then lock
    /// down EVERY window (not just the first). Relying on `NSApp.windows.first`
    /// at a fixed delay was racy — the window sometimes wasn't ready yet, so the
    /// app came up as an ordinary window on whatever display instead of the
    /// fullscreen overlay, making it look like it "didn't open".
    private func lockDownWindows(attempt: Int) {
        let windows = NSApp.windows.filter { $0.contentView != nil }
        if windows.isEmpty && attempt < 40 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                self.lockDownWindows(attempt: attempt + 1)
            }
            return
        }
        if windows.isEmpty {
            BKLog.log("LOCKDOWN FAILED — no content window after \(attempt) attempts")
            return
        }
        let screen = NSScreen.main ?? NSScreen.screens[0]
        for window in windows {
            window.styleMask = [.borderless]
            window.isOpaque = false
            window.backgroundColor = .clear
            window.hasShadow = false
            window.level = .screenSaver
            window.collectionBehavior = [.canJoinAllSpaces, .stationary, .ignoresCycle]
            window.setFrame(screen.frame, display: true)
            window.touchBar = NSTouchBar()
        }
        (windows.first { $0.canBecomeKey } ?? windows.first)?.makeKeyAndOrderFront(nil)
        BKLog.log("LOCKDOWN OK — \(windows.count) window(s), frame \(screen.frame.width)x\(screen.frame.height)@(\(screen.frame.origin.x),\(screen.frame.origin.y)), level screenSaver (attempt \(attempt))")
        blankTouchBar()
    }

    private func blankTouchBar() {
        let bar = NSTouchBar()
        modalTouchBar = bar
        let cls: AnyObject = NSTouchBar.self
        // macOS 10.14+ renamed the API; try both names
        for name in ["presentSystemModalTouchBar:systemTrayItemIdentifier:",
                     "presentSystemModalFunctionBar:systemTrayItemIdentifier:"] {
            let sel = NSSelectorFromString(name)
            if cls.responds(to: sel) {
                _ = cls.perform(sel, with: bar, with: nil)
                return
            }
        }
    }

    func applicationWillTerminate(_ notification: Notification) {
        BKLog.log("TERMINATE — app is quitting")
        guard let bar = modalTouchBar else { return }
        let cls: AnyObject = NSTouchBar.self
        for name in ["dismissSystemModalTouchBar:", "dismissSystemModalFunctionBar:"] {
            let sel = NSSelectorFromString(name)
            if cls.responds(to: sel) {
                _ = cls.perform(sel, with: bar)
                return
            }
        }
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        true
    }
}
