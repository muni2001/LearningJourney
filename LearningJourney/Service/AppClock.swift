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

    #if DEBUG
    /// Seconds added to the real time. Debug builds only.
    nonisolated(unsafe) static var offset: TimeInterval = 0

    static var now: Date {
        Date().addingTimeInterval(offset)
    }
    #else
    static var now: Date { Date() }
    #endif

    /// The calendar of the app: Gregorian, the week starts on Sunday.
    static let calendar: Calendar = {
        var calendar = Calendar(identifier: .gregorian)
        calendar.firstWeekday = 1
        return calendar
    }()
}

/// The date texts used by the screens, so every page writes dates the same way.
enum DatePattern {
    static let dayTitle = "EEEE, d MMMM"    // "Wednesday, 18 November"
    static let monthTitle = "MMMM yyyy"     // "November 2026"
}

extension DateFormatter {
    /// An English formatter that follows the app's calendar.
    static func english(_ pattern: String) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.calendar = AppClock.calendar
        formatter.dateFormat = pattern
        return formatter
    }
}
