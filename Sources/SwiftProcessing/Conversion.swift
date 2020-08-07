//
//  Conversion.swift
//  
//
//  Created by Vasilis Akoinoglou on 7/8/20.
//

import Foundation

public func binary<T: BinaryInteger>(_ value: T, _ digits: Int? = nil) -> String {
    let output = String(value, radix: 2)
    if let d = digits {
        return String(output.prefix(d))
    }
    return output
}

public func boolean<T: BinaryInteger>(_ value: T) -> Bool {
    value > 0
}

public func boolean<T: StringProtocol>(_ value: T) -> Bool {
    value == "true"
}

public func hex<T: BinaryInteger>(_ value: T, _ digits: Int? = nil) -> String {
    let output = String(value, radix: 16, uppercase: true)
    if let d = digits {
        return String(output.prefix(d))
    }
    return output
}

public func float<T: BinaryInteger>(_ value: T) -> CGFloat? {
    CGFloat(value)
}

public func float<T: StringProtocol>(_ value: T) -> CGFloat? {
    guard let v = Double(value) else { return nil }
    return CGFloat(v)
}

public func int<T: BinaryFloatingPoint>(_ value: T) -> Int? {
    Int(value)
}

public func int<T: StringProtocol>(_ value: T) -> Int? {
    Int(value)
}

public func str(_ value: Any) -> String {
    String(describing: value)
}

public func unbinary<T: StringProtocol>(_ value: T) -> Int? {
    Int(value, radix: 2)
}

public func unhex<T: StringProtocol>(_ value: T) -> Int? {
    Int(value, radix: 16)
}
