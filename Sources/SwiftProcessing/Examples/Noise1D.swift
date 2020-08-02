//
//  Noise1D.swift
//  
//
//  Created by Vasilis Akoinoglou on 1/8/20.
//

import Foundation
import CoreGraphics

public class Noise1DSketch: SPSView {

    var xoff: CGFloat       = 0.0
    var xincrement: CGFloat = 0.01

    public override func setup() {
        //size(640, 360)
        background(0)
        noStroke()
    }

    public override func draw() {
        // Create an alpha blended background
        fill(0, 10)
        rect(0, 0, width, height)

        //let n = random(0, width)  // Try this line instead of noise

        // Get a noise value based on xoff and scale it according to the window's width
        let n = noise(xoff) * width

        // With each cycle, increment xoff
        xoff += xincrement

        // Draw the ellipse at the value produced by perlin noise
        fill(200)
        ellipse(n, height / 2, 64, 64)
    }

}
