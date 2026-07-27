import SwiftUI
import AppKit

struct BabyShape: Identifiable {
    let id = UUID()
    let position: CGPoint
    let color: Color
    let kind: Kind
    let size: CGFloat

    enum Kind: CaseIterable {
        case circle, square, star
    }
}

class ShapeStore: ObservableObject {
    @Published var shapes: [BabyShape] = []
    var viewSize: CGSize = .zero

    private var heldKeys = Set<UInt16>()
    private var exitTimer: Timer?
    private var monitor: Any?
    private let escKey: UInt16 = 53
    private let spaceKey: UInt16 = 49

    func start() {
        monitor = NSEvent.addLocalMonitorForEvents(
            matching: [.keyDown, .keyUp, .leftMouseDown, .rightMouseDown,
                       .scrollWheel, .gesture, .magnify, .swipe, .rotate, .beginGesture, .endGesture]
        ) { [weak self] event in
            guard let self else { return event }
            switch event.type {
            case .keyDown where !event.isARepeat:
                self.heldKeys.insert(event.keyCode)
                self.checkExit()
                self.spawnRandom()
                return nil
            case .keyUp:
                self.heldKeys.remove(event.keyCode)
                if !(self.heldKeys.contains(self.escKey) && self.heldKeys.contains(self.spaceKey)) {
                    self.exitTimer?.invalidate()
                    self.exitTimer = nil
                }
                return nil
            case .leftMouseDown, .rightMouseDown:
                let loc = event.locationInWindow
                self.spawn(at: CGPoint(x: loc.x, y: self.viewSize.height - loc.y))
                return event
            case .scrollWheel, .gesture, .magnify, .swipe, .rotate, .beginGesture, .endGesture:
                return nil
            default:
                return event
            }
        }
    }

    private func checkExit() {
        guard heldKeys.contains(escKey), heldKeys.contains(spaceKey), exitTimer == nil else { return }
        exitTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { _ in
            NSApp.presentationOptions = []
            NSApp.terminate(nil)
        }
    }

    private func spawnRandom() {
        let w = max(viewSize.width - 100, 100)
        let h = max(viewSize.height - 100, 100)
        spawn(at: CGPoint(x: .random(in: 50...w), y: .random(in: 50...h)))
    }

    func spawn(at position: CGPoint) {
        guard shapes.count < 50 else { return }
        let shape = BabyShape(
            position: position,
            color: Color(hue: .random(in: 0...1), saturation: 0.9, brightness: 1.0),
            kind: BabyShape.Kind.allCases.randomElement()!,
            size: .random(in: 60...180)
        )
        shapes.append(shape)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.shapes.removeAll { $0.id == shape.id }
        }
    }

    deinit {
        if let m = monitor { NSEvent.removeMonitor(m) }
        exitTimer?.invalidate()
    }
}

struct ContentView: View {
    @StateObject private var store = ShapeStore()

    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color.clear
                ForEach(store.shapes) { shape in
                    ShapeView(shape: shape)
                }
            }
            .onAppear {
                store.viewSize = geo.size
                store.start()
            }
            .onChange(of: geo.size) { _, newSize in
                store.viewSize = newSize
            }
        }
        .ignoresSafeArea()
    }
}
