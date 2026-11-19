//
//  CalendarViewModel.swift
//  LearningJourney
//
//  Created by Monerah Almousa on 30/05/1448 AH.
//

import SwiftUI
import Combine

class CalendarViewModel: ObservableObject {

    // The popup content (nil = popup hidden)
    @Published var selectedInfo: DayInfo?

    private let service: GoalStorageService

    // Same calendar as the rest of the app (Gregorian, week starts on Sunday)
    private let calendar = AppClock.calendar
    private let monthTitleFormatter = DateFormatter.english(DatePattern.monthTitle)
    private let dayTitleFormatter = DateFormatter.english(DatePattern.dayTitle)

    init(service: GoalStorageService = .shared) {
        self.service = service
    }


    // MARK: - Months

    /// All 12 months of every year of the journey (from the start year until the current year).
    var months: [CalendarMonth] {
        let today = AppClock.now
        let currentYear = calendar.component(.year, from: today)
        let startYear = calendar.component(.year, from: service.journeyStartDate ?? today)

        var result: [CalendarMonth] = []

        for year in min(startYear, currentYear)...currentYear {
            for month in 1...12 {
                var components = DateComponents()
                components.year = year
                components.month = month
                components.day = 1

                if let start = calendar.date(from: components),
                   let calendarMonth = makeMonth(startingAt: start) {
                    result.append(calendarMonth)
                }
            }
        }
        return result
    }

    /// Used to scroll to the current month when the page opens.
    var currentMonthID: Date? {
        monthStart(of: AppClock.now)
    }

    private func monthStart(of date: Date) -> Date? {
        calendar.dateInterval(of: .month, for: date)?.start
    }

    private func makeMonth(startingAt start: Date) -> CalendarMonth? {
        // Optional: the calendar may fail to give the number of days
        guard let dayRange = calendar.range(of: .day, in: .month, for: start) else { return nil }

        // Sunday = 1, so the number of empty squares before day 1 is weekday - 1
        let leadingBlanks = calendar.component(.weekday, from: start) - 1

        var cells: [CalendarCell] = []

        for index in 0..<leadingBlanks {
            cells.append(CalendarCell(id: index, date: nil, number: nil,
                                      status: .normal, isToday: false))
        }

        for day in dayRange {
            guard let date = calendar.date(byAdding: .day, value: day - 1, to: start) else { continue }

            cells.append(CalendarCell(id: leadingBlanks + day - 1,
                                      date: date,
                                      number: day,
                                      status: service.day(on: date)?.status ?? .normal,
                                      isToday: calendar.isDate(date, inSameDayAs: AppClock.now)))
        }

        return CalendarMonth(id: start, title: monthTitleFormatter.string(from: start), cells: cells)
    }


    // MARK: - Popup

    func dayTapped(_ cell: CalendarCell) {
        // Days with no record (no activity) do nothing
        guard let date = cell.date, let record = service.day(on: date) else { return }

        var lines: [String] = []

        if let goalID = record.goalID, let goal = service.goal(withID: goalID) {
            lines.append("Goal: \(goal.subject)")
            lines.append("Duration: \(goal.duration.rawValue)")
        }
        lines.append("Status: \(record.status.displayName)")

        selectedInfo = DayInfo(title: dayTitleFormatter.string(from: date), lines: lines)
    }

    func closePopup() {
        selectedInfo = nil
    }
}
