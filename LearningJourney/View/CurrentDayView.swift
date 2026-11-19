//
//  CurrentDayView.swift
//  LearningJourney
//
//  Created by Monerah Almousa on 30/05/1448 AH.
//

import SwiftUI

struct CurrentDayView: View {
    @StateObject private var viewModel = CurrentDayViewModel()
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 24) {
                ActivityHeader(dateText: viewModel.todayText,
                               onCalendar: viewModel.calendarTapped,
                               onGoal: viewModel.setGoalTapped)
                #if DEBUG
                .onLongPressGesture { viewModel.showDebugPanel = true }
                #endif

                WeekStripView(days: viewModel.weekDays)

                StatsCardsView(streakCount: viewModel.streakCount,
                               freezeCount: viewModel.freezeCount)

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
        .task {
            while !Task.isCancelled {
                try? await Task.sleep(for: .seconds(30))
                viewModel.refresh()
            }
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
            DebugWeekSheet(days: viewModel.weekDays,
                           onApply: { viewModel.debugApplyWeek($0) },
                           onTimeTravel: { viewModel.debugTimeTravel(hours: $0) })
        }
        #endif
    }


    // MARK: - Log button

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


    // MARK: - Freeze button

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

