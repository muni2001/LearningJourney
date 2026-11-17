//
//  DayStatus.swift
//  LearningJourney
//
//  Created by Monerah Almousa on 02/06/1448 AH.
//

import Foundation

enum DayStatus {
    case normal
    case learned
    case frozen

    /// Text shown to the user
    var displayName: String {
        switch self {
        case .normal:  return "No activity"
        case .learned: return "Learned"
        case .frozen:  return "Freezed"
        }
    }
}
