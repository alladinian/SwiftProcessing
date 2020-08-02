import Foundation
import CoreGraphics


//MARK: - Context

public func push() {
    ctx?.saveGState()
}

public func pop() {
    ctx?.restoreGState()
}

public var width: CGFloat {
    CGFloat(ctx?.width ?? 0)
}

public var height: CGFloat {
    CGFloat(ctx?.height ?? 0)
}

public func rotate(_ angle: CGFloat) {
    ctx?.rotate(by: angle)
}

public func translate(_ x: CGFloat, _ y: CGFloat) {
    ctx?.translateBy(x: x, y: y)
}

func scale(_ x: CGFloat, _ y: CGFloat) {
    ctx?.scaleBy(x: x, y: y)
}

public func smooth() {
    ctx?.setShouldAntialias(true)
}

public func noSmooth() {
    ctx?.setShouldAntialias(false)
}

extension View {
    public func clear() {
        ctx?.clear(bounds)
    }
}
