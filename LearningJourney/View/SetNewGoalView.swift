//
//  SetNewGoalView.swift
//  LearningJourney
//
//  Created by Monerah Almousa on 02/06/1448 AH.
//

import SwiftUI

struct SetNewGoalView: View {
    @StateObject private var viewModel: SetNewGoalViewModel
    @Environment(\.dismiss) private var dismiss

    init(previousResult: GoalResult) {
        _viewModel = StateObject(
            wrappedValue: SetNewGoalViewModel(previousResult: previousResult)
        )
    }

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

                DurationPickerView(selection: $viewModel.selectedDuration)

                Spacer()
            }
            .padding(.horizontal, 24)

            if viewModel.showStartAlert {
                GlassConfirmPopup(title: "Start your new goal?",
                                  message: "Your streak and freezes will start from zero.",
                                  cancelTitle: "Dismiss",
                                  confirmTitle: "Start",
                                  onCancel: { viewModel.cancelStart() },
                                  onConfirm: { viewModel.startConfirmed() })
            }
        }
        .animation(.easeInOut(duration: 0.2), value: viewModel.showStartAlert)
        .toolbar(.hidden, for: .navigationBar)
    }
}

#Preview {
    NavigationStack {
        SetNewGoalView(previousResult: .notMet)
    }
    .preferredColorScheme(.dark)
}
