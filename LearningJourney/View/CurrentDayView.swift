//
//  CurrentDayView.swift
//  LearningJourney
//
//  Created by Monerah Almousa on 30/05/1448 AH.
//

import SwiftUI
import Combine

struct CurrentDayView: View {
    @StateObject private var viewModel = CurrentDayViewModel()
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 24) {
                header
                weekStrip
                statsCards

                Spacer()

                logButton

                Spacer()

                VStack(spacing: 12) {
                    freezeButton

                    Text(viewModel.freezeUsageText)
                        .font(.system(size: 13))
                        .foregroundColor(.gray)
                }
                .padding(.bottom, 20)
            }
            .padding(.horizontal, 24)
        }
        .toolbar(.hidden, for: .navigationBar)
        // Time rules: check when the page appears, when the app comes back, and every 30 seconds
        .onAppear { viewModel.refresh() }
        .onChange(of: scenePhase) { _, newPhase in
            if newPhase == .active { viewModel.refresh() }
        }
        .onReceive(Timer.publish(every: 30, on: .main, in: .common).autoconnect()) { _ in
            viewModel.refresh()
        }
        .navigationDestination(isPresented: $viewModel.showChangeGoal) {
            ChangeLearningGoalView()
        }
        .navigationDestination(isPresented: $viewModel.showCalendar) {
            CalendarView()
        }
        .navigationDestination(isPresented: $viewModel.showCompletion) {
            GoalCompletionView(result: viewModel.completionResult,
                               weekDays: viewModel.weekDays,
                               streakCount: viewModel.streakCount,
                               freezeCount: viewModel.freezeCount)
        }
#if DEBUG
.sheet(isPresented: $viewModel.showDebugPanel) {
    DebugWeekSheet(days: viewModel.weekDays) { statuses in
        viewModel.debugApplyWeek(statuses)
    }
}
#endif
    }


    private var header: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Activity")
                    .font(.system(size: 34, weight: .bold))
                    .foregroundColor(.white)
#if DEBUG
.onLongPressGesture { viewModel.showDebugPanel = true }
#endif
                Text(viewModel.todayText)
                    .font(.system(size: 15))
                    .foregroundColor(.gray)
#if DEBUG
.onLongPressGesture { viewModel.debugTimeTravel(hours: 24) }   // +1 day
.onTapGesture(count: 2) { viewModel.debugTimeTravel(hours: 33) }   // +33 hours
#endif
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


    private var weekStrip: some View {
        HStack(spacing: 0) {
            ForEach(viewModel.weekDays) { day in
                VStack(spacing: 5) {
                    Text(day.letter)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.white)

                    Text("\(day.number)")
                        .font(.system(size: 25, weight: .medium))
                        .foregroundColor(dayTextColor(day))
                        .frame(width: 44, height: 44)
                        .background(Circle().fill(dayCircleColor(day)))
                }
                .frame(maxWidth: .infinity)
            }
        }
    }

    /// Today follows the buttons (dayStatus). The other days come from the history.
    private func status(of day: WeekDay) -> DayStatus {
        day.isToday ? viewModel.dayStatus : day.status
    }

    private func dayCircleColor(_ day: WeekDay) -> Color {
        switch status(of: day) {
        case .learned: return Color("learn").opacity(0.2)
        case .frozen:  return Color("freeze").opacity(0.2)
        case .normal:  return day.isToday ? Color("learn") : .clear
        }
    }

    private func dayTextColor(_ day: WeekDay) -> Color {
        switch status(of: day) {
        case .learned: return Color("learn")
        case .frozen:  return Color("freeze")
        case .normal:  return .white
        }
    }


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


    private var logButton: some View {
        Button {
            viewModel.logAsLearnedTapped()
        } label: {
            Text(viewModel.logButtonTitle)
                .font(.system(size: 22, weight: .semibold))
                .foregroundColor(logTextColor)
                .frame(width: 290, height: 290)
                .glassEffect(logGlass, in: Circle())
        }
        .buttonStyle(.plain)
    }

    private var logGlass: Glass {
        viewModel.dayStatus != .learned
            ? .regular.tint(Color("learn"))
            : .regular
    }

    private var logTextColor: Color {
        viewModel.dayStatus == .learned ? .gray : .white
    }


    private var freezeButton: some View {
        Button {
            viewModel.freezeTapped()
        } label: {
            Text(viewModel.freezeButtonTitle)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(viewModel.isFreezeDimmed ? .gray : .white)
                .frame(width: 270, height: 48)
                .glassEffect(freezeGlass, in: Capsule())
        }
        .buttonStyle(.plain)
        .disabled(viewModel.isFreezeDisabled)
    }

    private var freezeGlass: Glass {
        viewModel.isFreezeDimmed
            ? .regular
            : .regular.tint(Color("freeze"))
    }
}

#Preview {
    NavigationStack {
        CurrentDayView()
    }
    .preferredColorScheme(.dark)
}
