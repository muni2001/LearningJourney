//
//  OnboardingViewModel.swift
//  LearningJourney
//
//  Created by Monerah Almousa on 30/05/1448 AH.
//

import SwiftUI
import Combine

class OnboardingViewModel: ObservableObject {
    @Published var learningSubject: String = ""
    @Published var selectedDuration: LearningDuration = .week
    @Published var navigateToActivity = false

    private let service: GoalStorageService

    init(service: GoalStorageService = .shared) {
        self.service = service
    }

    var isFormValid: Bool {
        return !learningSubject.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    func startLearningTapped() {
        guard isFormValid else { return }

        service.startGoal(
            subject: learningSubject.trimmingCharacters(in: .whitespacesAndNewlines),
            duration: selectedDuration
        )
        navigateToActivity = true
    }
}
