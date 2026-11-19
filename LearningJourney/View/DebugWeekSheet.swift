//
//  DebugWeekSheet.swift
//  LearningJourney
//
//  Created by Monerah Almousa on 07/06/1448 AH.
//

#if DEBUG
import SwiftUI

/// DEBUG ONLY: lets the reviewer fill the week, jump to the completion page,
/// or move the app's clock forward to see the 12AM and 32 hours rules.
struct DebugWeekSheet: View {
    let days: [WeekDay]
    let onApply: ([DayStatus]) -> Void
    let onTimeTravel: (Double) -> Void

    @State private var statuses: [DayStatus]
    @Environment(\.dismiss) private var dismiss

    init(days: [WeekDay],
         onApply: @escaping ([DayStatus]) -> Void,
         onTimeTravel: @escaping (Double) -> Void) {
        self.days = days
        self.onApply = onApply
        self.onTimeTravel = onTimeTravel
        _statuses = State(initialValue: days.map(\.status))
    }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 18) {
                Text("Debug: set the week")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.top, 20)

                HStack(spacing: 10) {
                    presetButton("All learned") {
                        statuses = Array(repeating: .learned, count: days.count)
                    }
                    presetButton("5 + 2 freezes") {
                        statuses = [.learned, .learned, .learned, .frozen, .frozen, .learned, .learned]
                    }
                    presetButton("Clear") {
                        statuses = Array(repeating: .normal, count: days.count)
                    }
                }

                VStack(spacing: 12) {
                    ForEach(days.indices, id: \.self) { i in
                        HStack {
                            Text("\(days[i].letter) \(days[i].number)")
                                .foregroundColor(.white)
                                .frame(width: 50, alignment: .leading)

                            Picker("", selection: $statuses[i]) {
                                Text("None").tag(DayStatus.normal)
                                Text("Learned").tag(DayStatus.learned)
                                Text("Frozen").tag(DayStatus.frozen)
                            }
                            .pickerStyle(.segmented)
                        }
                    }
                }

                VStack(spacing: 10) {
                    Text("Move the app's clock forward")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)

                    HStack(spacing: 10) {
                        presetButton("+1 day (12 AM)") {
                            onTimeTravel(24)
                            dismiss()
                        }
                        presetButton("+33 hours (32h rule)") {
                            onTimeTravel(33)
                            dismiss()
                        }
                    }
                }
                .padding(.top, 8)

                Spacer()

                Button {
                    onApply(statuses)
                    dismiss()
                } label: {
                    Text("Apply")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 48)
                        .glassEffect(.regular.tint(Color("learn")), in: Capsule())
                }
                .buttonStyle(.plain)
                .padding(.bottom, 10)
            }
            .padding(.horizontal, 24)
        }
        .presentationDetents([.large])
        .preferredColorScheme(.dark)
    }

    private func presetButton(_ title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.white)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .glassEffect(.regular, in: Capsule())
        }
        .buttonStyle(.plain)
    }
}
#endif

