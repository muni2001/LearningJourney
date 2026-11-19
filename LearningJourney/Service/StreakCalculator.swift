//
//  StreakCalculator.swift
//  LearningJourney
//
//  Created by Monerah Almousa on 09/06/1448 AH.
//

import Foundation

/// The streak rule, kept apart from the ViewModel so it is easy to read and test.
///
/// The streak is the number of learned days since the last break in activity.
/// A break is more than `limitInHours` without logging a day or freezing one.
/// A frozen day keeps the streak alive, but it does not add to it.
enum StreakCalculator {

    static let limitInHours: Double = 32

    /// - Parameter records: every day the user logged or froze in ONE goal.
    static func streak(from records: [LearningDay], now: Date) -> Int {
        let ordered = records.sorted { $0.loggedAt < $1.loggedAt }

        var streak = 0
        var previousActivity: Date?

        for record in ordered {
            // Too long since the last activity: the streak starts over
            if let previous = previousActivity,
               hours(from: previous, to: record.loggedAt) > limitInHours {
                streak = 0
            }
            if record.status == .learned {
                streak += 1
            }
            previousActivity = record.loggedAt
        }

        // The last activity is too old: the streak is already over
        if let last = previousActivity, hours(from: last, to: now) > limitInHours {
            return 0
        }
        return streak
    }

    private static func hours(from start: Date, to end: Date) -> Double {
        end.timeIntervalSince(start) / 3600
    }
}
