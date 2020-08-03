//
//  FractalTree.swift
//  
//
//  Created by Vasilis Akoinoglou on 3/8/20.
//

import Foundation
import CoreGraphics

public class FractalTreeSketch: SPSView {

    var angle: CGFloat!
    var slider: Slider!

    public override func setup() {
        slider = createSlider(0, TWO_PI, PI/4, 0.01)
    }

    public override func draw() {
        strokeWeight(1)
        background(20)
        angle = CGFloat(slider.doubleValue)
        stroke(255)
        translate(width/2, height)
        branch(height * 0.3)
    }

    func branch(_ len: CGFloat) {
        line(0, 0, 0, -len)
        translate(0, -len)
        if len > 4 {
            push()
            rotate(angle)
            branch(len * 0.67)
            pop()
            push()
            rotate(-angle)
            branch(len * 0.67)
            pop()
        }
    }
}
