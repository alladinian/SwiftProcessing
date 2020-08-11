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

    init(_ x: Int, _ y: Int, _ z: Int = 0) {
        self.init(Double(x), Double(y), Double(z))
    }

    init(_ x: CGFloat, _ y: CGFloat, _ z: CGFloat = 0) {
        self.init(Double(x), Double(y), Double(z))
    }

    init(_ x: Double, _ y: Double) {
        self.init(x, y, 0)
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
        self.set(v.x, v.y, v.z)
    }

    /// Set the components of the vector from a [Double]
    ///
    /// This function assumes that the array will be of length 3.
    /// - Parameter source: The Double array
    mutating func set(_ source: [Double]) {
        self.set(PVector(source))
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
    ///
    /// In Swift PVector is a value type, so assignment always produces a copy.
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

    mutating func mult(_ n: Double) {
        self *= n
    }

    static func mult(_ v: PVector, _ n: Double) -> PVector {
        v * n
    }

    mutating func div(_ n: Double) {
        self /= n
    }

    static func div(_ v: PVector, _ n: Double) -> PVector {
        v / n
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

    /**
     Calculates linear interpolation from one vector to another vector. (Just like regular lerp(), but for vectors.)

     Note that there is one static version of this method, and two non-static versions. The static version, lerp(v1, v2, amt) is given the two vectors to interpolate and returns a new PVector object. The static version is used by referencing the PVector class directly. (See the middle example above.) The non-static versions, lerp(v, amt) and lerp(x, y, z, amt), do not create a new PVector, but transform the values of the PVector on which they are called. These non-static versions perform the same operation, but the former takes another vector as input, while the latter takes three float values. (See the top and bottom examples above, respectively.)
     - Parameters:
       - v: The vector to lerp to
       - amount: The amount of interpolation; some value between 0.0 (old vector) and 1.0 (new vector). 0.1 is very near the old vector; 0.5 is halfway in between.
     - Returns: A PVector as a result of the interpolation
     */
    func lerp(_ v: PVector, _ amount: Double) -> PVector {
        let a      = GLKVector3(self)
        let b      = GLKVector3(v)
        let result = GLKVector3Lerp(a, b, Float(amount))
        return PVector(result)
    }

    static func lerp(_ v1: PVector, _ v2: PVector, _ amount: Double) -> PVector {
        v1.lerp(v2, amount)
    }

    func lerp(_ x: Double, _ y: Double, _ z: Double, _ amount: Double) -> PVector {
        lerp(PVector(x, y, z), amount)
    }

    /// Calculates and returns the angle (in radians) between two vectors
    /// - Parameters:
    ///   - v1: the x, y, and z components of a PVector
    ///   - v2: the x, y, and z components of a PVector
    /// - Returns: The angle (in radians) between two vectors
    static func angleBetween(_ v1: PVector, _ v2: PVector) -> Double {
        let dotp = dot(v1, v2)
        let m1 = v1.mag()
        let m2 = v2.mag()
        return cos(dotp / (m1 * m2))
    }

    /// Return a representation of this vector as a Double array. This is only for temporary use. If used in any other fashion, the contents should be copied by using the copy() method to copy into your own array.
    /// - Returns: A representation of this vector as a Double array
    func array() -> [Double] {
        [x, y, z]
    }

    /// A new zero length vector
    /// - Returns: A new zero length vector
    static func zero() -> PVector {
        PVector(0.0, 0.0, 0.0)
    }

}

extension PVector {
    init(_ v: GLKVector3) {
        self.init(Double(v.x), Double(v.y), Double(v.z))
    }
}

extension GLKVector3 {
    init(_ v: PVector) {
        self.init(v: (Float(v.x), Float(v.y), Float(v.z)))
    }
}

