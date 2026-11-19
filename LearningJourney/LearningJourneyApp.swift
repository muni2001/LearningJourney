//
//  LearningJourneyApp.swift
//  LearningJourney
//
//  Created by Monerah Almousa on 29/05/1448 AH.
//

import SwiftUI

@main
struct LearningJourneyApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
                .preferredColorScheme(.dark)
                .tint(Color("learn"))
        }
    }
}

struct RootView: View {
    @ObservedObject private var service = GoalStorageService.shared

    // False at every launch, so the app always opens on Onboarding
    @State private var hasStartedGoal = false

    var body: some View {
        Group {
            if hasStartedGoal {
                NavigationStack { CurrentDayView() }
            } else {
                NavigationStack { OnboardingView() }
            }
        }
        // A new goal is created when the user presses "Start Learning"
        .onChange(of: service.currentGoal?.id) { _, newID in
            if newID != nil { hasStartedGoal = true }
        }
    }
}
