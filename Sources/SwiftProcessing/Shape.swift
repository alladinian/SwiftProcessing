//
//  2DPrimitives.swift
//  
//
//  Created by Vasilis Akoinoglou on 28/7/20.
//

import Foundation
import CoreGraphics

protocol Shape {
    var position: CGPoint { get }
    var path: CGPath { get }
}

struct Arc: Shape {
    let position: CGPoint
    let path: CGPath

    init(position: CGPoint, width: CGFloat, height: CGFloat, start: CGFloat, stop: CGFloat) {
        self.position = position

        var start = start
        var stop = stop

        // Mac's implementation expects angles in degrees
        #if os(macOS)
        start = degrees(start)
        stop  = degrees(stop)
        #endif

        let path = BezierPath()

        #if os(iOS)
        path.addArc(withCenter: position,
                    radius: width / 2,
                    startAngle: start,
                    endAngle: stop,
                    clockwise: false)
        #endif

        #if os(macOS)
        path.appendArc(withCenter: position,
                       radius: width / 2,
                       startAngle: start,
                       endAngle: stop,
                       clockwise: false)
        #endif

        self.path = path.cgPath
    }
}

//MARK: - 2D Primitives

/**
 Draws an arc to the screen. Arcs are drawn along the outer edge of an ellipse defined by the a, b, c, and d parameters. The origin of the arc's ellipse may be changed with the ellipseMode() function. Use the start and stop parameters to specify the angles (in radians) at which to draw the arc. The start/stop values must be in clockwise order.

 There are three ways to draw an arc; the rendering technique used is defined by the optional seventh parameter. The three options, depicted in the above examples, are PIE, OPEN, and CHORD. The default mode is the OPEN stroke with a PIE fill.

 In some cases, the arc() function isn't accurate enough for smooth drawing. For example, the shape may jitter on screen when rotating slowly. If you're having an issue with how arcs are rendered, you'll need to draw the arc yourself with beginShape()/endShape() or a PShape.

 - Parameters:
   - a: x-coordinate of the arc's ellipse
   - b: y-coordinate of the arc's ellipse
   - c: width of the arc's ellipse by default
   - d: height of the arc's ellipse by default
   - start: angle to start the arc, specified in radians
   - stop: angle to stop the arc, specified in radians
   - mode: rendering mode
 */
public func arc(_ a: CGFloat,
                _ b: CGFloat,
                _ c: CGFloat,
                _ d: CGFloat,
                _ start: CGFloat,
                _ stop: CGFloat,
                _ mode: Any? = nil) {
    #warning("add modes")
    var start = start
    var stop = stop

    // Mac's implementation expects angles in degrees
    #if os(macOS)
    start = degrees(start)
    stop  = degrees(stop)
    #endif

    let path = BezierPath()

    #if os(iOS)
    path.addArc(withCenter: .init(x: a, y: b),
                radius: c / 2,
                startAngle: start,
                endAngle: stop,
                clockwise: false)
    #endif

    #if os(macOS)
    path.appendArc(withCenter: .init(x: a, y: b),
                   radius: c / 2,
                   startAngle: start,
                   endAngle: stop,
                   clockwise: false)
    #endif

    path.stroke()
}

/**
 Draws a circle to the screen. By default, the first two parameters set the location of the center, and the third sets the shape's width and height. The origin may be changed with the ellipseMode() function.

 - Parameters:
   - x: x-coordinate of the ellipse
   - y: y-coordinate of the ellipse
   - extent: width and height of the ellipse by default
 */
public func circle(_ x: CGFloat, _ y: CGFloat, _ extent: CGFloat) {
    ellipse(x, y, extent, extent)
}

/**
 Draws an ellipse (oval) to the screen. An ellipse with equal width and height is a circle. By default, the first two parameters set the location, and the third and fourth parameters set the shape's width and height. The origin may be changed with the ellipseMode() function.

 - Parameters:
   - a: x-coordinate of the ellipse
   - b: y-coordinate of the ellipse
   - c: width of the ellipse by default
   - d: height of the ellipse by default
 */
