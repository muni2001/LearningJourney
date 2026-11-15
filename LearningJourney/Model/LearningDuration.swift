//
//  LearningDuration.swift
//  LearningJourney
//
//  Created by Monerah Almousa on 05/06/1448 AH.
//

import Foundation

enum LearningDuration: String, CaseIterable, Codable {
    case week  = "Week"
    case month = "Month"
    case year  = "Year"

    var freezeLimit: Int {
        switch self {
        case .week:  return 2
        case .month: return 8
        case .year:  return 96
        }
    }

    var dayCount: Int {
        switch self {
        case .week:  return 7
        case .month: return 30
        case .year:  return 365
        }
    }
}
