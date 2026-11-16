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
                header
                weekStrip
                statsCards

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
    }


    // MARK: - Header

    private var header: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Activity")
                    .font(.system(size: 34, weight: .bold))
                    .foregroundColor(.white)

                Text(viewModel.todayText)
                    .font(.system(size: 15))
                    .foregroundColor(.gray)
            }

            Spacer()

            HStack(spacing: 12) {
                circleIconButton(systemName: "calendar") {
                    viewModel.calendarTapped()
                }
                circleIconButton(systemName: "pencil.and.outline") {
                    viewModel.setGoalTapped()
                }
            }
        }
        .padding(.top, 10)
    }

    private func circleIconButton(systemName: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.system(size: 18))
                .foregroundColor(.white)
                .frame(width: 44, height: 44)
                .glassEffect(.regular, in: Circle())
        }
        .buttonStyle(.plain)
    }


    // MARK: - Week strip (each day is colored by its own status)

    private var weekStrip: some View {
        HStack(spacing: 0) {
            ForEach(viewModel.weekDays) { day in
                VStack(spacing: 5) {
                    Text(day.letter)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.white)

                    Text("\(day.number)")
                        .font(.system(size: 25, weight: .medium))
                        .foregroundColor(dayTextColor(day.status))
                        .frame(width: 44, height: 44)
                        .background(Circle().fill(dayCircleColor(day.status)))
                }
                .frame(maxWidth: .infinity)
            }
        }
    }

    private func dayCircleColor(_ status: DayStatus) -> Color {
        switch status {
        case .normal:  return .clear
        case .learned: return Color("learn").opacity(0.2)
        case .frozen:  return Color("freeze").opacity(0.2)
        }
    }

    private func dayTextColor(_ status: DayStatus) -> Color {
        switch status {
        case .normal:  return .white
        case .learned: return Color("learn")
        case .frozen:  return Color("freeze")
        }
    }


    // MARK: - Streak / Freeze cards

    private var statsCards: some View {
        HStack(spacing: 13) {
            statCard(icon: "flame.fill",
                     color: Color("learn"),
                     count: viewModel.streakCount,
                     title: "Learned")

            statCard(icon: "snowflake",
                     color: Color("freeze"),
                     count: viewModel.freezeCount,
                     title: "Freezed")
        }
    }

    private func statCard(icon: String, color: Color, count: Int, title: String) -> some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(color)

            Text(viewModel.daysText(count))
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
