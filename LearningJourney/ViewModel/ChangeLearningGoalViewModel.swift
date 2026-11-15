//
//  EditGoalViewModel.swift
//  LearningJourney
//
//  Created by Monerah Almousa on 30/05/1448 AH.
//

import SwiftUI
import Combine

class ChangeLearningGoalViewModel: ObservableObject {

    // What the user types / picks
    @Published var newSubject: String = ""
    @Published var selectedDuration: LearningDuration = .week

    // UI triggers
    @Published var showUpdateAlert = false
    @Published var shakeTrigger = 0      // every +1 makes the field shake once

    private let service: GoalStorageService

    init(service: GoalStorageService = .shared) {
        self.service = service
    }

    private var trimmedSubject: String {
        newSubject.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    /// Checkmark button
    func confirmTapped() {
        if trimmedSubject.isEmpty {
            shakeTrigger += 1
        } else {
            showUpdateAlert = true
        }
    }

    func cancelUpdate() {
        showUpdateAlert = false
    }

    func updateConfirmed() {
        service.replaceCurrentGoal(subject: trimmedSubject, duration: selectedDuration)
        showUpdateAlert = false
    }
}
