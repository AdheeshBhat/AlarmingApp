//
//  CalendarDayCellViews.swift
//  AlarmApp
//
//  Created by Adheesh Bhat on 9/3/25.
//

import SwiftUI

struct MonthDayCellView: View {
    let date: Date?
    let reminders: [CalendarReminder]
    let cellHeight: CGFloat
    let zoomScale: CGFloat
    let isReminderViewOn: Bool
    @Binding var cur_screen: Screen
    @Binding var DatabaseMock: Database
    let firestoreManager: FirestoreManager

    // Helper to safely fetch ReminderData for a normalized date
    private func reminderData(for reminder: CalendarReminder) -> ReminderData? {
        let normalizedDate = normalizeDate(reminder.date)
        if let userReminders = DatabaseMock.users[1] {
            // Find the ReminderData with the same normalized date and matching title
            return userReminders.first(where: {
                normalizeDate($0.value.date) == normalizedDate && $0.value.title == reminder.title
            })?.value
        }
        return nil
    }

    var body: some View {
        VStack(spacing: 2) {
            if let date = date {
                if !reminders.isEmpty {
                    let reminderCount = reminders.count
                    let circleColor: Color = reminderCount == 1 ? .green : (reminderCount <= 3 ? .yellow : .red)
                    ZStack {
                        Circle()
                            .fill(circleColor)
                            .frame(width: 20, height: 20)
                        Text("\(Calendar.current.component(.day, from: date))")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.primary)
                    }
                } else {
                    Text("\(Calendar.current.component(.day, from: date))")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.primary)
                        .frame(width: 20, height: 20)
                }

                if (zoomScale > 1.2 || isReminderViewOn) && !reminders.isEmpty {
                    reminderList(for: reminders)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 4)
                .stroke(Color.gray.opacity(0.3), lineWidth: 0.5)
        )
    }

    private func reminderList(for reminders: [CalendarReminder]) -> some View {
        VStack(spacing: 1) {
            ForEach(Array(reminders.prefix(min(3, reminders.count))), id: \.id) { reminder in
                if reminderData(for: reminder) != nil {
                    NavigationLink(
                        destination: RemindersScreen(
                            cur_screen: $cur_screen,
                            DatabaseMock: $DatabaseMock,
                            filterPeriod: "today",
                            dayFilteredDay: reminder.date,
                            firestoreManager: firestoreManager
                        )
                    ) {
                        Text(reminder.title)
                            .font(.system(size: 8))
                            .foregroundColor(.white)
                            .padding(.horizontal, 2)
                            .padding(.vertical, 1)
                            .background(RoundedRectangle(cornerRadius: 2).fill(Color.blue))
                            .lineLimit(1)
                    }
                } else {
                    Text(reminder.title)
                        .font(.system(size: 8))
                        .foregroundColor(.white)
                        .padding(.horizontal, 2)
                        .padding(.vertical, 1)
                        .background(RoundedRectangle(cornerRadius: 2).fill(Color.gray))
                        .lineLimit(1)
                }
            }
            if reminders.count > 3 {
                Text("+\(reminders.count - 3)")
                    .font(.system(size: 6))
                    .foregroundColor(.secondary)
            }
        }
    }
}

struct WeekDayCellView: View {
    let date: Date
    let reminders: [CalendarReminder]
    let cellWidth: CGFloat
    let cellHeight: CGFloat
    @Binding var cur_screen: Screen
    @Binding var DatabaseMock: Database
    let firestoreManager: FirestoreManager

    // Helper to safely fetch ReminderData for a normalized date
    private func reminderData(for reminder: CalendarReminder) -> ReminderData? {
        let normalizedDate = normalizeDate(reminder.date)
        if let userReminders = DatabaseMock.users[1] {
            return userReminders.first(where: {
                normalizeDate($0.value.date) == normalizedDate && $0.value.title == reminder.title
            })?.value
        }
        return nil
    }

    var body: some View {
        VStack(spacing: 4) {
            Text("\(Calendar.current.component(.day, from: date))")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.primary)

            ScrollView {
                VStack(spacing: 2) {
                    ForEach(reminders) { reminder in
                        ReminderCell(
                            reminder: reminder,
                            reminderData: reminderData(for: reminder),
                            cur_screen: $cur_screen,
                            DatabaseMock: $DatabaseMock,
                            firestoreManager: firestoreManager
                        )
                    }
                }
            }
        }
        .frame(width: cellWidth, height: cellHeight)
        .background(
            RoundedRectangle(cornerRadius: 4)
                .stroke(Color.gray.opacity(0.3), lineWidth: 0.5)
        )
        .padding(1)
    }
}

/// Extracted subview for clarity and compile speed
struct ReminderCell: View {
    let reminder: CalendarReminder
    let reminderData: ReminderData?
    @Binding var cur_screen: Screen
    @Binding var DatabaseMock: Database
    let firestoreManager: FirestoreManager

    var body: some View {
        Group {
            if let reminderData = reminderData {
                NavigationLink(
                    destination: EditReminderScreen(
                        cur_screen: $cur_screen,
                        DatabaseMock: $DatabaseMock,
                        reminder: Binding(
                            get: { reminderData },
                            set: { updated in
                                let normalizedDate = normalizeDate(reminder.date)
                                if let userReminders = DatabaseMock.users[1] {
                                    if let key = userReminders.first(where: {
                                        normalizeDate($0.value.date) == normalizedDate && $0.value.title == reminder.title
                                    })?.key {
                                        DatabaseMock.users[1]?[key] = updated
                                    }
                                }
                            }
                        ),
                        firestoreManager: firestoreManager
                    )
                ) {
                    Text(reminder.title)
                        .font(.system(size: 10))
                        .foregroundColor(.white)
                        .padding(.horizontal, 4)
                        .padding(.vertical, 2)
                        .background(RoundedRectangle(cornerRadius: 4).fill(Color.blue))
                        .lineLimit(2)
                }
            } else {
                Text(reminder.title)
                    .font(.system(size: 10))
                    .foregroundColor(.white)
                    .padding(.horizontal, 4)
                    .padding(.vertical, 2)
                    .background(RoundedRectangle(cornerRadius: 4).fill(Color.gray))
                    .lineLimit(2)
            }
        }
    }
}
