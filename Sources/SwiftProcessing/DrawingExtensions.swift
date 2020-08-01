//
//  DrawingExtensions.swift
//  SwiftProcessing-Mac
//
//  Created by Vasilis Akoinoglou on 11/06/2019.
//

// Note: Coordinate system is like iOS (zero == topLeft), so we always flip layers on mac

#if canImport(AppKit)
import AppKit
typealias BezierPath = NSBezierPath
#elseif canImport(UIKit)
import UIKit
typealias BezierPath = UIBezierPath
#endif


public extension BezierPath {

    // Compatibility bewteen NSBezierPath and UIBezierPath

    #if os(iOS) || os(tvOS)
    func curve(to point: CGPoint, controlPoint1: CGPoint, controlPoint2: CGPoint) {
        addCurve(to: point, controlPoint1: controlPoint1, controlPoint2: controlPoint2)
    }

    func line(to point: CGPoint) {
        addLine(to: point)
    }
    #endif

    convenience init(rect: CGRect, radii: CGFloat? = nil, topLeft: CGFloat? = nil, topRight: CGFloat? = nil, bottomRight: CGFloat? = nil, bottomLeft: CGFloat? = nil) {

        self.init()

        let maxX: CGFloat = rect.maxX
        let minX: CGFloat = rect.minX
        let maxY: CGFloat = rect.maxY
        let minY: CGFloat = rect.minY

        let bottomRightCorner = CGPoint(x: maxX, y: maxY)

        move(to: bottomRightCorner)

        if let bottomRight = bottomRight ?? radii {
            line(to: CGPoint(x: maxX - bottomRight, y: maxY))
            curve(to: CGPoint(x: maxX, y: maxY - bottomRight), controlPoint1: bottomRightCorner, controlPoint2: bottomRightCorner)
        } else {
            line(to: bottomRightCorner)
        }

        let topRightCorner = CGPoint(x: maxX, y: minY)

        if let topRight = topRight ?? radii {
            line(to: CGPoint(x: maxX, y: minY + topRight))
            curve(to: CGPoint(x: maxX - topRight, y: minY), controlPoint1: topRightCorner, controlPoint2: topRightCorner)
        } else {
            line(to: topRightCorner)
        }

        let topLeftCorner = CGPoint(x: minX, y: minY)

        if let topLeft = topLeft ?? radii {
            line(to: CGPoint(x: minX + topLeft, y: minY))
            curve(to: CGPoint(x: minX, y: minY + topLeft), controlPoint1: topLeftCorner, controlPoint2: topLeftCorner)
        } else {
            line(to: topLeftCorner)
        }

        let bottomLeftCorner = CGPoint(x: minX, y: maxY)

        if let bottomLeft = bottomLeft ?? radii {
            line(to: CGPoint(x: minX, y: maxY - bottomLeft))
            curve(to: CGPoint(x: minX + bottomLeft, y: maxY), controlPoint1: bottomLeftCorner, controlPoint2: bottomLeftCorner)
        } else {
            line(to: bottomLeftCorner)
        }

        close()
    }
}

#if canImport(AppKit)
extension NSBezierPath {

    var cgPath: CGPath {
        transformToCGPath()
    }

    /// Transforms the NSBezierPath into a CGPath
    ///
    /// :returns: The transformed NSBezierPath
    private func transformToCGPath() -> CGPath {

        // Create path
        let path = CGMutablePath()
        let points = UnsafeMutablePointer<NSPoint>.allocate(capacity: 3)
        let numElements = self.elementCount

        if numElements > 0 {

            var didClosePath = true

            for index in 0..<numElements {

                let pathType = self.element(at: index, associatedPoints: points)

                switch pathType {

                case .moveTo:
                    path.move(to: CGPoint(x: points[0].x, y: points[0].y))
                case .lineTo:
                    path.addLine(to: CGPoint(x: points[0].x, y: points[0].y))
                    didClosePath = false
                case .curveTo:
                    path.addCurve(to: CGPoint(x: points[0].x, y: points[0].y),
                                  control1: CGPoint(x: points[1].x, y: points[1].y),
                                  control2: CGPoint(x: points[2].x, y: points[2].y))
                    didClosePath = false
                case .closePath:
                    path.closeSubpath()
                    didClosePath = true
                @unknown default:
                    break
                }
            }

            if !didClosePath { path.closeSubpath() }
        }

        points.deallocate()
        return path
    }
}
#endif
