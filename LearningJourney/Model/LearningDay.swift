//
//  LearningDay.swift
//  LearningJourney
//
//  Created by Monerah Almousa on 06/06/1448 AH.
//

import Foundation

/// A record of one day in the user's journey.
/// Days with no record simply do not exist (they are "no activity").
struct LearningDay: Identifiable, Codable {
    let date: Date          // always the start of that day
    var status: DayStatus
    var goalID: UUID?       // which goal the user was following that day
    var loggedAt: Date      // the exact moment the user logged it (used by the 32 hours rule)
    var id: Date { date }
}