public func ellipse(_ a: CGFloat,
                    _ b: CGFloat,
                    _ c: CGFloat,
                    _ d: CGFloat) {
    push()

    var c = c
    var d = d
    var crect: CGRect?

    switch currentEllipseMode {
    case .center:
        translate(-c/2, -d/2)
    case .radius:
        translate(-c/2, -d/2)
        c *= 2
        d *= 2
    case .corner:
        break // The default behavior
    case .corners:
        let p1 = CGPoint(x: a, y: b)
        let p2 = CGPoint(x: c, y: d)
        crect = CGRect(x: min(p1.x, p2.x),
                       y: min(p1.y, p2.y),
                       width: abs(p1.x - p2.x),
                       height: abs(p1.y - p2.y))
    }

    let path = BezierPath(ovalIn: crect ?? .init(x: a, y: b, width: c, height: d))
    path.stroke()
    path.fill()

    pop()
}

/**
 Draws a line (a direct path between two points) to the screen. The version of line() with four parameters draws the line in 2D. To color a line, use the stroke() function. A line cannot be filled, therefore the fill() function will not affect the color of a line. 2D lines are drawn with a width of one pixel by default, but this can be changed with the strokeWeight() function. The version with six parameters allows the line to be placed anywhere within XYZ space. Drawing this shape in 3D with the z parameter requires the P3D parameter in combination with size() as shown in the above example.

 - Parameters:
   - x1: x-coordinate of the first point
   - y1: y-coordinate of the first point
   - x2: x-coordinate of the second point
   - y2: y-coordinate of the second point
 */
public func line(_ x1: CGFloat,
                 _ y1: CGFloat,
                 _ x2: CGFloat,
                 _ y2: CGFloat) {
    let path = BezierPath()
    path.move(to: .init(x: x1, y: y1))
    path.line(to: .init(x: x2, y: y2))
    path.stroke()
}

public func line(_ a: PVector, _ b: PVector) {
    line(CGFloat(a.x), CGFloat(a.y), CGFloat(b.x), CGFloat(b.y))
}

 /**
 Draws a point, a coordinate in space at the dimension of one pixel. The first parameter is the horizontal value for the point, the second value is the vertical value for the point, and the optional third value is the depth value. Drawing this shape in 3D with the z parameter requires the P3D parameter in combination with size() as shown in the above example.

 Use stroke() to set the color of a point().

 Point appears round with the default strokeCap(ROUND) and square with strokeCap(PROJECT). Points are invisible with strokeCap(SQUARE) (no cap).

 Using point() with strokeWeight(1) or smaller may draw nothing to the screen, depending on the graphics settings of the computer. Workarounds include setting the pixel using set() or drawing the point using either circle() or square().

 - Parameters:
   - x: x-coordinate of the point
   - y: y-coordinate of the point
*/
public func point(_ x: CGFloat, _ y: CGFloat) {
    line(x, y, x + currentStrokeWeight, y)
}

/**
 A quad is a quadrilateral, a four sided polygon. It is similar to a rectangle, but the angles between its edges are not constrained to ninety degrees. The first pair of parameters (x1,y1) sets the first vertex and the subsequent pairs should proceed clockwise or counter-clockwise around the defined shape.

 - Parameters:
   - x1: x-coordinate of the first corner
   - y1: y-coordinate of the first corner
   - x2: x-coordinate of the second corner
   - y2: y-coordinate of the second corner
   - x3: x-coordinate of the third corner
   - y3: y-coordinate of the third corner
   - x4: x-coordinate of the fourth corner
   - y4: y-coordinate of the fourth corner
*/
public func quad(_ x1: CGFloat,
                 _ y1: CGFloat,
                 _ x2: CGFloat,
                 _ y2: CGFloat,
                 _ x3: CGFloat,
                 _ y3: CGFloat,
                 _ x4: CGFloat,
                 _ y4: CGFloat) {
    let path = BezierPath()
    path.move(to: .init(x: x1, y: y1))
    path.line(to: .init(x: x2, y: y2))
    path.line(to: .init(x: x3, y: y3))
    path.line(to: .init(x: x4, y: y4))
    path.close()
    path.stroke()
    path.fill()
}

/**
 Draws a rectangle to the screen. A rectangle is a four-sided shape with every angle at ninety degrees. By default, the first two parameters set the location of the upper-left corner, the third sets the width, and the fourth sets the height. The way these parameters are interpreted, however, may be changed with the rectMode() function.

 To draw a rounded rectangle, add a fifth parameter, which is used as the radius value for all four corners.

 To use a different radius value for each corner, include eight parameters. When using eight parameters, the latter four set the radius of the arc at each corner separately, starting with the top-left corner and moving clockwise around the rectangle.

 - Parameters:
   - a: x-coordinate of the rectangle by default
   - b: y-coordinate of the rectangle by default
   - c: width of the rectangle by default
   - d: height of the rectangle by default
   - r: radii for all four corners
   - tl: radius for top-left corner
   - tr: radius for top-right corner
   - br: radius for bottom-right corner
   - bl: radius for bottom-left corner
 */
