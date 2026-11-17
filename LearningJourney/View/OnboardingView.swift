//
//  ContentView.swift
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
                
                HStack {
                    Spacer()
                    Image(systemName: "flame.fill")
                        .font(.system(size: 50))
                        .foregroundColor(Color("learn"))
                    Spacer()
                }
                .padding(.top, 55)
                
                VStack(alignment: .leading, spacing: 8) {
                    (Text("Hello ").fontWeight(.regular) + Text("Learner").fontWeight(.bold))
                        .font(.system(size: 37))
                        .foregroundColor(.white)
                    
                    Text("This app will help you learn everyday!")
                        .font(.system(size: 18))
                        .foregroundColor(.gray)
                }
                .preferredColorScheme(.dark)
                .padding(.top, 46)
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("I want to learn")
                        .font(.system(size: 16))
                        .foregroundColor(.white)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        TextField("", text: $viewModel.learningSubject, prompt: Text("Enter your goal").foregroundColor(.gray))
                            .foregroundColor(.white)
                            .font(.system(size: 18, weight: .medium))
                        
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(Color.gray.opacity(0.4))
                    }
                }
                .padding(.top, 10)
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("I want to learn it in a")
                        .font(.system(size: 18))
                        .foregroundColor(.white)
                    
                    HStack(spacing: 13) {
                        ForEach(LearningDuration.allCases, id: \.self) { duration in
                            Button(action: {
                                viewModel.selectedDuration = duration
                            }) {
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
                
                Spacer()
                
                VStack(spacing: 12) {
                    Button {
                        viewModel.startLearningTapped()
                    } label: {
                        Text("Start Learning")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 35)
                            .padding(.vertical, 15)
                            .glassEffect(
                                .regular.tint(Color("learn")),
                                in: Capsule()
                            )
                    }
                    .buttonStyle(.plain)
                    .frame(maxWidth: .infinity)
                    .opacity(viewModel.isFormValid ? 1.0 : 0.6)
                    .disabled(!viewModel.isFormValid)
                
                    
                    Text("You can edit your desire later")
                        .font(.system(size: 13))
                        .foregroundColor(.gray)
                }
                .padding(.bottom, -10)
            }
            .padding(.horizontal, 24)
        }
        .navigationDestination(isPresented: $viewModel.navigateToActivity) {
            CurrentDayView()
        }
        .toolbar(.hidden, for: .navigationBar)
    }
}
#Preview {
    OnboardingView()
}
