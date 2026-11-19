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

    private let service: GoalStorageService

    init(service: GoalStorageService = .shared) {
        self.service = service
    }

    private var trimmedSubject: String {
        learningSubject.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var isFormValid: Bool {
        !trimmedSubject.isEmpty
    }

    /// Saves the first goal. The app opens the Activity page by itself
    /// as soon as a goal exists (see LearningJourneyApp).
    func startLearningTapped() {
        guard isFormValid else { return }
        service.startGoal(subject: trimmedSubject, duration: selectedDuration)
    }
}
