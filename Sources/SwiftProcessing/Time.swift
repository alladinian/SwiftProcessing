//
//  Time.swift
//  
//
//  Created by Vasilis Akoinoglou on 3/8/20.
//

import Foundation

/// The day() function returns the current day as a value from 1 - 31.
/// - Returns: The current day
public func day() -> Int {
    Calendar.current.component(.day, from: Date())
}

/// The hour() function returns the current hour as a value from 0 - 23
/// - Returns: The current hour
public func hour() -> Int {
    Calendar.current.component(.hour, from: Date())
}

/// The month() function returns the current month as a value from 1 - 12
/// - Returns: The current month
public func month() -> Int {
    Calendar.current.component(.month, from: Date())
}

/// The year() function returns the current year as an integer (2003, 2004, 2005, etc).
/// - Returns: The current year
public func year() -> Int {
    Calendar.current.component(.year, from: Date())
}

/// The minute() function returns the current minute as a value from 0 - 59.
/// - Returns: The current minute
public func minute() -> Int {
    Calendar.current.component(.minute, from: Date())
}

/// The second() function returns the current second as a value from 0 - 59.
/// - Returns: The current second
public func second() -> Int {
    Calendar.current.component(.second, from: Date())
}

private let launchTime = DispatchTime.now()
/// Returns the number of milliseconds (thousandths of a second) since starting the program. This information is often used for timing events and animation sequences.
/// - Returns: The number of milliseconds since starting the program
public func millis() -> UInt64 {
    let delta = DispatchTime.now().uptimeNanoseconds - launchTime.uptimeNanoseconds
    return delta / UInt64(1e6)
}
