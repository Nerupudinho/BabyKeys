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
        NSApp.presentationOptions = [
            .hideDock,
            .hideMenuBar,
            .disableAppleMenu,
            .disableProcessSwitching,
            .disableHideApplication,
            .disableForceQuit
        ]
        NSApp.isAutomaticCustomizeTouchBarMenuItemEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            guard let window = NSApp.windows.first else { return }
            let screen = NSScreen.main ?? NSScreen.screens[0]
            window.setFrame(screen.frame, display: true)
            window.styleMask = [.borderless]
            window.isOpaque = false
            window.backgroundColor = .clear
            window.hasShadow = false
            window.level = .screenSaver
            window.collectionBehavior = [.canJoinAllSpaces, .stationary, .ignoresCycle]
            window.touchBar = NSTouchBar()
            window.makeKeyAndOrderFront(nil)
            self.blankTouchBar()
        }
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
