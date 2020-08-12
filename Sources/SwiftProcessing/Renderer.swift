//
//  Renderer.swift
//  
//
//  Created by Vasilis Akoinoglou on 12/8/20.
//

import Foundation

public protocol Sketch {

}

public protocol Renderer {
    var width: Int { get }
    var height: Int { get }
    func push()
    func pop()
    func translate(_ x: CGFloat, _ y: CGFloat)
    func scale(_ x: CGFloat, _ y: CGFloat)
    func smooth()
    func noSmooth()
    func rotate(_ angle: CGFloat)
    func clear()
    func beginShape()
    func endShape(_ mode: EndShapeMode)
    func vertex(_ x: CGFloat, _ y: CGFloat)
    func strokeCap(_ cap: CGLineCap)
    func strokeJoin(_ join: CGLineJoin)
    func strokeWeight(_ n: CGFloat)
}

extension CGContext: Renderer {

    public func push() {
        saveGState()
    }

    public func pop() {
        restoreGState()
    }

    public func translate(_ x: CGFloat, _ y: CGFloat) {
        translateBy(x: x, y: y)
    }

    public func scale(_ x: CGFloat, _ y: CGFloat) {
        scaleBy(x: x, y: y)
    }

    public func rotate(_ angle: CGFloat) {
        rotate(by: angle)
    }

    public func smooth() {
        setShouldAntialias(true)
    }

    public func noSmooth() {
        setShouldAntialias(false)
    }

    public func clear() {
        clear(.init(origin: .zero, size: .init(width: width, height: height)))
    }

    public func beginShape() {
        beginPath()
    }

    public func endShape(_ mode: EndShapeMode = .open) {
        defer { strokePath() }
        guard mode == .close else { return }
        closePath()
        fillPath()
    }

    public func vertex(_ x: CGFloat, _ y: CGFloat) {
        guard isPathEmpty == false else {
            move(to: .init(x: x, y: y))
            return
        }
        addLine(to: .init(x: x, y: y))
    }

    public func strokeCap(_ cap: CGLineCap) {
        setLineCap(cap)
    }

    public func strokeJoin(_ join: CGLineJoin) {
        setLineJoin(join)
    }

    public func strokeWeight(_ n: CGFloat) {
        setLineWidth(n)
        currentStrokeWeight = n
    }

}
