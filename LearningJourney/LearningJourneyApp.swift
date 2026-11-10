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
            OnboardingView()
                .preferredColorScheme(.dark)
                .tint(Color("learn"))
        }
    }
}
