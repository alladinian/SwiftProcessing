import Foundation
import CoreGraphics


//MARK: - Context

extension CGFloat {
    init<T: FloatingPoint>(_ n: T) {
        self = n as! CGFloat
    }
}

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

public func rotateBy(_ angle: CGFloat) {
    ctx?.rotate(by: angle)
}

public func translate(_ x: CGFloat, _ y: CGFloat) {
    ctx?.translateBy(x: x, y: y)
}
