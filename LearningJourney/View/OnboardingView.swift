//
//  OnboardingView.swift
//  LearningJourney
//
//  Created by Monerah Almousa on 29/05/1448 AH.
//

import SwiftUI

struct OnboardingView: View {
    @StateObject private var viewModel = OnboardingViewModel()

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(alignment: .leading, spacing: 24) {
                logo
                welcomeText

                GoalTextField(text: $viewModel.learningSubject,
                              placeholder: "Enter your goal")

                DurationPickerView(selection: $viewModel.selectedDuration)

                Spacer()

                startButton
            }
            .padding(.horizontal, 24)
        }
        .toolbar(.hidden, for: .navigationBar)
    }


    private var logo: some View {
        HStack {
            Spacer()
            Image(systemName: "flame.fill")
                .font(.system(size: 50))
                .foregroundColor(Color("learn"))
            Spacer()
        }
        .padding(.top, 55)
    }

    private var welcomeText: some View {
        VStack(alignment: .leading, spacing: 8) {
            (Text("Hello ").fontWeight(.regular) + Text("Learner").fontWeight(.bold))
                .font(.system(size: 37))
                .foregroundColor(.white)

            Text("This app will help you learn everyday!")
                .font(.system(size: 18))
                .foregroundColor(.gray)
        }
        .padding(.top, 46)
    }

    private var startButton: some View {
        VStack(spacing: 12) {
            Button {
                viewModel.startLearningTapped()
            } label: {
                Text("Start Learning")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 35)
                    .padding(.vertical, 15)
                    .glassEffect(.regular.tint(Color("learn")), in: Capsule())
            }
            .buttonStyle(.plain)
            .frame(maxWidth: .infinity)
            .opacity(viewModel.isFormValid ? 1.0 : 0.6)
            .disabled(!viewModel.isFormValid)

            Text("You can edit your desire later")
                .font(.system(size: 13))
                .foregroundColor(.gray)
        }
        .padding(.bottom, -10)   // pulls the button closer to the bottom edge, as in the design
    }
}

#Preview {
    NavigationStack {
        OnboardingView()
    }
    .preferredColorScheme(.dark)
}
