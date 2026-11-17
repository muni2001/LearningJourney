//
//  GoalStorageService.swift
//  LearningJourney
//
//  Created by Monerah Almousa on 05/06/1448 AH.
//

import Foundation
import Combine

/// One shared place that owns the goals and the days history.
/// Every ViewModel reads from it and asks it to change things.
class GoalStorageService: ObservableObject {

    // One shared instance for the whole app
    static let shared = GoalStorageService()

    // Everyone can READ these, but only this class can CHANGE them
    @Published private(set) var currentGoal: LearningGoal?
    @Published private(set) var pastGoals: [LearningGoal] = []

    /// History of the days: key = start of the day.
    /// A day that is not in the dictionary means "no activity".
    @Published private(set) var days: [Date: LearningDay] = [:]

    // Not private, so Previews can create their own instance when needed
    init() {}


    // MARK: - Goals

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

    /// Finds a goal (current or past) by its id. Optional: it may not exist.
    func goal(withID id: UUID) -> LearningGoal? {
        if let current = currentGoal, current.id == id {
            return current
        }
        return pastGoals.first { $0.id == id }
    }

    /// The first day of the journey (oldest goal start or oldest recorded day).
    var journeyStartDate: Date? {
        let goals = [currentGoal].compactMap { $0 } + pastGoals
        let goalDates = goals.map { $0.startDate }
        return (goalDates + Array(days.keys)).min()
    }


    // MARK: - Days history

    /// Saves the status of a day. Setting .normal removes the record (undo).
    func setStatus(_ status: DayStatus, on date: Date = Date()) {
        let key = Self.startOfDay(date)

        if status == .normal {
            days[key] = nil
        } else {
            days[key] = LearningDay(date: key, status: status, goalID: currentGoal?.id)
        }
    }

    /// The record of a day, or nil if the user did nothing that day.
    func day(on date: Date) -> LearningDay? {
        days[Self.startOfDay(date)]
    }
    /// Same goal, just edited (e.g. longer duration). Keeps the id, start date and history.
    func updateCurrentGoal(subject: String, duration: LearningDuration) {
        guard var goal = currentGoal else { return }
        goal.subject = subject
        goal.duration = duration
        currentGoal = goal
    }


    // MARK: - Private helpers

    /// Moves the current goal to the past goals list with the given status.
    private func archiveCurrentGoal(as status: GoalStatus) {
        guard var oldGoal = currentGoal else { return }
        oldGoal.status = status
        pastGoals.append(oldGoal)
    }

    private static func startOfDay(_ date: Date) -> Date {
        Calendar(identifier: .gregorian).startOfDay(for: date)
    }
}

