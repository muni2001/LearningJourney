//
//  DebugWeekSheet.swift
//  LearningJourney
//
//  Created by Monerah Almousa on 07/06/1448 AH.
//

#if DEBUG
import SwiftUI

/// DEBUG ONLY: lets the reviewer fill the week and jump to the completion page.
struct DebugWeekSheet: View {
    let days: [WeekDay]
    let onApply: ([DayStatus]) -> Void

    @State private var statuses: [DayStatus]
    @Environment(\.dismiss) private var dismiss

    init(days: [WeekDay], onApply: @escaping ([DayStatus]) -> Void) {
        self.days = days
        self.onApply = onApply
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
