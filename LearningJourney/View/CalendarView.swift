//
//  CalendarView.swift
//  LearningJourney
//
//  Created by Monerah Almousa on 30/05/1448 AH.
//

import SwiftUI

struct CalendarView: View {
    @StateObject private var viewModel = CalendarViewModel()
    @Environment(\.dismiss) private var dismiss

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 0), count: 7)
    private let weekdaySymbols = ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"]

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            ScrollViewReader { proxy in
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        ForEach(Array(viewModel.months.enumerated()), id: \.element.id) { index, month in
                            monthSection(month, showsDivider: index > 0)
                                .id(month.id)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 30)
                }
                .onAppear {
                    if let id = viewModel.currentMonthID {
                        proxy.scrollTo(id, anchor: .top)
                    }
                }
            }
        }
        .safeAreaInset(edge: .top) { header }
        .overlay {
            if let info = viewModel.selectedInfo {
                GlassInfoPopup(title: info.title,
                               lines: info.lines,
                               buttonTitle: "Got it",
                               onClose: { viewModel.closePopup() })
            }
        }
        .animation(.easeInOut(duration: 0.2), value: viewModel.selectedInfo != nil)
        .toolbar(.hidden, for: .navigationBar)
    }


    // MARK: - Header

    private var header: some View {
        ZStack {
            Text("Activities")
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(.white)

            HStack {
                GlassCircleButton(systemName: "chevron.left") {
                    dismiss()
                }
                Spacer()
            }
        }
        .padding(.horizontal, 24)
        .padding(.top, 10)
        .padding(.bottom, 8)
        .background(Color.black)
    }


    // MARK: - One month

    private func monthSection(_ month: CalendarMonth, showsDivider: Bool) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            if showsDivider {
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(Color.white.opacity(0.12))
            }

            Text(month.title)
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.white)
                .padding(.horizontal, 4)

            HStack(spacing: 0) {
                ForEach(weekdaySymbols, id: \.self) { symbol in
                    Text(symbol)
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity)
                }
            }

            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(month.cells) { cell in
                    dayCell(cell)
                }
            }
        }
        .padding(.top, showsDivider ? 18 : 4)
    }

    @ViewBuilder
    private func dayCell(_ cell: CalendarCell) -> some View {
        if let number = cell.number {
            Button {
                viewModel.dayTapped(cell)
            } label: {
                Text("\(number)")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(textColor(for: cell))
                    .frame(width: 42, height: 42)
                    .background(Circle().fill(circleColor(for: cell)))
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.plain)
        } else {
            Color.clear
                .frame(width: 42, height: 42)
        }
    }

    private func circleColor(for cell: CalendarCell) -> Color {
        switch cell.status {
        case .learned: return Color("learn").opacity(0.2)
        case .frozen:  return Color("freeze").opacity(0.2)
        case .normal:  return cell.isToday ? Color("learn") : .clear
        }
    }

    private func textColor(for cell: CalendarCell) -> Color {
        switch cell.status {
        case .learned: return Color("learn")
        case .frozen:  return Color("freeze")
        case .normal:  return .white
        }
    }
}

#Preview {
    NavigationStack {
        CalendarView()
    }
    .preferredColorScheme(.dark)
}
