//
//  DurationPickerView.swift
//  LearningJourney
//
//  Created by Monerah Almousa on 06/06/1448 AH.
//

import SwiftUI

/// "I want to learn it in a" + the Week / Month / Year buttons.
struct DurationPickerView: View {
    @Binding var selection: LearningDuration

    /// A page can turn some durations off (for example, shorter than the current goal)
    var isAllowed: (LearningDuration) -> Bool = { _ in true }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("I want to learn it in a")
                .font(.system(size: 18))
                .foregroundColor(.white)

            HStack(spacing: 13) {
                ForEach(LearningDuration.allCases, id: \.self) { duration in
                    let allowed = isAllowed(duration)

                    Button {
                        selection = duration
                    } label: {
                        Text(duration.rawValue)
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(selection == duration ? .white : .gray)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 12)
                            .glassEffect(
                                selection == duration
                                    ? .regular.tint(Color("learn"))
                                    : .regular,
                                in: Capsule()
                            )
                    }
                    .buttonStyle(.plain)
                    .disabled(!allowed)
                    .opacity(allowed ? 1 : 0.35)
                }
                Spacer()
            }
        }
        .padding(.top, 10)
    }
}
