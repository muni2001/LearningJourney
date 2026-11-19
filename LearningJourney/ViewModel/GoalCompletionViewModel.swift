//
//  GoalCompletionViewModel.swift
//  LearningJourney
//
//  Created by Monerah Almousa on 30/05/1448 AH.
//

import SwiftUI
import Combine

class GoalCompletionViewModel: ObservableObject {

    // Data coming from the previous screen
    let result: GoalResult
    let weekDays: [WeekDay]
    let streakCount: Int
    let freezeCount: Int

    // Navigation trigger for the "Set a goal" buttons
    @Published var showSetNewGoal = false
    @Published var showCalendar = false

    private let dayTitleFormatter = DateFormatter.english(DatePattern.dayTitle)

    init(result: GoalResult,
         weekDays: [WeekDay] = WeekDay.currentWeek(),
         streakCount: Int = 0,
         freezeCount: Int = 0) {
        self.result = result
        self.weekDays = weekDays
        self.streakCount = streakCount
        self.freezeCount = freezeCount
    }


    // MARK: - Texts and icon (decided by the result)

    var iconName: String {
        switch result {
        case .completed: return "hands.and.sparkles.fill"
        case .notMet:    return "xmark.seal.fill"
        }
    }

    var title: String {
        switch result {
        case .completed: return "Will done!"
        case .notMet:    return "You didn't reach your goal this time."
        }
    }

    var subtitle: String {
        switch result {
        case .completed: return "Ready for your next goal?"
        case .notMet:    return "Want to set another goal?"
        }
    }

    var todayText: String {
        dayTitleFormatter.string(from: AppClock.now)
    }


    // MARK: - Actions

    func calendarTapped() {
        showCalendar = true
    }

    func setGoalTapped() {
        showSetNewGoal = true
    }
}
