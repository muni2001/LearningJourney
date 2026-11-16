//
//  DurationPickerView.swift
//  LearningJourney
//
//  Created by Monerah Almousa on 06/06/1448 AH.
//

import SwiftUI

struct DurationPickerView: View {
    @Binding var selection: LearningDuration

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("I want to learn it in a")
                .font(.system(size: 18))
                .foregroundColor(.white)

            HStack(spacing: 13) {
                ForEach(LearningDuration.allCases, id: \.self) { duration in
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
                }
                Spacer()
            }
        }
        .padding(.top, 10)
    }
}
