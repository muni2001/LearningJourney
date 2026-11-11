//
//  CurrentDayViewModel.swift
//  LearningJourney
//
//  Created by Monerah Almousa on 30/05/1448 AH.
//

import SwiftUI
import Combine


enum DayStatus {
    case normal
    case learned
    case frozen
}

struct WeekDay: Identifiable {
    let id: Int
    let letter: String
    let number: Int
    let isToday: Bool
}


class CurrentDayViewModel: ObservableObject {

    let learningSubject: String
    let duration: String

    // State
    @Published var streakCount: Int = 0
    @Published var freezeCount: Int = 0
    @Published var dayStatus: DayStatus = .normal

    init(learningSubject: String, duration: String) {
        self.learningSubject = learningSubject
        self.duration = duration
    }


    var freezeLimit: Int {
        switch duration {
        case "Week":  return 2
        case "Month": return 8
        case "Year":  return 96
        default:      return 2
        }
    }

    var allFreezesUsed: Bool { freezeCount >= freezeLimit }


    var isLogDisabled: Bool { dayStatus != .normal }
    var isFreezeDisabled: Bool { dayStatus != .normal || allFreezesUsed }

    var logButtonTitle: String {
        dayStatus == .learned ? "Logged as Learned" : "Log as Learned"
    }

    var freezeButtonTitle: String {
        (dayStatus == .frozen || allFreezesUsed) ? "Freezed for a day" : "Freeze for a day"
    }

    var freezeUsageText: String {
        "\(freezeCount) out of \(freezeLimit) Freezes used"
    }


    func daysText(_ count: Int) -> String {
        count == 1 ? "\(count) day" : "\(count) days"
    }

    var todayText: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = "EEEE, d MMMM"
        return formatter.string(from: Date())
    }


    var weekDays: [WeekDay] {
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
                           isToday: calendar.isDateInToday(date))
        }
    }


    func logAsLearnedTapped() {
        guard !isLogDisabled else { return }
        streakCount += 1
        dayStatus = .learned
    }

    func freezeTapped() {
        guard !isFreezeDisabled else { return }
        freezeCount += 1
        dayStatus = .frozen
    }

    func calendarTapped() {
        print("Calendar tapped - page will be added later")
    }

    func setGoalTapped() {
        print("Set a goal tapped - page will be added later")
    }
}
