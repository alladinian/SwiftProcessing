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

public func fill(_ white: Int, _ alpha: CGFloat = 255) {
    Color(white: CGFloat(white) / 255, alpha: alpha / 255).setFill()
}

public func fill(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat) {
    Color(r, g, b).setFill()
}

public func noFill() {
    Color(white: 0, alpha: 0).setFill()
}

public func stroke(_ color: Color) {
    color.setStroke()
}

public func stroke(_ white: Int, _ alpha: CGFloat = 255) {
    Color(white: CGFloat(white) / 255, alpha: alpha / 255).setStroke()
}

public func noStroke() {
    Color(white: 0, alpha: 0).setStroke()
}

//MARK: - Creating & Reading

extension Color {
    var alpha: CGFloat { alphaComponent }
    var red: CGFloat { redComponent }
    var green: CGFloat { greenComponent }
    var blue: CGFloat { blueComponent }
    var hue: CGFloat { hueComponent }
    var saturation: CGFloat { saturationComponent }
    var brightness: CGFloat { brightnessComponent }

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
