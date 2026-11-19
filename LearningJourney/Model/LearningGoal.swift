//
//  LearningGoal.swift
//  LearningJourney
//
//  Created by Monerah Almousa on 05/06/1448 AH.
//

import Foundation

struct LearningGoal: Identifiable, Codable {
    var id = UUID()
    var subject: String
    var duration: LearningDuration
    var startDate: Date = AppClock.now
    var status: GoalStatus = .active

    /// The moment the goal period is over: 12AM after its last day.
    /// A week goal that starts today ends at 12AM of the same weekday, next week.
    var endDate: Date? {
        let firstDay = AppClock.calendar.startOfDay(for: startDate)
        return AppClock.calendar.date(byAdding: .day, value: duration.dayCount, to: firstDay)
    }
}

/// A comparable "snapshot" of a goal: the subject is normalized so
/// "English", " english " and "ENGLISH" count as the same goal.
struct GoalDraft: Equatable {
    let subject: String
    let duration: LearningDuration

    init(subject: String, duration: LearningDuration) {
        self.subject = subject
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()
        self.duration = duration
    }
}

extension LearningGoal {
    var draft: GoalDraft { GoalDraft(subject: subject, duration: duration) }
}
