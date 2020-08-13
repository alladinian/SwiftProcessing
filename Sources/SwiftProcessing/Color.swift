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

extension UIColor {
    var alphaComponent: CGFloat {
        cgColor.alpha
    }
    var redComponent: CGFloat {
        cgColor.components![0]
    }
    var greenComponent: CGFloat {
        cgColor.components![1]
    }
    var blueComponent: CGFloat {
        cgColor.components![2]
    }
    var hueComponent: CGFloat {
        var component: CGFloat!
        getHue(&component, saturation: nil, brightness: nil, alpha: nil)
        return component
    }
    var saturationComponent: CGFloat {
        var component: CGFloat!
        getHue(nil, saturation: &component, brightness: nil, alpha: nil)
        return component
    }
    var brightnessComponent: CGFloat {
        var component: CGFloat!
        getHue(nil, saturation: nil, brightness: &component, alpha: nil)
        return component
    }
}

#endif

//MARK: - Setting

public func background(_ white: Int) {
    renderer.background(white)
}

public func background(_ color: Color) {
    renderer.background(color)
}

public func fill(_ color: Color) {
    renderer.fill(color)
}

public func fill(_ white: Int, _ alpha: CGFloat = 255) {
    renderer.fill(white, alpha)
}

public func fill(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat) {
    renderer.fill(r, g, b)
}

public func noFill() {
    renderer.noFill()
}

public func stroke(_ color: Color) {
    renderer.stroke(color)
}

public func stroke(_ white: Int, _ alpha: CGFloat = 255) {
    renderer.stroke(white, alpha)
}

public func stroke(_ r: Int, _ g: Int, _ b: Int, _ a: Int = 255) {
    renderer.stroke(r, g, b, a)
}

public func noStroke() {
    renderer.noStroke()
}

//MARK: - Creating & Reading

extension Color {
    var alpha: CGFloat { alphaComponent * 255 }
    var red: CGFloat { redComponent * 255 }
    var green: CGFloat { greenComponent * 255 }
    var blue: CGFloat { blueComponent * 255 }
    var hue: CGFloat { hueComponent * 255 }
    var saturation: CGFloat { saturationComponent * 255 }
    var brightness: CGFloat { brightnessComponent * 255 }

    convenience init(_ v1: Int, _ v2: Int, _ v3: Int, _ alpha: Int = 255) {
        self.init(red: CGFloat(v1) / 255, green: CGFloat(v2) / 255, blue: CGFloat(v3) / 255, alpha: CGFloat(alpha) / 255)
    }

    convenience init(_ v1: CGFloat, _ v2: CGFloat, _ v3: CGFloat, _ alpha: CGFloat = 255) {
        self.init(red: v1 / 255, green: v2 / 255, blue: v3 / 255, alpha: alpha / 255)
    }
}

public func color(_ white: Int, _ alpha: CGFloat = 255) -> Color {
    Color(white: CGFloat(white) / 255, alpha: alpha / 255)
}

public func color(_ v1: CGFloat, _ v2: CGFloat, _ v3: CGFloat, _ alpha: CGFloat = 255) -> Color {
    Color(red: v1 / 255, green: v2 / 255, blue: v3 / 255, alpha: alpha / 255)
}

public func alpha(_ c: Color) -> CGFloat {
    c.alpha
}

public func red(_ c: Color) -> CGFloat {
    c.red
}

public func green(_ c: Color) -> CGFloat {
    c.green
}

public func blue(_ c: Color) -> CGFloat {
    c.blue
}

public func hue(_ c: Color) -> CGFloat {
    c.hue
}

public func saturation(_ c: Color) -> CGFloat {
    c.saturation
}

public func brightness(_ c: Color) -> CGFloat {
    c.brightness
}
