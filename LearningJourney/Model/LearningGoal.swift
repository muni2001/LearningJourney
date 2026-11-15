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
