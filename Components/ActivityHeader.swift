//
//  ActivityHeader.swift
//  LearningJourney
//
//  Created by Monerah Almousa on 09/06/1448 AH.
//

import SwiftUI

/// "Activity" + today's date, with the calendar and the goal buttons.
/// Used by the Activity page and by the Goal Completion page.
struct ActivityHeader: View {
    let dateText: String
    let onCalendar: () -> Void
    let onGoal: () -> Void

    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Activity")
                    .font(.system(size: 34, weight: .bold))
                    .foregroundColor(.white)

                Text(dateText)
                    .font(.system(size: 15))
                    .foregroundColor(.gray)
            }

            Spacer()

            HStack(spacing: 12) {
                GlassCircleButton(systemName: "calendar", weight: .regular, action: onCalendar)
                GlassCircleButton(systemName: "pencil.and.outline", weight: .regular, action: onGoal)
            }
        }
        .padding(.top, 10)
    }
}
