//
//  GlassConfirmPopup.swift
//  LearningJourney
//
//  Created by Monerah Almousa on 06/06/1448 AH.
//

import SwiftUI

struct GlassConfirmPopup: View {
    let title: String
    var message: String? = nil
    let cancelTitle: String
    let confirmTitle: String
    let onCancel: () -> Void
    let onConfirm: () -> Void

    var body: some View {
        ZStack {
            Color.black.opacity(0.55)
                .ignoresSafeArea()

            VStack(spacing: 18) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(title)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)

                    if let message {
                        Text(message)
                            .font(.system(size: 17))
                            .foregroundColor(.white.opacity(0.75))
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 9)
                .padding(.top, 8)

                HStack(spacing: 12) {
                    Button(action: onCancel) {
                        Text(cancelTitle)
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 48)
                            .glassEffect(.regular, in: Capsule())
                    }
                    .buttonStyle(.plain)

                    Button(action: onConfirm) {
                        Text(confirmTitle)
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
