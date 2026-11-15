//
//  CurrentDayViewModel.swift
//  LearningJourney
//
//  Created by Monerah Almousa on 30/05/1448 AH.
//

import SwiftUI
import Combine


class CurrentDayViewModel: ObservableObject {

    // The goal now comes from the shared service (it can be nil, e.g. in a Preview)
    @Published private(set) var currentGoal: LearningGoal?

    // State
    @Published var streakCount: Int = 0
    @Published var freezeCount: Int = 0
    @Published var dayStatus: DayStatus = .normal

    // Navigation trigger for the pencil button
    @Published var showChangeGoal = false

    private let service: GoalStorageService
    private var cancellables = Set<AnyCancellable>()

    init(service: GoalStorageService = .shared) {
        self.service = service
        self.currentGoal = service.currentGoal

        // Listen to the service: when the goal changes, start fresh
        service.$currentGoal
            .dropFirst()
            .sink { [weak self] newGoal in
                self?.goalChanged(to: newGoal)
            }
            .store(in: &cancellables)
    }

    private func goalChanged(to newGoal: LearningGoal?) {
        currentGoal = newGoal
        streakCount = 0
        freezeCount = 0
        dayStatus = .normal
    }



    var duration: LearningDuration { currentGoal?.duration ?? .week }

    var freezeLimit: Int { duration.freezeLimit }

    var allFreezesUsed: Bool { freezeCount >= freezeLimit }


    // Interaction: can the button be pressed at all?
    var isFreezeDisabled: Bool { allFreezesUsed && dayStatus != .frozen }

    // Appearance: should the Freeze button look gray?
    var isFreezeDimmed: Bool { dayStatus == .frozen || isFreezeDisabled }

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

    var weekDays: [WeekDay] { WeekDay.currentWeek() }



    func logAsLearnedTapped() {
        switch dayStatus {
        case .normal:
            applyLearned()
        case .learned:
            undoLearned()
        case .frozen:
            undoFreeze()
            applyLearned()
        }
    }

    func freezeTapped() {
        guard !isFreezeDisabled else { return }

        switch dayStatus {
        case .normal:
            applyFreeze()
        case .frozen:
            undoFreeze()
        case .learned:
            undoLearned()
            applyFreeze()
        }
    }

    func calendarTapped() {
        print("Calendar tapped - page will be added later")
    }

    func setGoalTapped() {
        showChangeGoal = true
    }

    private func applyLearned() {
        streakCount += 1
        dayStatus = .learned
    }

    private func undoLearned() {
        streakCount = max(streakCount - 1, 0)
        dayStatus = .normal
    }

    private func applyFreeze() {
        freezeCount += 1
        dayStatus = .frozen
    }

    private func undoFreeze() {
        freezeCount = max(freezeCount - 1, 0)
        dayStatus = .normal
    }
}
