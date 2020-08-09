//
//  Spirograph.swift
//  
//
//  Created by Vasilis Akoinoglou on 10/8/20.
//

import Foundation

let k          = -4.0
let resolution = 1.0

public class SpirographSketch: SPSView {
    lazy var sun = Orbit(width / 2, height / 2, width / 6, 0)
    var end: Orbit!
    var path = [PVector]()

    public override func setup() {
        var next = sun
        for _ in 0..<10 {
            next = next.addChild()
        }
        end = next
    }

    public override func draw() {
        background(51)

        for _ in 0..<Int(resolution) {
            var next: Orbit? = sun
            while next != nil {
                next?.update()
                next = next?.child
            }
            let v = PVector(end.x, end.y, 0)
            path.append(v)
        }

        var next: Orbit? = sun
        while next != nil {
            next?.show()
            next = next?.child
        }

        beginShape()
        stroke(255)
        noFill()
        for pos in path {
            vertex(pos)
            //point(CGFloat(pos.x), CGFloat(pos.y))
        }
        endShape()
    }

}


class Orbit {
    var x, y, r: CGFloat
    var n: Int
    weak var parent: Orbit?
    var child: Orbit?
    var speed: CGFloat
    var angle: CGFloat

    init(_ x: CGFloat, _ y: CGFloat, _ r: CGFloat, _ n: Int, _ p: Orbit? = nil) {
        self.x      = x
        self.y      = y
        self.r      = r
        self.n      = n
        self.speed  = CGFloat((radians(pow(k, Double(n - 1)))) / resolution)
        self.parent = p
        self.child  = nil
        self.angle  = -PI / 2
    }

    func addChild() -> Orbit {
        let newr = r / 3.0
        let newx = x + r + newr
        let newy = y
        child = Orbit(newx, newy, newr, n + 1, self)
        return child!
    }

    func update() {
        guard let parent = parent else { return }
        angle += speed
        let rsum = r + parent.r
        x = parent.x + rsum * cos(angle)
        y = parent.y + rsum * sin(angle)
    }

    func show() {
        stroke(255, 100)
        strokeWeight(1)
        noFill()
        if let parent = parent {
            line(parent.x, parent.y, x, y)
        }
        ellipse(x, y, r * 2, r * 2)
    }

}
