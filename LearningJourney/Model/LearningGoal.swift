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
    var startDate: Date = Date()
    var status: GoalStatus = .active

    var endDate: Date? {
        Calendar.current.date(byAdding: .day, value: duration.dayCount, to: startDate)
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
