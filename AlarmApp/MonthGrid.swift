//
//  MonthGrid.swift
//  AlarmApp
//
//  Created by Adheesh Bhat on 9/8/25.
//

import SwiftUI

struct MonthGrid: View {
    let helper: CalendarHelper
    let cellWidth: CGFloat
    let cellHeight: CGFloat
    let date: Date
    let viewModel: CalendarViewModel
    @Binding var cur_screen: Screen
    @Binding var DatabaseMock: Database
    let firestoreManager: FirestoreManager

    var body: some View {
        let days = helper.generateCalendarDays(for: date)
        VStack(spacing: 0) {
            ForEach(0..<6, id: \.self) { row in
                HStack(spacing: 0) {
                    ForEach(0..<7, id: \.self) { col in
                        let dayIndex = row * 7 + col
                        let day = dayIndex < days.count ? days[dayIndex] : nil
                        MonthDayCellView(
                            date: day,
                            reminders: viewModel.remindersOnGivenDay(for: day ?? Date()),
                            cellHeight: cellHeight,
                            zoomScale: 1.0,
                            isReminderViewOn: false,
                            cur_screen: $cur_screen,
                            DatabaseMock: $DatabaseMock,
                            firestoreManager: firestoreManager
                        )
                        .frame(width: cellWidth, height: cellHeight)
                    }
                }
            }
        }
    }
}
