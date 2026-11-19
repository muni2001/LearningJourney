//
//  CurrentDayViewModel.swift
//  LearningJourney
//
//  Created by Monerah Almousa on 30/05/1448 AH.
//

import SwiftUI
import Combine

class CurrentDayViewModel: ObservableObject {

    // MARK: - State shown on the page

    // The goal comes from the shared service (it can be nil, e.g. in a Preview)
    @Published private(set) var currentGoal: LearningGoal?

    // Both counters are always read from the saved history, never kept separately
    @Published private(set) var streakCount = 0
    @Published private(set) var freezeCount = 0
    @Published private(set) var dayStatus: DayStatus = .normal

    // The day the page is showing. When it changes (12AM) the page redraws itself.
    @Published private(set) var currentDay: Date = AppClock.calendar.startOfDay(for: AppClock.now)

    // Navigation triggers
    @Published var showChangeGoal = false
    @Published var showCalendar = false

    // Goal completion page (shown when the goal period ends)
    @Published var showCompletion = false
    @Published private(set) var completionResult: GoalResult = .notMet

    #if DEBUG
    @Published var showDebugPanel = false
    #endif

    private let service: GoalStorageService
    private let dayTitleFormatter = DateFormatter.english(DatePattern.dayTitle)
    private var cancellables = Set<AnyCancellable>()

    init(service: GoalStorageService = .shared) {
        self.service = service
        self.currentGoal = service.currentGoal
        reloadState()

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

        if isDifferentGoal {
            showCompletion = false   // closes the completion pages that are open on top
        }
        reloadState()                // a new goal has no records, so everything starts from zero
    }


    // MARK: - Time rules (12AM, 32 hours, end of the goal)

    /// Called when the page appears, when the app comes back, and every 30 seconds.
    func refresh() {
        // A new day starts at 12AM: the page shows the day of "now".
        // A new day has no record, so today's status is .normal and the buttons are fresh again.
        let today = AppClock.calendar.startOfDay(for: AppClock.now)
        if currentDay != today {
            currentDay = today
        }

        // The 32 hours rule is part of the streak calculation, so reading again applies it.
        reloadState()
        checkGoalOutcome()
    }

    /// Reads today's status and both counters from the saved history.
    private func reloadState() {
        let newStatus = status(on: AppClock.now, for: currentGoal)
        var newStreak = 0
        var newFreezes = 0

        if let goal = currentGoal {
            let records = service.records(for: goal)
            newStreak = StreakCalculator.streak(from: records, now: AppClock.now)
            newFreezes = records.filter { $0.status == .frozen }.count
        }

        // Only publish real changes, so the page does not redraw for nothing
        if dayStatus != newStatus { dayStatus = newStatus }
        if streakCount != newStreak { streakCount = newStreak }
        if freezeCount != newFreezes { freezeCount = newFreezes }
    }

    /// When the goal period is over, shows the result:
    /// completed if every day of the goal was learned or frozen, otherwise not met.
    private func checkGoalOutcome() {
        guard !showCompletion,
              let goal = currentGoal,
              let endDate = goal.endDate,
              AppClock.now >= endDate else { return }

        let firstDay = AppClock.calendar.startOfDay(for: goal.startDate)
        let loggedDays = service.records(for: goal)
            .filter { $0.date >= firstDay && $0.date < endDate }
            .count

        completionResult = loggedDays >= goal.duration.dayCount ? .completed : .notMet
        showCompletion = true
    }

    /// The status of a day, but ONLY if that day belongs to this goal.
    /// A day with no record, or a record of another goal, counts as .normal.
    private func status(on date: Date, for goal: LearningGoal?) -> DayStatus {
        guard let record = service.day(on: date),
              record.goalID == goal?.id else { return .normal }
        return record.status
    }


    // MARK: - Freeze rules

    var duration: LearningDuration { currentGoal?.duration ?? .week }

    var freezeLimit: Int { duration.freezeLimit }

    var allFreezesUsed: Bool { freezeCount >= freezeLimit }

    // Interaction: can the button be pressed at all?
    // (a frozen day can still be pressed to switch back)
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

    var todayText: String {
        dayTitleFormatter.string(from: AppClock.now)
    }

    /// The 7 days of this week. Each day shows its status ONLY for the current goal,
    /// so when the user starts a new goal the strip starts clean.
    var weekDays: [WeekDay] {
        WeekDay.currentWeek { date in
            self.status(on: date, for: self.currentGoal)
        }
    }


    // MARK: - Actions

    /// Learned and Frozen can replace each other during the same day.
    /// Pressing the same button again undoes it.
    func logAsLearnedTapped() {
        setToday(dayStatus == .learned ? .normal : .learned)
    }

    func freezeTapped() {
        guard !isFreezeDisabled else { return }
        setToday(dayStatus == .frozen ? .normal : .frozen)
    }

    func calendarTapped() {
        showCalendar = true
    }

    /// Pencil button: open the Change Learning Goal page
    func setGoalTapped() {
        showChangeGoal = true
    }

    /// Saves today's status in the shared history (the Calendar reads it from there)
    private func setToday(_ status: DayStatus) {
        service.setStatus(status)
        reloadState()
    }
}


#if DEBUG
// MARK: - Debug tools (not part of the app logic)
// They only help to show that the rules work, without waiting several days.

extension CurrentDayViewModel {

    /// Writes the chosen statuses for this week, then opens the completion page.
    /// All 7 days learned/frozen = completed, otherwise = notMet.
    func debugApplyWeek(_ statuses: [DayStatus]) {
        let calendar = AppClock.calendar
        guard let weekStart = calendar.dateInterval(of: .weekOfYear, for: AppClock.now)?.start else { return }

        for (offset, status) in statuses.enumerated() {
            guard let date = calendar.date(byAdding: .day, value: offset, to: weekStart) else { continue }
            service.setStatus(status, on: date)
        }

        reloadState()
        completionResult = statuses.allSatisfy { $0 != .normal } ? .completed : .notMet

        // wait for the sheet to close before navigating
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { [weak self] in
            self?.showCompletion = true
        }
    }

    /// Moves the app's clock forward, then runs the time rules again.
    func debugTimeTravel(hours: Double) {
        AppClock.offset += hours * 3600
        refresh()
        objectWillChange.send()
    }
}
#endif
