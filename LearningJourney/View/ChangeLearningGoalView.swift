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
                topBar
                goalField
                durationPicker
                Spacer()
            }
            .padding(.horizontal, 24)

            if viewModel.showUpdateAlert {
                updatePopup
            }
        }
        .animation(.easeInOut(duration: 0.2), value: viewModel.showUpdateAlert)
        .toolbar(.hidden, for: .navigationBar)
    }



    private var topBar: some View {
        ZStack {
            Text("Learning Goal")
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(.white)

            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(width: 44, height: 44)
                        .glassEffect(.regular, in: Circle())
                }
                .buttonStyle(.plain)

                Spacer()

                Button {
                    viewModel.confirmTapped()
                } label: {
                    Image(systemName: "checkmark")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(width: 44, height: 44)
                        .glassEffect(.regular.tint(Color("learn")), in: Circle())
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.top, 10)
    }



    private var goalField: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("I want to learn")
                .font(.system(size: 16))
                .foregroundColor(.white)

            VStack(alignment: .leading, spacing: 8) {
                TextField("", text: $viewModel.newSubject,
                          prompt: Text("Swift").foregroundColor(.gray))
                    .foregroundColor(.white)
                    .font(.system(size: 18, weight: .medium))

                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(Color.gray.opacity(0.4))
            }
            .modifier(ShakeEffect(animatableData: CGFloat(viewModel.shakeTrigger)))
            .animation(.default, value: viewModel.shakeTrigger)
        }
        .padding(.top, 10)
    }



    private var durationPicker: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("I want to learn it in a")
                .font(.system(size: 18))
                .foregroundColor(.white)

            HStack(spacing: 13) {
                ForEach(LearningDuration.allCases, id: \.self) { duration in
                    Button {
                        viewModel.selectedDuration = duration
                    } label: {
                        Text(duration.rawValue)
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(viewModel.selectedDuration == duration ? .white : .gray)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 12)
                            .glassEffect(
                                viewModel.selectedDuration == duration
                                    ? .regular.tint(Color("learn"))
                                    : .regular,
                                in: Capsule()
                            )
                    }
                    .buttonStyle(.plain)
                }
                Spacer()
            }
        }
        .padding(.top, 10)
    }

    private var updatePopup: some View {
        ZStack {
            // Dim background (also blocks taps on the page behind)
            Color.black.opacity(0.55)
                .ignoresSafeArea()

            VStack(spacing: 18) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Update goal")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)

                    Text("If you update now, your streak will start over.")
                        .font(.system(size: 17))
                        .foregroundColor(.white.opacity(0.75))
                        .fixedSize(horizontal: false, vertical: true)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 9)
                .padding(.top, 8)

                HStack(spacing: 12) {
                    Button {
                        viewModel.cancelUpdate()
                    } label: {
                        Text("Dismiss")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 48)
                            .glassEffect(.regular, in: Capsule())
                    }
                    .buttonStyle(.plain)

                    Button {
                        viewModel.updateConfirmed()
                        dismiss()
                    } label: {
                        Text("Update")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 48)
                            .glassEffect(.regular.tint(Color("learn")), in: Capsule())
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(14)
            .frame(width: 300)
            .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 34))
        }
        .ignoresSafeArea(.keyboard)
        .transition(.opacity)
    }
}

private struct ShakeEffect: GeometryEffect {
    var travelDistance: CGFloat = 8
    var shakesPerUnit: CGFloat = 3
    var animatableData: CGFloat

    func effectValue(size: CGSize) -> ProjectionTransform {
        let x = travelDistance * sin(animatableData * .pi * shakesPerUnit)
        return ProjectionTransform(CGAffineTransform(translationX: x, y: 0))
    }
}

#Preview {
    NavigationStack {
        ChangeLearningGoalView()
    }
    .preferredColorScheme(.dark)
}
