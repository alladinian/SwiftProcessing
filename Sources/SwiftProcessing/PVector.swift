//
//  PVector.swift
//  
//
//  Created by Vasilis Akoinoglou on 30/7/20.
//

import Foundation
import simd
import GLKit

public typealias PVector = simd_double3

public extension PVector {

    init(_ x: CGFloat, _ y: CGFloat, _ z: CGFloat = 0) {
        self.init(Double(x), Double(y), Double(z))
    }

    /// Sets the x, y, and z component of the vector using three separate variables.
    /// - Parameters:
    ///   - x: The x component of the vector
    ///   - y: The y component of the vector
    ///   - z: The z component of the vector
    mutating func set(_ x: Double, _ y: Double, _ z: Double = 0) {
        self.x = x
        self.y = y
        self.z = z
    }

    /// Set the components of the vector from another vector
    /// - Parameter v: The vector to copy the components from.
    mutating func set(_ v: PVector) {
        self.x = v.x
        self.y = v.y
        self.z = v.z
    }

    /// Set the components of the vector from a [Double]
    ///
    /// This function assumes that the array will be of length 3.
    /// - Parameter source: The Double array
    mutating func set(_ source: [Double]) {
        precondition(source.count == 3)
        self.x = source[0]
        self.y = source[1]
        self.z = source[2]
    }

    /// Make a new 2D unit vector with a random direction.
    /// - Returns: A random 2D PVector
    static func random2D() -> PVector {
        var vector = random3D()
        vector.z = 0
        return vector
    }

    /// Make a new 3D unit vector with a random direction.
    /// - Returns: A random 3D PVector
    static func random3D() -> PVector {
        PVector.random(in: -1...1)
    }

    /// Make a new 2D unit vector from an angle
    /// - Parameter angle: The angle in radians
    /// - Returns: A new PVector
    static func fromAngle(_ angle: Double) -> PVector {
        PVector(x: cos(angle), y: sin(angle), z: 0)
    }

    /// Get a copy of the vector
    /// - Returns: A new PVector as a copy of the vector
    func copy() -> PVector {
        PVector(x, y, z)
    }

    /// Calculate the magnitude of the vector
    /// - Returns: The magnitude of the vector
    func mag() -> Double {
        simd_length(self)
    }

    /// Calculate the magnitude of the vector, squared
    /// - Returns: The magnitude of the vector, squared
    func magSq() -> Double {
        simd_length_squared(self)
    }

    mutating func add(_ v: PVector) {
        self += v
    }

    mutating func add(_ x: Double, _ y: Double, _ z: Double = 0) {
        self.x += x
        self.y += y
        self.z += z
    }

    static func add(_ v1: PVector, _ v2: PVector) -> PVector {
        v1 + v2
    }

    static func + (_ lhs: PVector, _ rhs: PVector) -> PVector {
        PVector(lhs.x + rhs.x, lhs.y + rhs.y, lhs.z + rhs.z)
    }

    mutating func sub(_ v: PVector) {
        self -= v
    }

    mutating func sub(_ x: Double, _ y: Double, _ z: Double = 0) {
        self.x -= x
        self.y -= y
        self.z -= z
    }

    static func sub(_ v1: PVector, _ v2: PVector) -> PVector {
        v1 - v2
    }

    static func - (_ lhs: PVector, _ rhs: PVector) -> PVector {
        PVector(lhs.x - rhs.x, lhs.y - rhs.y, lhs.z - rhs.z)
    }

    mutating func mult(_ n: Double) {
        self *= n
    }

    static func mult(_ v: PVector, _ n: Double) -> PVector {
        v * n
    }

    static func * (_ lhs: PVector, _ n: Double) -> PVector {
        PVector(lhs.x * n, lhs.y * n, lhs.z * n)
    }

    mutating func div(_ n: Double) {
        self /= n
    }

    static func div(_ v: PVector, _ n: Double) -> PVector {
        v / n
    }

