//
//  GlassCircleButton.swift
//  LearningJourney
//
//  Created by Monerah Almousa on 06/06/1448 AH.
//

import SwiftUI

/// Round glass icon button (back button, calendar button, ...).
struct GlassCircleButton: View {
    let systemName: String
    var tint: Color? = nil
    var weight: Font.Weight = .semibold
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.system(size: 18, weight: weight))
                .foregroundColor(.white)
                .frame(width: 44, height: 44)
                .glassEffect(.regular.tint(tint), in: Circle())
        }
        .buttonStyle(.plain)
    }
}

