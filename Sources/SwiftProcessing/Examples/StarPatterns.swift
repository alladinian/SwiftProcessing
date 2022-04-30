//
//  StarPatterns.swift
//  
//
//  Created by Vasilis Akoinoglou on 13/8/20.
//

import Foundation

var angle: CGFloat = 75
var delta: CGFloat = 10

public class StarPatternsSketch: SPSView {

    var deltaSlider: SPSlider!
    var angleSlider: SPSlider!

    var polys = [Polygon]()

    public override func setup() {
        //size(600, 600)

        background(51)

        deltaSlider = createSlider(10, 25, 10, 1)
        angleSlider = createSlider(75, 90, 75, 1)

        let inc: CGFloat = 100

        for x in stride(from: 0, to: width, by: inc) {
            for y in stride(from: 0, to: height, by: inc) {
                var poly = Polygon()
                poly.addVertex(x, y)
                poly.addVertex(x + inc, y)
                poly.addVertex(x + inc, y + inc)
                poly.addVertex(x, y + inc)
                poly.close()
                polys.append(poly)
            }
        }
    }

    public override func draw() {
        background(51)
        angle = CGFloat(angleSlider.doubleValue)
        delta = CGFloat(deltaSlider.doubleValue)
        //println(angle, delta);
        for poly in polys {
            poly.hankin()
            poly.show()
        }
    }

}

struct Hankin {
    var a: PVector
    var v: PVector
    lazy var b: PVector = a + v
    var end: PVector?
    var prevD: Double = 0

    func show() {
        stroke(255, 0, 255)
        if let end = end {
            line(a, end)
        }
        // fill(255);
        // ellipse(this.a.x, this.a.y, 8);
        // if (this.end) {
        //   fill(255, 255, 0);
        //   ellipse(this.end.x, this.end.y, 8);
        // }
    }

    mutating func findEnd(_ other: Hankin?) {
        guard let other = other else { return }
        // line line intersection???
        // this.a, this.v  (P1, P2-P1)
        // other.a, other.v (P3, P4-P3)

        // From: http://paulbourke.net/geometry/pointlineplane/
        let den = (other.v.y * v.x) - (other.v.x * v.y)
        //if (!den) {
        //  return;
        //}
        if den == 0.0 {
            return
        }

        let numa = (other.v.x * (a.y - other.a.y)) - (other.v.y * (a.x - other.a.x))
        let numb = (v.x * (a.y - other.a.y)) - (v.y * (a.x - other.a.x))
        let ua = numa / den
        let ub = numb / den
        let x = a.x + (ua * v.x)
        let y = a.y + (ua * v.y)

        if ua > 0 && ub > 0 {
            let candidate = PVector(x, y)
            let d1 = PVector.dist(candidate, a)
            let d2 = PVector.dist(candidate, other.a)
            let d = d1 + d2
            let diff = abs(d1 - d2)

            if diff < 0.001 {
                if end == nil {
                    end = candidate
                    prevD = d
                } else if d < prevD {
                    prevD = d
                    end = candidate
                }
            }
        }
    }
};

class Edge {

    var a: PVector
    var b: PVector
    var h1: Hankin?
    var h2: Hankin?

    init(_ a: PVector, _ b: PVector) {
        self.a = a
        self.b = b
        self.h1 = nil
        self.h2 = nil
    }

    func show() {
        stroke(255, 50);
        //line(a.x, a.y, b.x, b.y);
        h1?.show()
        h2?.show()
    }

    func hankin() {
        var mid = PVector.add(a, b)
        mid.mult(0.5)

        var v1 = PVector.sub(a, mid)
        var v2 = PVector.sub(b, mid)
        var offset1 = mid
        var offset2 = mid
        if delta > 0 {
            v1.setMag(Double(delta))
            v2.setMag(Double(delta))
            offset1 = PVector.add(mid, v2)
            offset2 = PVector.add(mid, v1)
        }

        v1.normalize()
        v2.normalize()

        v1.rotate(radians(-Double(angle)))
        v2.rotate(radians(Double(angle)))

        h1 = Hankin(a: offset1, v: v1)
        h2 = Hankin(a: offset2, v: v2)
    }

    func findEnds(_ edge: Edge) {
        h1?.findEnd(edge.h1)
        h1?.findEnd(edge.h2)
        h2?.findEnd(edge.h1)
        h2?.findEnd(edge.h2)
    }
}

struct Polygon {
    var vertices = [PVector]()
    var edges = [Edge]()

    mutating func addVertex(_ x: CGFloat, _ y: CGFloat) {
        let a = PVector(x, y)
        let total = vertices.count
        if total > 0 {
            let prev = vertices.last!
            let edge = Edge(prev, a)
            edges.append(edge)
        }
        vertices.append(a)
    }

    mutating func close() {
        let last  = vertices.last!
        let first = vertices.first!
        let edge  = Edge(last, first)
        edges.append(edge)
    }

    func hankin() {
        for edge in edges {
            edge.hankin()
        }

        for (i, _) in edges.enumerated() {
            for (j, _) in edges.enumerated() {
                if (i != j) {
                    edges[i].findEnds(edges[j])
                }
            }
        }
    }

    func show() {
        for edge in edges {
            edge.show()
        }
    }
};
