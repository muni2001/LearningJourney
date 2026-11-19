//
//  EditGoalView.swift
//  LearningJourney
//
//  Created by Monerah Almousa on 30/05/1448 AH.
//

import SwiftUI

struct ChangeLearningGoalView: View {
    @StateObject private var viewModel = ChangeLearningGoalViewModel()
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(alignment: .leading, spacing: 24) {
                GoalNavBar(title: "Learning Goal",
                           onBack: { dismiss() },
                           onConfirm: { viewModel.confirmTapped() })

                GoalTextField(text: $viewModel.newSubject,
                              placeholder: "Enter your new goal",
                              shakeTrigger: viewModel.shakeTrigger)

                DurationPickerView(selection: $viewModel.selectedDuration,
                                   isAllowed: viewModel.isDurationAllowed)

                Spacer()
            }
            .padding(.horizontal, 24)

            if viewModel.showUpdateAlert {
                GlassConfirmPopup(title: viewModel.alertTitle,
                                  message: viewModel.alertMessage,
                                  cancelTitle: "Dismiss",
                                  confirmTitle: "Update",
                                  onCancel: { viewModel.cancelUpdate() },
                                  onConfirm: { viewModel.updateConfirmed() })
            }
        }
        .animation(.easeInOut(duration: 0.2), value: viewModel.showUpdateAlert)
        .toolbar(.hidden, for: .navigationBar)
        .onChange(of: viewModel.newSubject) { _, _ in
            viewModel.fixDurationIfNeeded()
        }
        .onChange(of: viewModel.shouldDismiss) { _, shouldDismiss in
            if shouldDismiss { dismiss() }
        }
    }
}

#Preview {
    NavigationStack {
        ChangeLearningGoalView()
    }
    .preferredColorScheme(.dark)
}

