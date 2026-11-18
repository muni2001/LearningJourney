//
//  AppClock.swift
//  LearningJourney
//
//  Created by Monerah Almousa on 07/06/1448 AH.
//

import Foundation

/// The app's "now".
/// Everything that depends on the current time reads it from here,
/// so while testing we can move time forward (the real clock is never changed).
enum AppClock {

    /// Seconds added to the real time. Only used for testing.
    nonisolated(unsafe) static var offset: TimeInterval = 0

    static var now: Date {
        Date().addingTimeInterval(offset)
    }

    /// The calendar of the app: Gregorian, the week starts on Sunday.
    static let calendar: Calendar = {
        var calendar = Calendar(identifier: .gregorian)
        calendar.firstWeekday = 1
        return calendar
    }()
}
