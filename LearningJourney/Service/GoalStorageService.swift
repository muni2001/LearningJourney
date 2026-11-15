//
//  GoalStorageService.swift
//  LearningJourney
//
//  Created by Monerah Almousa on 05/06/1448 AH.
//

import Foundation
import Combine

class GoalStorageService: ObservableObject {

    static let shared = GoalStorageService()

    @Published private(set) var currentGoal: LearningGoal?
    @Published private(set) var pastGoals: [LearningGoal] = []

    init() {}

    func startGoal(subject: String, duration: LearningDuration) {
        currentGoal = LearningGoal(subject: subject, duration: duration)
    }

    func replaceCurrentGoal(subject: String, duration: LearningDuration) {
        if var oldGoal = currentGoal {
            oldGoal.status = .notCompleted
            pastGoals.append(oldGoal)
            print(pastGoals)
        }
        currentGoal = LearningGoal(subject: subject, duration: duration)
    }
}
