//
//  Mitosis.swift
//  
//
//  Created by Vasilis Akoinoglou on 8/8/20.
//

import Foundation

public class MitosisSketch: SPSView {
    fileprivate var cells = [Cell]()

    public override func setup() {
        cells.append(Cell(width, height))
        cells.append(Cell(width, height))
    }

    public override func draw() {
        background(200)
        for c in cells {
            c.move()
            c.show()
        }
    }

    public override func mousePressed() {
        for (i, c) in cells.reversed().enumerated() {
            if c.clicked(mouseX, mouseY) {
                cells.append(c.mitosis())
                cells.append(c.mitosis())
                cells.remove(at: i)
            }
        }
    }
}




fileprivate class Cell {
    var pos: PVector
    let r: CGFloat
    let c: SPColor

    init(_ pos: PVector,_ r: CGFloat, _ c: SPColor) {
        self.pos = pos
        self.r = r
        self.c = c
    }

    init(_ width: CGFloat, _ height: CGFloat) {
        let w: CGFloat = random(width)
        let h: CGFloat = random(height)
        pos = PVector(Double(w), Double(h), 0.0)
        r   = 60
        c   = color(random(100, 255), 0, random(100, 255), 100)
    }


    func clicked(_ x: CGFloat, _ y: CGFloat) -> Bool {
        let d: CGFloat = dist(CGFloat(pos.x), CGFloat(pos.y), x, y)
        return d < r
    }

    func mitosis() -> Cell {
        Cell(pos, r * 0.8, c)
    }

    func move() {
        let vel = PVector.random2D()
        pos.add(vel)
    }

    func show() {
        noStroke()
        fill(c)
        ellipse(CGFloat(pos.x), CGFloat(pos.y), r, r)
    }
}