    static func / (_ lhs: PVector, _ n: Double) -> PVector {
        PVector(lhs.x / n, lhs.y / n, lhs.z / n)
    }

    /// Calculates the Euclidean distance between two points (considering a point as a vector object).
    /// - Parameters:
    ///   - a: The first vector
    ///   - b: The second vector
    /// - Returns: The distance between the vectors
    static func dist(_ a: PVector, _ b: PVector) -> Double {
        simd_distance(a, b)
    }

    /// Calculates the Euclidean distance between two points (considering a point as a vector object).
    /// - Parameter v: The vector for which the distance will be calculated
    /// - Returns: The distance between this vector and another
    func dist(_ v: PVector) -> Double {
        simd_distance(self, v)
    }

    /// Calculates the dot product of two vectors.
    /// - Parameter v: The vector for which the dot product will be calculated
    func dot(_ v: PVector) {
        simd_dot(self, v)
    }

    /// Calculates the dot product of two vectors.
    /// - Parameters:
    ///   - a: The first vector
    ///   - b: The second vector
    /// - Returns: The dot product of the vectors
    static func dot(_ a: PVector, _ b: PVector) -> Double {
        simd_dot(a, b)
    }

    func dot(_ x: Double, _ y: Double, _ z: Double) -> Double {
        let a = PVector(x, y , z)
        return simd_dot(self, a)
    }

    func cross(_ v: PVector) -> PVector {
        simd_cross(self, v)
    }

    static func cross(_ v: PVector, _ target: PVector) -> PVector {
        simd_cross(v, target)
    }

    /// Normalize the vector to a length of 1
    mutating func normalize() {
        self = simd_normalize(self)
    }

    /// Limit the magnitude of the vector
    /// - Parameter max: The maximum limit
    mutating func limit(_ max: Double) {
        let mSq = magSq()
        if mSq > max * max {
            self = self / sqrt(mSq) * max
        }
    }

    /// Set the magnitude of the vector
    /// - Parameter mag: The magnitude to be set on the vector
    mutating func setMag(_ mag: Double) {
        self = simd_normalize(self) * mag
    }

    /// Calculate the angle of rotation for this vector
    /// - Returns: The angle of rotation in radians
    func heading() -> Double {
        atan2(y, x)
    }

    /// Rotate the vector by an angle (2D only)
    /// - Parameter angle: The angle in radians
    mutating func rotate(_ angle: Double) {
        let newHeading = heading() + angle
        let magnitude = mag()
        x = cos(newHeading) * magnitude
        y = sin(newHeading) * magnitude
    }

    func lerp(_ v: PVector, _ amount: Double) -> PVector {
        let a      = glkVector()
        let b      = PVector(v.x, v.y, v.z).glkVector()
        let result = GLKVector3Lerp(a, b, Float(amount))
        return PVector.fromGlkVector(result)
    }

    static func lerp(_ v1: PVector, _ v2: PVector, _ amount: Double) -> PVector {
        v1.lerp(v2, amount)
    }

    func lerp(_ x: Double, _ y: Double, _ z: Double, _ amount: Double) -> PVector {
        lerp(PVector(x, y, z), amount)
    }

    static func angleBetween(_ v1: PVector, _ v2: PVector) -> Double {
        let dotp = dot(v1, v2)
        let m1 = v1.mag()
        let m2 = v2.mag()
        return cos(dotp / (m1 * m2))
    }

    func array() -> [Double] {
        [x, y, z]
    }

    /// A new zero length vector
    /// - Returns: A new zero length vector
    static func zero() -> PVector {
        PVector(0.0, 0.0, 0.0)
    }

    private func glkVector() -> GLKVector3 {
        GLKVector3(v: (Float(x), Float(y), Float(z)))
    }

    private static func fromGlkVector(_ v: GLKVector3) -> PVector {
        PVector(Double(v.x), Double(v.y), Double(v.z))
    }

}

