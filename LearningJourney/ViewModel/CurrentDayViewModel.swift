//
//  CurrentDayViewModel.swift
//  LearningJourney
//
//  Created by Monerah Almousa on 30/05/1448 AH.
//

import SwiftUI
import Combine


class CurrentDayViewModel: ObservableObject {

    // The goal now comes from the shared service (it can be nil, e.g. in a Preview)
    @Published private(set) var currentGoal: LearningGoal?

    // State
    @Published var streakCount: Int = 0
    @Published var freezeCount: Int = 0
    @Published var dayStatus: DayStatus = .normal

    // The day the page is showing. When it changes (12AM) the page redraws itself.
    @Published private(set) var currentDay: Date = AppClock.calendar.startOfDay(for: AppClock.now)

    // Navigation trigger for the pencil button
    @Published var showChangeGoal = false
    @Published var showCalendar = false

    // Goal completion page (shown when the goal period ends)
    @Published var showCompletion = false
    @Published private(set) var completionResult: GoalResult = .notMet

    private let service: GoalStorageService
    private var cancellables = Set<AnyCancellable>()

    /// The streak starts over after more than this many hours without logging or freezing
    private let streakLimitInHours: Double = 32

    init(service: GoalStorageService = .shared) {
        self.service = service
        self.currentGoal = service.currentGoal

        // Listen to the service: when the goal changes, start fresh
        service.$currentGoal
            .dropFirst()
            .sink { [weak self] newGoal in
                self?.goalChanged(to: newGoal)
            }
            .store(in: &cancellables)
    }

    private func goalChanged(to newGoal: LearningGoal?) {
        // Same goal edited (e.g. only the duration)? The id stays the same: keep the progress.
        let isDifferentGoal = newGoal?.id != currentGoal?.id
        currentGoal = newGoal
        guard isDifferentGoal else { return }

        streakCount = 0
        freezeCount = 0
        dayStatus = .normal
        showCompletion = false   // closes the completion pages that are open on top
    }


    // MARK: - Time rules (12AM and 32 hours)

    /// Called when the page appears, when the app comes back, and every 30 seconds.
    func refresh() {
        // Rule 1: a new day starts at 12AM.
        // The day the page shows is the day of "now". Its status comes from the history,
        // so a new day with no record is .normal (the buttons are fresh again).
        let today = AppClock.calendar.startOfDay(for: AppClock.now)
        if currentDay != today {
            currentDay = today
        }

        let status = todayStatus(for: currentGoal)
        if dayStatus != status {
            dayStatus = status
        }

        // Rule 2: more than 32 hours without logging or freezing = the streak starts over.
        checkStreakExpiry()
    }

    /// The status of a day, but ONLY if that day belongs to this goal.
    /// A day with no record, or a record of another goal, counts as .normal.
    private func status(on date: Date, for goal: LearningGoal?) -> DayStatus {
        guard let record = service.day(on: date),
              record.goalID == goal?.id else { return .normal }
        return record.status
    }

    /// Today's status for this goal, read from the history.
    private func todayStatus(for goal: LearningGoal?) -> DayStatus {
        status(on: AppClock.now, for: goal)
    }

    private func checkStreakExpiry() {
        // Nothing to reset if the streak is already 0 or the user never logged anything
        guard streakCount > 0,
              let lastActivity = service.lastActivityDate(for: currentGoal) else { return }

        let hoursPassed = AppClock.now.timeIntervalSince(lastActivity) / 3600

        if hoursPassed > streakLimitInHours {
            streakCount = 0
        }
    }


    // MARK: - Freeze rules

    var duration: LearningDuration { currentGoal?.duration ?? .week }

    var freezeLimit: Int { duration.freezeLimit }

    var allFreezesUsed: Bool { freezeCount >= freezeLimit }


    // Interaction: can the button be pressed at all?
    var isFreezeDisabled: Bool { allFreezesUsed && dayStatus != .frozen }

    // Appearance: should the Freeze button look gray?
    var isFreezeDimmed: Bool { dayStatus == .frozen || isFreezeDisabled }

    var logButtonTitle: String {
        dayStatus == .learned ? "Logged as Learned" : "Log as Learned"
    }

    var freezeButtonTitle: String {
        (dayStatus == .frozen || allFreezesUsed) ? "Freezed for a day" : "Freeze for a day"
    }

    var freezeUsageText: String {
        "\(freezeCount) out of \(freezeLimit) Freezes used"
    }


    func daysText(_ count: Int) -> String {
        count == 1 ? "\(count) day" : "\(count) days"
    }

    var todayText: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = "EEEE, d MMMM"
        return formatter.string(from: AppClock.now)
    }

    /// The 7 days of this week. Each day shows its status ONLY for the current goal,
    /// so when the user starts a new goal the strip starts clean.
    var weekDays: [WeekDay] {
        WeekDay.currentWeek { date in
            self.status(on: date, for: self.currentGoal)
        }
    }


    // MARK: - Actions

    func logAsLearnedTapped() {
        switch dayStatus {
        case .normal:
            applyLearned()
        case .learned:
            undoLearned()
        case .frozen:
            undoFreeze()
            applyLearned()
        }
    }

    func freezeTapped() {
        guard !isFreezeDisabled else { return }

        switch dayStatus {
        case .normal:
            applyFreeze()
        case .frozen:
            undoFreeze()
        case .learned:
            undoLearned()
            applyFreeze()
        }
    }

    func calendarTapped() {
        showCalendar = true
    }

    /// Pencil button: open the Change Learning Goal page
    func setGoalTapped() {
        showChangeGoal = true
    }


#if DEBUG
@Published var showDebugPanel = false

/// DEBUG: writes the chosen statuses for this week, then opens the completion page.
/// All 7 days learned/frozen = completed, otherwise = notMet.
func debugApplyWeek(_ statuses: [DayStatus]) {
    let calendar = AppClock.calendar
    guard let weekStart = calendar.dateInterval(of: .weekOfYear, for: AppClock.now)?.start else { return }

    for (offset, status) in statuses.enumerated() {
        guard let date = calendar.date(byAdding: .day, value: offset, to: weekStart) else { continue }
        service.setStatus(status, on: date)
        if calendar.isDate(date, inSameDayAs: AppClock.now) { dayStatus = status }
    }

    streakCount = statuses.filter { $0 == .learned }.count
    freezeCount = statuses.filter { $0 == .frozen }.count
    completionResult = statuses.allSatisfy { $0 != .normal } ? .completed : .notMet

    // wait for the sheet to close before navigating
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { [weak self] in
        self?.showCompletion = true
    }
}

/// DEBUG: moves the app's clock forward, then runs the time rules again.
func debugTimeTravel(hours: Double) {
    AppClock.offset += hours * 3600
    refresh()
    objectWillChange.send()
}
#endif


    // MARK: - Building blocks

    private func applyLearned() {
        streakCount += 1
        setToday(.learned)
    }

    private func undoLearned() {
        streakCount = max(streakCount - 1, 0)
        setToday(.normal)
    }

    private func applyFreeze() {
        freezeCount += 1
        setToday(.frozen)
    }

    private func undoFreeze() {
        freezeCount = max(freezeCount - 1, 0)
        setToday(.normal)
    }

    /// Updates today's status here AND in the shared history (so the Calendar can show it)
    private func setToday(_ status: DayStatus) {
        dayStatus = status
        service.setStatus(status)
    }
}
