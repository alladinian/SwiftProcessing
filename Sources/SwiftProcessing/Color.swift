//
//  Color.swift
//  
//
//  Created by Vasilis Akoinoglou on 31/7/20.
//

#if canImport(AppKit)
import AppKit
public typealias Color = NSColor
#endif
#if canImport(UIKit)
import UIKit
public typealias Color = UIColor
#endif

public extension View {

    private var _layer: CALayer? {
        layer
    }

    func background(_ white: Int) {
        _layer?.backgroundColor = Color(white: CGFloat(white) / 255, alpha: 1.0).cgColor
    }

    func background(_ color: Color) {
        _layer?.backgroundColor = color.cgColor
    }

}

public func fill(_ color: Color) {
    color.setFill()
}

public func fill(_ white: Int, _ alpha: CGFloat = 1.0) {
    Color(white: CGFloat(white) / 255, alpha: alpha).setFill()
}

public func noFill() {
    Color(white: 0, alpha: 0).setFill()
}

public func stroke(_ color: Color) {
    color.setStroke()
}

public func stroke(_ white: Int, _ alpha: CGFloat = 1.0) {
    Color(white: CGFloat(white) / 255, alpha: alpha).setStroke()
}

public func noStroke() {
    Color(white: 0, alpha: 0).setStroke()
}
