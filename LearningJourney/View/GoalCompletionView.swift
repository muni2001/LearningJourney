//
//  GoalCompletionView.swift
//  LearningJourney
//
//  Created by Monerah Almousa on 30/05/1448 AH.
//

import SwiftUI

struct GoalCompletionView: View {
    @StateObject private var viewModel: GoalCompletionViewModel

    init(result: GoalResult,
         weekDays: [WeekDay] = WeekDay.currentWeek(),
         streakCount: Int = 0,
         freezeCount: Int = 0) {
        _viewModel = StateObject(
            wrappedValue: GoalCompletionViewModel(result: result,
                                                  weekDays: weekDays,
                                                  streakCount: streakCount,
                                                  freezeCount: freezeCount)
        )
    }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 24) {
                ActivityHeader(dateText: viewModel.todayText,
                               onCalendar: viewModel.calendarTapped,
                               onGoal: viewModel.setGoalTapped)

                WeekStripView(days: viewModel.weekDays, highlightsToday: false)

                StatsCardsView(streakCount: viewModel.streakCount,
                               freezeCount: viewModel.freezeCount)

                resultBlock
                    .padding(.top, 50)

                setGoalButton
                    .padding(.top, 40)

                Spacer()
            }
            .padding(.horizontal, 24)
        }
        .toolbar(.hidden, for: .navigationBar)
        .navigationDestination(isPresented: $viewModel.showSetNewGoal) {
            SetNewGoalView(previousResult: viewModel.result)
        }
        .navigationDestination(isPresented: $viewModel.showCalendar) {
            CalendarView()
        }
    }


    // MARK: - Result (icon + texts)

    private var resultBlock: some View {
        VStack(spacing: 10) {
            Image(systemName: viewModel.iconName)
                .font(.system(size: 60))
                .foregroundColor(Color("learn"))
                .padding(.bottom, 14)

            Text(viewModel.title)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)

            Text(viewModel.subtitle)
                .font(.system(size: 15))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
    }


    // MARK: - Set a goal button

    private var setGoalButton: some View {
        Button {
            viewModel.setGoalTapped()
        } label: {
            HStack(spacing: 8) {
                Image(systemName: "pencil.and.outline")
                Text("Set a goal")
            }
            .font(.system(size: 18, weight: .semibold))
            .foregroundColor(.white)
            .padding(.horizontal, 30)
            .padding(.vertical, 16)
            .glassEffect(.regular.tint(Color("learn")), in: Capsule())
        }
        .buttonStyle(.plain)
    }
}


// MARK: - Previews
// The page itself never contains numbers: everything comes from the init (zeros by default).
// The two "Sample" previews only use made-up numbers so we can compare with the design.
// Each preview is inside a NavigationStack so the "Set a goal" button can navigate.

#Preview("Fresh start (all zeros)") {
    NavigationStack {
        GoalCompletionView(result: .notMet)
    }
    .preferredColorScheme(.dark)
}

private func sampleWeek(_ statuses: [DayStatus]) -> [WeekDay] {
    let letters = ["S", "M", "T", "W", "T", "F", "S"]
    return statuses.enumerated().map { index, status in
        WeekDay(id: 20 + index,
                letter: letters[index],
                number: 20 + index,
                isToday: false,
                status: status)
    }
}

#Preview("Sample: Completed") {
    NavigationStack {
        GoalCompletionView(
            result: .completed,
            weekDays: sampleWeek([.learned, .learned, .learned, .frozen, .frozen, .normal, .normal]),
            streakCount: 3,
            freezeCount: 2
        )
    }
    .preferredColorScheme(.dark)
}

#Preview("Sample: Not Met") {
    NavigationStack {
        GoalCompletionView(
            result: .notMet,
            weekDays: sampleWeek([.learned, .learned, .normal, .frozen, .frozen, .normal, .normal]),
            streakCount: 2,
            freezeCount: 2
        )
    }
    .preferredColorScheme(.dark)
}
