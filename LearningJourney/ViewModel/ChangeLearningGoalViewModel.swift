//
//  ChangeLearningGoalViewModel.swift
//  LearningJourney
//
//  Created by Monerah Almousa on 30/05/1448 AH.
//

import SwiftUI
import Combine

class ChangeLearningGoalViewModel: ObservableObject {

    enum UpdateAlertKind { case newGoal, durationOnly }
    private enum Change { case none, durationOnly, newGoal }

    @Published var newSubject: String = ""
    @Published var selectedDuration: LearningDuration = .week

    @Published var showUpdateAlert = false
    @Published var shakeTrigger = 0
    @Published var shouldDismiss = false   // the view closes itself when this becomes true
    @Published private(set) var alertKind: UpdateAlertKind = .newGoal

    private let service: GoalStorageService

    init(service: GoalStorageService = .shared) {
        self.service = service

        // Start with the current goal already filled in
        if let goal = service.currentGoal {
            newSubject = goal.subject
            selectedDuration = goal.duration
        }
    }

    private var trimmedSubject: String {
        newSubject.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    /// What the user typed, ready to compare with the current goal
    private var editedDraft: GoalDraft {
        GoalDraft(subject: newSubject, duration: selectedDuration)
    }

    /// Same subject as the current goal? (ignores spaces and letter case)
    private var isSameSubject: Bool {
        editedDraft.subject == service.currentGoal?.draft.subject
    }

    private var change: Change {
        guard let current = service.currentGoal else { return .newGoal }

        if editedDraft == current.draft { return .none }
        return isSameSubject ? .durationOnly : .newGoal
    }


    // MARK: - Duration rules

    /// With the same subject, the duration can only stay or grow. A new subject can use any duration.
    func isDurationAllowed(_ duration: LearningDuration) -> Bool {
        guard isSameSubject, let current = service.currentGoal else { return true }
        return duration.dayCount >= current.duration.dayCount
    }

    /// Called when the subject text changes: if the picked duration became
    /// shorter than the current one, move it back up.
    func fixDurationIfNeeded() {
        guard let current = service.currentGoal else { return }
        if !isDurationAllowed(selectedDuration) {
            selectedDuration = current.duration
        }
    }


    // MARK: - Alert texts

    var alertTitle: String {
        alertKind == .newGoal ? "Update goal" : "Change duration?"
    }

    var alertMessage: String {
        alertKind == .newGoal
            ? "If you update now, your streak will start over."
            : "Your streak and freezes will stay the same, and you can continue your learning journey."
    }


    // MARK: - Actions

    /// Checkmark button
    func confirmTapped() {
        guard !trimmedSubject.isEmpty else {
            shakeTrigger += 1
            return
        }

        switch change {
        case .none:
            shouldDismiss = true
        case .durationOnly:
            alertKind = .durationOnly
            showUpdateAlert = true
        case .newGoal:
            alertKind = .newGoal
            showUpdateAlert = true
        }
    }

    func cancelUpdate() {
        showUpdateAlert = false
        // Dismissing a duration change leaves the page: nothing was changed
        if alertKind == .durationOnly {
            shouldDismiss = true
        }
    }

    func updateConfirmed() {
        switch alertKind {
        case .durationOnly:
            // Same goal, longer duration: streak and freezes stay
            service.updateCurrentGoal(subject: trimmedSubject, duration: selectedDuration)
        case .newGoal:
            service.replaceCurrentGoal(subject: trimmedSubject, duration: selectedDuration)
        }
        showUpdateAlert = false
        shouldDismiss = true
    }
}

