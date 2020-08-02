//
//  Map.swift
//  
//
//  Created by Vasilis Akoinoglou on 1/8/20.
//

import Foundation

#if canImport(AppKit)
import AppKit

public class MapSketch: SPSView {

    public override func setup() {
        noStroke()
    }

    public override func draw() {
        background(0)
        // Scale the mouseX value from 0 to 640 to a range between 0 and 175
        let c = map(mouseX, 0, width, 0, 175)
        // Scale the mouseX value from 0 to 640 to a range between 40 and 300
        let d = map(mouseX, 0, width, 40, 300)
        fill(255, c, 0)
        ellipse(width/2, height/2, d, d)
    }

}

#endif
