//
//  GoalStorageService.swift
//  LearningJourney
//
//  Created by Monerah Almousa on 05/06/1448 AH.
//

import Foundation
import Combine

/// One shared place that owns the goals.
/// Every ViewModel reads from it and asks it to change things.
class GoalStorageService: ObservableObject {

    // One shared instance for the whole app
    static let shared = GoalStorageService()

    // Everyone can READ these, but only this class can CHANGE them
    @Published private(set) var currentGoal: LearningGoal?
    @Published private(set) var pastGoals: [LearningGoal] = []

    // Not private, so Previews can create their own instance when needed
    init() {}

    /// First goal (from Onboarding)
    func startGoal(subject: String, duration: LearningDuration) {
        currentGoal = LearningGoal(subject: subject, duration: duration)
    }

    /// The user changes the goal in the middle of the journey.
    /// The old goal is kept as "not completed".
    func replaceCurrentGoal(subject: String, duration: LearningDuration) {
        archiveCurrentGoal(as: .notCompleted)
        currentGoal = LearningGoal(subject: subject, duration: duration)
    }

    /// The goal period ended (completed or not met) and the user starts a new one.
    /// The old goal is kept with the real result.
    func startNewGoal(subject: String, duration: LearningDuration, previousResult: GoalResult) {
        let status: GoalStatus
        switch previousResult {
        case .completed: status = .completed
        case .notMet:    status = .notCompleted
        }

        archiveCurrentGoal(as: status)
        currentGoal = LearningGoal(subject: subject, duration: duration)
    }

    /// Moves the current goal to the past goals list with the given status.
    private func archiveCurrentGoal(as status: GoalStatus) {
        guard var oldGoal = currentGoal else { return }
        oldGoal.status = status
        pastGoals.append(oldGoal)
    }
}
