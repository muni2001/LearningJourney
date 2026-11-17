//
//  CalendarMonth.swift
//  LearningJourney
//
//  Created by Monerah Almousa on 06/06/1448 AH.
//

import Foundation

/// One square in a month grid. Empty squares (before day 1) have no date.
struct CalendarCell: Identifiable {
    let id: Int
    let date: Date?
    let number: Int?
    let status: DayStatus
    let isToday: Bool
}

/// One month shown in the calendar page.
struct CalendarMonth: Identifiable {
    let id: Date            // first day of the month
    let title: String       // "March 2026"
    let cells: [CalendarCell]
}
