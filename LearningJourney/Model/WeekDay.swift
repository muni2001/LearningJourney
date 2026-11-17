//
//  WeekDay.swift
//  LearningJourney
//
//  Created by Monerah Almousa on 02/06/1448 AH.
//

import Foundation

struct WeekDay: Identifiable {
    let id: Int
    let letter: String
    let number: Int
    let isToday: Bool
    var status: DayStatus = .normal
}

extension WeekDay {

    /// The 7 days of the current week (Sunday first).
    /// statusFor tells the status of each date. By default every day is empty (.normal).
    static func currentWeek(statusFor: (Date) -> DayStatus = { _ in .normal }) -> [WeekDay] {
        var calendar = Calendar(identifier: .gregorian)
        calendar.firstWeekday = 1

        guard let weekStart = calendar.dateInterval(of: .weekOfYear, for: Date())?.start else {
            return []
        }

        let letters = ["S", "M", "T", "W", "T", "F", "S"]

        return (0..<7).compactMap { offset in
            guard let date = calendar.date(byAdding: .day, value: offset, to: weekStart) else {
                return nil
            }
            let number = calendar.component(.day, from: date)
            return WeekDay(id: number,
                           letter: letters[offset],
                           number: number,
                           isToday: calendar.isDateInToday(date),
                           status: statusFor(date))
        }
    }
}
