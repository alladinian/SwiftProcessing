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
