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
    @Published var selectedDuration: String = "Week"
    @Published var navigateToActivity = false

    let durations = ["Week", "Month", "Year"]

    var isFormValid: Bool {
        return !learningSubject.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    func startLearningTapped() {
        guard isFormValid else { return }
        navigateToActivity = true
    }
}
