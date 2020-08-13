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
    func background(_ white: Int)
    func background(_ color: Color)
    func fill(_ color: Color)
    func fill(_ white: Int, _ alpha: CGFloat)
    func fill(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat)
    func noFill()
    func stroke(_ color: Color)
    func stroke(_ white: Int, _ alpha: CGFloat)
    func stroke(_ r: Int, _ g: Int, _ b: Int, _ a: Int)
    func noStroke()
}

extension CGContext: Renderer {

    private var bounds: CGRect {
        .init(origin: .zero, size: .init(width: width, height: height))
    }

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
        clear(bounds)
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

    public func background(_ white: Int) {
        background(Color(white: CGFloat(white) / 255, alpha: 1.0))
    }

    public func background(_ color: Color) {
        push()
        color.setFill()
        fill(bounds)
        pop()
    }

    public func fill(_ color: Color) {
        color.setFill()
    }

    public func fill(_ white: Int, _ alpha: CGFloat = 255) {
        fill(Color(white: CGFloat(white) / 255, alpha: alpha / 255))
    }

    public func fill(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat) {
        fill(Color(r, g, b))
    }

    public func noFill() {
        fill(Color(white: 0, alpha: 0))
    }

    public func stroke(_ color: Color) {
        color.setStroke()
    }

    public func stroke(_ white: Int, _ alpha: CGFloat = 255) {
        stroke(Color(white: CGFloat(white) / 255, alpha: alpha / 255))
    }

    public func stroke(_ r: Int, _ g: Int, _ b: Int, _ a: Int = 255) {
        stroke(Color(r, g, b, a))
    }

    public func noStroke() {
        stroke(Color(white: 0, alpha: 0))
    }

}
