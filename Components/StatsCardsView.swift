//
//  StatsCardsView.swift
//  LearningJourney
//
//  Created by Monerah Almousa on 09/06/1448 AH.
//

import SwiftUI

/// The two glass cards: days learned (streak) and days freezed.
struct StatsCardsView: View {
    let streakCount: Int
    let freezeCount: Int

    var body: some View {
        HStack(spacing: 13) {
            StatCard(icon: "flame.fill",
                     color: Color("learn"),
                     count: streakCount,
                     title: "Learned")

            StatCard(icon: "snowflake",
                     color: Color("freeze"),
                     count: freezeCount,
                     title: "Freezed")
        }
    }
}

private struct StatCard: View {
    let icon: String
    let color: Color
    let count: Int
    let title: String

    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(color)

            // "1 day", but "0 days" and "2 days"
            Text(count == 1 ? "\(count) day" : "\(count) days")
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(.white)

            Text(title)
                .font(.system(size: 13))
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 100)
        .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 30))
    }
}
