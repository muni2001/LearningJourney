//
//  GlassInfoPopup.swift
//  LearningJourney
//
//  Created by Monerah Almousa on 06/06/1448 AH.
//

import SwiftUI

/// Dimmed background + glass popup with a title, some lines and ONE orange button.
struct GlassInfoPopup: View {
    let title: String
    let lines: [String]
    let buttonTitle: String
    let onClose: () -> Void

    var body: some View {
        ZStack {
            // Dim background: tapping it closes the popup too
            Color.black.opacity(0.55)
                .ignoresSafeArea()
                .onTapGesture { onClose() }

            VStack(spacing: 18) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(title)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)

                    ForEach(Array(lines.enumerated()), id: \.offset) { _, line in
                        Text(line)
                            .font(.system(size: 17))
                            .foregroundColor(.white.opacity(0.75))
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 9)
                .padding(.top, 8)

                Button(action: onClose) {
                    Text(buttonTitle)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 48)
                        .glassEffect(.regular.tint(Color("learn")), in: Capsule())
                }
                .buttonStyle(.plain)
            }
            .padding(14)
            .frame(width: 300)
            .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 34))
        }
        .transition(.opacity)
    }
}
