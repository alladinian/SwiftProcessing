//
//  Curves.swift
//  
//
//  Created by Vasilis Akoinoglou on 31/7/20.
//

import Foundation
import CoreGraphics

/**
 Draws a Bezier curve on the screen. These curves are defined by a series of anchor and control points. The first two parameters specify the first anchor point and the last two parameters specify the other anchor point. The middle parameters specify the control points which define the shape of the curve. Bezier curves were developed by French engineer Pierre Bezier. Using the 3D version requires rendering with P3D (see the Environment reference for more information).

 - Parameters:
   - x1: coordinates for the first anchor point
   - y1: coordinates for the first anchor point
   - x2: coordinates for the first control point
   - y2: coordinates for the first control point
   - x3: coordinates for the second anchor point
   - y3: coordinates for the second anchor point
   - x4: coordinates for the second control point
   - y4: coordinates for the second control point
 */
public func bezier(_ x1: CGFloat,
                   _ y1: CGFloat,
                   _ x2: CGFloat,
                   _ y2: CGFloat,
                   _ x3: CGFloat,
                   _ y3: CGFloat,
                   _ x4: CGFloat,
                   _ y4: CGFloat) {
    let path = BezierPath()
    path.move(to: .init(x: x1, y: y1))
    path.curve(to: .init(x: x3, y: y3), controlPoint1: .init(x: x2, y: y2), controlPoint2: .init(x: x4, y: y4))
    path.stroke()
}

/**
 Specifies vertex coordinates for Bezier curves. Each call to bezierVertex() defines the position of two control points and one anchor point of a Bezier curve, adding a new segment to a line or shape. The first time bezierVertex() is used within a beginShape() call, it must be prefaced with a call to vertex() to set the first anchor point. This function must be used between beginShape() and endShape() and only when there is no MODE parameter specified to beginShape(). Using the 3D version requires rendering with P3D (see the Environment reference for more information).
 - Parameters:
   - x2: the x-coordinate of the 1st control point
   - y2: the y-coordinate of the 1st control point
   - x3: the x-coordinate of the 2nd control point
   - y3: the y-coordinate of the 2nd control point
   - x4: the x-coordinate of the anchor point
   - y4: the y-coordinate of the anchor point
 */
public func bezierVertex(_ x2: CGFloat,
                         _ y2: CGFloat,
                         _ x3: CGFloat,
                         _ y3: CGFloat,
                         _ x4: CGFloat,
                         _ y4: CGFloat) {
    ctx?.addCurve(to: .init(x: x4, y: y4), control1: .init(x: x2, y: y2), control2: .init(x: x3, y: y3))
}
