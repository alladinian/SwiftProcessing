//
//  Math.swift
//  
//
//  Created by Vasilis Akoinoglou on 31/7/20.
//

import Foundation
import simd
import GameKit

//MARK: - Calculation

// Already provided by the system
// abs()
// ceil()
// exp()
// floor()
// log()
// max()
// min()
// pow()
// round()
// sqrt()

public func constrain<T: Comparable>(_ amt: T, _ low: T, _ high: T) -> T {
    min(max(amt, low), high)
}

public func dist<T: FloatingPoint>(_ x1: T, _ y1: T, _ x2: T, _ y2: T) -> T {
    sqrt(sq(x2 - x1) + sq(y2 - y1))
}


public func lerp<T: FloatingPoint>(_ start: T, _ stop: T, _ amt: T) -> T {
    start + (stop - start) * constrain(amt, 0, 1)
}

public func mag(_ a: CGFloat, _ b: CGFloat, _ c: CGFloat) -> CGFloat {
    CGFloat(PVector(a, b, c).mag())
}

public func map(_ value: CGFloat, _ minRange: CGFloat, _ maxRange: CGFloat, _ minDomain: CGFloat, _ maxDomain: CGFloat) -> CGFloat {
    minDomain + (maxDomain - minDomain) * (value - minRange) / (maxRange - minRange)
}


public func norm(_ value: CGFloat, _ start: CGFloat, _ stop: CGFloat) -> CGFloat {
    map(value, start, stop, 0, 1)
}

public func sq<T: Numeric>(_ n: T) -> T {
    n * n
}


//MARK: - Trigonometry

// Already provided by the system

// acos()
// asin()
// atan()
// atan2()
// cos()
// sin()
// tan()


public func degrees<T: FloatingPoint>(_ radians: T) -> T {
    radians * 180 / .pi
}

public func radians<T: FloatingPoint>(_ degrees: T) -> T {
    degrees * .pi / 180
}

//MARK: - Constants

public let HALF_PI    = CGFloat.pi / 2.0
public let PI         = CGFloat.pi
public let TWO_PI     = CGFloat.pi * 2.0
public let TAU        = CGFloat.pi * 2.0
public let QUARTER_PI = CGFloat.pi / 4.0

//MARK: - Random

public func random(_ n: CGFloat) -> CGFloat {
    let r: Int = random(n)
    return CGFloat(r)
}

public func random(_ n: CGFloat) -> Int {
    Int(arc4random_uniform(UInt32(n)))
}

public func random(_ n: Int) -> Int {
    Int(arc4random_uniform(UInt32(n)))
}

public func random(_ min: CGFloat, _ max: CGFloat) -> CGFloat {
    let r: Int = random(Int(min), Int(max))
    return CGFloat(r)
}

public func random(_ min: Int, _ max: Int) -> Int {
    Int(arc4random_uniform(UInt32(max - min))) + min
}

/*
public func random(_ low: CGFloat, _ high: CGFloat) -> CGFloat {
    CGFloat(GKRandomDistribution(randomSource: randomSource, lowestValue: Int(low), highestValue: Int(high)).nextUniform())
}

public func random(_ n: CGFloat) -> Int {
    Int(random(0, n))
}

public func random(_ n: CGFloat) -> CGFloat {
    random(0, n)
}

public func random(_ n: Int) -> Int {
    Int(random(0, CGFloat(n)))
}

private var randomSeed: UInt64?
private let randomSource: GKRandomSource = {
    guard let seed = randomSeed else {
        return GKARC4RandomSource()
    }
    return GKMersenneTwisterRandomSource(seed: seed)
}()
*/

private let gaussianRandomSource = GKRandomSource()
private let gaussianDistribution = GKGaussianDistribution(randomSource: gaussianRandomSource, mean: 0, deviation: 1)

public func randomGaussian() -> CGFloat {
    CGFloat(gaussianDistribution.nextUniform())
}

private let perlinNoiseSource = GKPerlinNoiseSource()

public func noise(_ x: CGFloat, _ y: CGFloat = 0) -> CGFloat {
    CGFloat(noise(Float(x), Float(y)))
}

public func noise(_ x: Float, _ y: Float = 0) -> Float {
    let position = simd_float2(x, y)
    return GKNoise(perlinNoiseSource).value(atPosition: position)
}
