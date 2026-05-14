import SwiftUI

struct ShapeView: View {
    let shape: BabyShape
    @State private var scale: CGFloat = 0.1
    @State private var opacity: Double = 1.0

    var body: some View {
        shapeBody
            .frame(width: shape.size, height: shape.size)
            .foregroundStyle(shape.color)
            .scaleEffect(scale)
            .opacity(opacity)
            .position(shape.position)
            .onAppear {
                withAnimation(.spring(duration: 0.35, bounce: 0.5)) {
                    scale = 1.0
                }
                withAnimation(.easeOut(duration: 0.7).delay(0.6)) {
                    opacity = 0.0
                }
            }
    }

    @ViewBuilder
    private var shapeBody: some View {
        switch shape.kind {
        case .circle:
            Circle()
        case .square:
            RoundedRectangle(cornerRadius: 16)
        case .star:
            StarShape()
        }
    }
}

struct StarShape: Shape {
    func path(in rect: CGRect) -> Path {
        let c = CGPoint(x: rect.midX, y: rect.midY)
        let outer = min(rect.width, rect.height) / 2
        let inner = outer * 0.4
        var path = Path()
        for i in 0..<10 {
            let angle = -CGFloat.pi / 2 + CGFloat(i) * .pi / 5
            let r = i.isMultiple(of: 2) ? outer : inner
            let pt = CGPoint(x: c.x + r * cos(angle), y: c.y + r * sin(angle))
            if i == 0 { path.move(to: pt) } else { path.addLine(to: pt) }
        }
        path.closeSubpath()
        return path
    }
}
