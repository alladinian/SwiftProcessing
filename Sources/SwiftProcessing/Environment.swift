import Foundation
import CoreGraphics

//MARK: - Constants

public let HALF_PI    = CGFloat.pi / 2.0
public let PI         = CGFloat.pi
public let TWO_PI     = CGFloat.pi * 2.0
public let TAU        = CGFloat.pi * 2.0
public let QUARTER_PI = CGFloat.pi / 4.0

//MARK: - Trigonometry

// Already provided by the system

// acos()
// cos()
// sin()
// tan()
// asin()
// atan()
// atan2()

public func degrees(_ radians: CGFloat) -> CGFloat {
    radians * 180 / .pi
}

public func radians(_ degrees: CGFloat) -> CGFloat {
    degrees * .pi / 180
}

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

public func strokeWeight(_ n: Int) {
    strokeWeight(CGFloat(n))
}

public func strokeWeight(_ n: CGFloat) {
    ctx?.setLineWidth(n)
}

public func translate(_ x: CGFloat, _ y: CGFloat) {
    ctx?.translateBy(x: x, y: y)
}

public func stroke(_ white: Int) {
    Color(white: CGFloat(white) / 255, alpha: 1.0).setStroke()
}

public func fill(_ color: Color) {
    color.setFill()
}

public func stroke(_ color: Color) {
    color.setStroke()
}

public func noStroke() {
    Color(white: 0, alpha: 0).setStroke()
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

public func map(_ value: CGFloat, _ minRange: CGFloat, _ maxRange: CGFloat, _ minDomain: CGFloat, _ maxDomain: CGFloat) -> CGFloat {
    minDomain + (maxDomain - minDomain) * (value - minRange) / (maxRange - minRange)
}
