//
//  SetNewGoalViewModel.swift
//  LearningJourney
//
//  Created by Monerah Almousa on 02/06/1448 AH.
//

import SwiftUI
import Combine

class SetNewGoalViewModel: ObservableObject {

    @Published var newSubject: String = ""
    @Published var selectedDuration: LearningDuration = .week

    @Published var showStartAlert = false
    @Published var shakeTrigger = 0

    private let previousResult: GoalResult
    private let service: GoalStorageService

    init(previousResult: GoalResult, service: GoalStorageService = .shared) {
        self.previousResult = previousResult
        self.service = service
    }

    private var trimmedSubject: String {
        newSubject.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    func confirmTapped() {
        if trimmedSubject.isEmpty {
            shakeTrigger += 1
        } else {
            showStartAlert = true
        }
    }

    func cancelStart() {
        showStartAlert = false
    }
    func startConfirmed() {
        service.startNewGoal(subject: trimmedSubject,
                             duration: selectedDuration,
                             previousResult: previousResult)
        showStartAlert = false
    }
}