public func rect(_ a: CGFloat,
                 _ b: CGFloat,
                 _ c: CGFloat,
                 _ d: CGFloat,
                 _ r: CGFloat?  = 0,
                 _ tl: CGFloat? = 0,
                 _ tr: CGFloat? = 0,
                 _ br: CGFloat? = 0,
                 _ bl: CGFloat? = 0) {
    let path = BezierPath(rect: .init(x: a, y: b, width: c, height: d),
                          radii: r,
                          topLeft: tl,
                          topRight: tr,
                          bottomRight: br,
                          bottomLeft: bl)
    path.stroke()
    path.fill()
}

/**
 Draws a square to the screen. A square is a four-sided shape with every angle at ninety degrees and each side is the same length. By default, the first two parameters set the location of the upper-left corner, the third sets the width and height. The way these parameters are interpreted, however, may be changed with the rectMode() function.

 - Parameters:
   - x: x-coordinate of the rectangle by default
   - y: y-coordinate of the rectangle by default
   - extent: width and height of the rectangle by default
 */
public func square(_ x: CGFloat, _ y: CGFloat, _ extent: CGFloat) {
    let path = BezierPath(rect: .init(x: x, y: y, width: extent, height: extent))
    path.fill()
    path.stroke()
}

/**
 A triangle is a plane created by connecting three points. The first two arguments specify the first point, the middle two arguments specify the second point, and the last two arguments specify the third point.

 - Parameters:
   - x1: x-coordinate of the first point
   - y1: y-coordinate of the first point
   - x2: x-coordinate of the second point
   - y2: y-coordinate of the second point
   - x3: x-coordinate of the third point
   - y3: y-coordinate of the third point
 */
public func triangle(_ x1: CGFloat,
                     _ y1: CGFloat,
                     _ x2: CGFloat,
                     _ y2: CGFloat,
                     _ x3: CGFloat,
                     _ y3: CGFloat) {
    let path = BezierPath()
    path.move(to: .init(x: x1, y: y1))
    path.line(to: .init(x: x2, y: y2))
    path.line(to: .init(x: x3, y: y3))
    path.close()
    path.stroke()
}

//MARK: - Attributes

var currentStrokeWeight: CGFloat = 1.0

public func strokeWeight(_ n: Int) {
    strokeWeight(CGFloat(n))
}

public func strokeWeight(_ n: CGFloat) {
    renderer.strokeWeight(n)
}

public enum EllipseMode: Int {
    case center, radius, corner, corners
}

public let CENTER  = EllipseMode.center
public let RADIUS  = EllipseMode.radius
public let CORNER  = EllipseMode.corner
public let CORNERS = EllipseMode.corners

var currentEllipseMode: EllipseMode = .center

public func ellipseMode(_ mode: EllipseMode) {
    currentEllipseMode = mode
}

public extension CGLineCap {
    static let PROJECT = CGLineCap.butt
    static let ROUND   = CGLineCap.round
    static let SQUARE  = CGLineCap.square
}

public extension CGLineJoin {
    static let MITER = CGLineJoin.miter
    static let BEVEL = CGLineJoin.bevel
    static let ROUND = CGLineJoin.round
}

public func strokeCap(_ cap: CGLineCap) {
    renderer.strokeCap(cap)
}

public func strokeJoin(_ join: CGLineJoin) {
    renderer.strokeJoin(join)
}

//MARK: - Vertex

public enum EndShapeMode: Int {
    case open, close
}

extension SPView {
    public var CLOSE: EndShapeMode { EndShapeMode.close }
}

public func beginShape() {
    renderer.beginShape()
}

public func endShape(_ mode: EndShapeMode = .open) {
    renderer.endShape(mode)
}

public func vertex(_ v: PVector) {
    vertex(CGFloat(v.x), CGFloat(v.y))
}

public func vertex(_ x: CGFloat, _ y: CGFloat) {
    renderer.vertex(x, y)
}





