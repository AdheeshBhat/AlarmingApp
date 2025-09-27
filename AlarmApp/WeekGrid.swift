//
//  WeekGrid.swift
//  AlarmApp
//
//  Created by Adheesh Bhat on 9/8/25.
//

import SwiftUI

struct WeekGrid: View {
    let helper: CalendarHelper
    let cellWidth: CGFloat
    let cellHeight: CGFloat
    let date: Date
    let viewModel: CalendarViewModel
    let isReminderViewOn: Bool
    @Binding var cur_screen: Screen
    let firestoreManager: FirestoreManager

    var body: some View {
        let weekDays = helper.generateWeekDays(for: date)
        HStack(spacing: 0) {
            ForEach(weekDays, id: \.self) { day in
                WeekDayCellView(
                    date: day,
                    reminders: viewModel.remindersOnGivenDay(for: day),
                    cellWidth: cellWidth,
                    cellHeight: cellHeight,
                    isReminderViewOn: true,
                    cur_screen: $cur_screen,
                    firestoreManager: firestoreManager
                )
            }
        }
    }
}

