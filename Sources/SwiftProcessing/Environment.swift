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

public func rotateBy(_ angle: CGFloat) {
    ctx?.rotate(by: angle)
}

public func translate(_ x: CGFloat, _ y: CGFloat) {
    ctx?.translateBy(x: x, y: y)
}

public func random(_ n: CGFloat) -> CGFloat {
    let r: Int = random(n)
    return CGFloat(r)
}

public func random(_ n: CGFloat) -> Int {
    Int(arc4random_uniform(UInt32(n)))
}

public func random(_ n: Int) -> Int {
    Int(arc4random_uniform(UInt32(n)))
}

public func random(_ min: Int, _ max: Int) -> CGFloat {
    let r: Int = random(min, max)
    return CGFloat(r)
}

public func random(_ min: Int, _ max: Int) -> Int {
    Int(arc4random_uniform(UInt32(max - min))) + min
}


