//
//  WeekStripView.swift
//  LearningJourney
//
//  Created by Monerah Almousa on 09/06/1448 AH.
//

import SwiftUI

/// The 7 days of the week, each one colored by its own status.
struct WeekStripView: View {
    let days: [WeekDay]

    /// On the Activity page an empty "today" is orange. The completion page does not highlight it.
    var highlightsToday = true

    var body: some View {
        HStack(spacing: 0) {
            ForEach(days) { day in
                VStack(spacing: 5) {
                    Text(day.letter)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.white)

                    Text("\(day.number)")
                        .font(.system(size: 25, weight: .medium))
                        .foregroundColor(day.status.textColor)
                        .frame(width: 44, height: 44)
                        .background(
                            Circle().fill(day.status.circleColor(isToday: highlightsToday && day.isToday))
                        )
                }
                .frame(maxWidth: .infinity)
            }
        }
    }
}


// MARK: - Colors of a day (used by the week strip and the calendar)

extension DayStatus {

    var textColor: Color {
        switch self {
        case .normal:  return .white
        case .learned: return Color("learn")
        case .frozen:  return Color("freeze")
        }
    }

    /// `isToday` only matters for a day with no activity: it is highlighted in orange.
    func circleColor(isToday: Bool = false) -> Color {
        switch self {
        case .normal:  return isToday ? Color("learn") : .clear
        case .learned: return Color("learn").opacity(0.2)
        case .frozen:  return Color("freeze").opacity(0.2)
        }
    }
}
