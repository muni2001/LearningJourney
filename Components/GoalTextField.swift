//
//  GoalTextField.swift
//  LearningJourney
//
//  Created by Monerah Almousa on 06/06/1448 AH.
//

import SwiftUI

/// "I want to learn" + the underlined text field. Shakes when `shakeTrigger` changes.
struct GoalTextField: View {
    @Binding var text: String
    let placeholder: String
    var shakeTrigger: Int = 0

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("I want to learn")
                .font(.system(size: 16))
                .foregroundColor(.white)

            VStack(alignment: .leading, spacing: 8) {
                TextField("", text: $text,
                          prompt: Text(placeholder).foregroundColor(.gray))
                    .foregroundColor(.white)
                    .font(.system(size: 18, weight: .medium))

                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(Color.gray.opacity(0.4))
            }
            .modifier(ShakeEffect(animatableData: CGFloat(shakeTrigger)))
            .animation(.default, value: shakeTrigger)
        }
        .padding(.top, 10)
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
