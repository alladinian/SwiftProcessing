//
//  Vector.swift
//  
//
//  Created by Vasilis Akoinoglou on 30/7/20.
//

import Foundation
import simd

public typealias PVector = simd_double3

public extension PVector {

    static func random2D() -> PVector {
        var vector = random3D()
        vector.z = 0
        return vector
    }

    static func zero() -> PVector {
        PVector(0, 0, 0)
    }

    mutating func limit(_ max: Double) {
        let mSq = magSq()
        if mSq > max * max {
            self = self / sqrt(mSq) * max
        }
    }

    func magSq() -> Double {
        simd_length_squared(self)
    }

    static func random3D() -> PVector {
        PVector.random(in: -1...1)
    }

    static func fromAngle(_ angle: Double) -> PVector {
        PVector(x: cos(angle), y: sin(angle), z: 0)
    }

    func heading() -> Double {
        atan2(y, x)
    }

    static func distance(_ a: PVector, _ b: PVector) -> Double {
        simd_distance(a, b)
    }

    mutating func normalize() {
        self = simd_normalize(self)
    }

    func magnitude() -> Double {
        simd_length(self)
    }

    mutating func rotate(_ angle: Double) {
        let newHeading = heading() + angle
        let mag = magnitude()
        x = cos(newHeading) * mag
        y = sin(newHeading) * mag
    }

    mutating func setMag(_ mag: Double) {
        self = simd_normalize(self) * mag
    }
}
