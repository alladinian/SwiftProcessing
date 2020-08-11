//
//  File.swift
//  
//
//  Created by Vasilis Akoinoglou on 11/8/20.
//

import XCTest
@testable import SwiftProcessing

final class VectorTests: XCTestCase {

    func testInitialization() {
        // Int
        let iv = PVector(1, 2, 3)
        // CGFLoat
        let cgv = PVector(CGFloat(1), CGFloat(2), CGFloat(3))
        // Double
        let dv = PVector(1.0, 2.0, 3.0)
        // 2D Double
        let dv2 = PVector(1.0, 2.0)
        XCTAssertEqual(iv, cgv)
        XCTAssertEqual(dv, cgv)
        XCTAssertEqual(dv2, PVector(1, 2))
    }

    func testAddition() {
        var a = PVector.random2D()
        let b = PVector.random2D()
        let c = PVector(a.x + b.x, a.y + b.y)
        XCTAssertEqual(a + b, c)
        XCTAssertEqual(PVector.add(a, b), c)
        a.add(b)
        XCTAssertEqual(a, c)
    }

    func testNormalization() {
        var a = PVector(2, 3)
        a.normalize()
        XCTAssertEqual(a.mag(), 1)
    }

    func testMagnitude() {
        let a = PVector.random2D()
        XCTAssertEqual(sqrt(a.x * a.x + a.y * a.y), a.mag())
    }

}
