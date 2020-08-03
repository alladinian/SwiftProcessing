//
//  PurpleRain.swift
//  
//
//  Created by Vasilis Akoinoglou on 3/8/20.
//

import Foundation
import CoreGraphics

public class PurpleRainSketchView: SPSView {

    var drops = [Drop]()

    public override func setup() {
        for _ in 0..<500 {
            drops.append(Drop())
        }
    }

    public override func draw() {
        strokeWeight(1)
        background(10)
        for (i, _) in drops.enumerated() {
            drops[i].fall()
            drops[i].show()
        }
    }

    struct Drop {
        lazy var x: CGFloat = random(SwiftProcessing.width)
        var y: CGFloat      = random(-500, -50)
        let z: CGFloat      = random(0, 20)
        lazy var len        = map(z, 0, 20, 10, 20)
        lazy var yspeed     = map(z, 0, 20, 1, 20)

        mutating func fall() {
            y = y + yspeed
            let grav = map(z, 0, 20, 0, 0.2)
            yspeed = yspeed + grav

            if y > SwiftProcessing.height {
                y = random(-200, -100)
                yspeed = map(z, 0, 20, 4, 10)
            }
        }

        mutating func show() {
            let thick = map(z, 0, 20, 1, 3)
            strokeWeight(thick)
            stroke(.purple)
            line(x, y, x, y + len)
        }
    }
}


