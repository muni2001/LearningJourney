//
//  GoalNavBar.swift
//  LearningJourney
//
//  Created by Monerah Almousa on 06/06/1448 AH.
//

import SwiftUI

struct GoalNavBar: View {
    let title: String
    let onBack: () -> Void
    let onConfirm: () -> Void

    var body: some View {
        ZStack {
            Text(title)
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(.white)

            HStack {
                Button(action: onBack) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(width: 44, height: 44)
                        .glassEffect(.regular, in: Circle())
                }
                .buttonStyle(.plain)

                Spacer()

                Button(action: onConfirm) {
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
}
