//
//  FilteringReminders.swift
//  AlarmApp
//
//  Created by Adheesh Bhat on 6/17/25.
//

import SwiftUI

// ↓ REMINDER FILTERS ↓

func filterRemindersForToday(userData: [Date: ReminderData]) -> [Date: ReminderData] {
    let calendar = Calendar.current
    let today = Date()
    let startOfDay = calendar.startOfDay(for: today)
    let endOfDay = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: startOfDay)!
    
    return userData.filter { (date, _) in
            return date >= startOfDay && date <= endOfDay
    }
}

func filterRemindersForWeek(userData: [Date: ReminderData]) -> [Date: ReminderData] {
    let calendar = Calendar.current
    let today = Date()
    //(start of the week always begins on Sunday in this case) RAISES SAME QUESTION AS FOR MONTH FILTER
    let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today))!
    var endOfWeek = calendar.date(byAdding: .day, value: 6, to: startOfWeek)!
    endOfWeek = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: endOfWeek)!
    
    return userData.filter { (date, _) in
        return date >= startOfWeek && date <= endOfWeek
    }
}


//DOES CURRENT MONTH MEAN ex. MAR 1 - MAR 31 or ex. MAR 30 - APR 30?
    //Today's date is at the top of the page, and scroll up/down from MAR 1 - MAR 31, swipe left/right for next/previous month
func filterRemindersForMonth(userData: [Date: ReminderData]) -> [Date: ReminderData] {
    let calendar = Calendar.current
    let today = Date()
    let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: today))!
    let endOfMonth = calendar.date(byAdding: .month, value: 1, to: startOfMonth)!
    
    return userData.filter { (date, _) in
        return date >= startOfMonth && date <= endOfMonth
    }
}

//--------------------------------------------------------------- 1

//Returns reminders based on day, week, or month filter
func showAllReminders(database: Binding<Database>, userID: Int, period: String = "all", showEditButton: Bool = false, showDeleteButton: Bool = false) -> some View {
    let userData = database.wrappedValue.users[userID] ?? [:]
    
    let filteredUserData: [Date: ReminderData]
    if period == "today" {
        filteredUserData = filterRemindersForToday(userData: userData)
    } else if period == "week" {
        filteredUserData = filterRemindersForWeek(userData: userData)
    } else if period == "month" {
        filteredUserData = filterRemindersForMonth(userData: userData)
    } else {
        filteredUserData = userData
    }
    
    let dateFormatter = DateFormatter()
        //can change to .short, .medium, or .long format
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
    
    return VStack {
        ForEach(filteredUserData.keys.sorted(), id: \.self) { date in
            if let reminder = filteredUserData[date] {
                HStack {
                    ReminderRow(
                        title: getTitle(reminder: reminder),
                        time: getTimeFromReminder(reminder: reminder),
                        date: getDayFromReminder(reminder: reminder),
                        reminder: Binding(
                            get: { database.wrappedValue.users[userID]![date]! },
                            set: { database.wrappedValue.users[userID]![date]! = $0 }
                        ),
                        showEditButton: showEditButton,
                        showDeleteButton: showDeleteButton,
                        database: database,
                        userID: userID,
                        dateKey: date
                    )
                    
                    //Show past reminders that have already been completed
                    
                } //HStack ending
                //.padding()
            }// if statement ending
        } //ForEach() ending
    } //VStack ending

}

//----------------------------------------------------------------- 2


func showIncompleteReminders(database: Binding<Database>, userID: Int, period: String = "all", showEditButton: Bool = false, showDeleteButton: Bool = false) -> some View {
    let userData = database.wrappedValue.users[userID] ?? [:]
    
    let filteredUserData: [Date: ReminderData]
    if period == "today" {
        filteredUserData = filterRemindersForToday(userData: userData)
    } else if period == "week" {
        filteredUserData = filterRemindersForWeek(userData: userData)
    } else if period == "month" {
        filteredUserData = filterRemindersForMonth(userData: userData)
    } else {
        filteredUserData = userData
    }
    
    let dateFormatter = DateFormatter()
        //can change to .short, .medium, or .long format
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short

    //let incompleteReminders = filteredUserData.filter { $0.value.isComplete != true }

    return VStack {
        ForEach(filteredUserData.keys.sorted(), id: \.self) { date in
            if let reminder = filteredUserData[date], reminder.isComplete != true {
                HStack {

                    ReminderRow(
                        title: getTitle(reminder: reminder),
                        time: getTimeFromReminder(reminder: reminder),
                        date: getDayFromReminder(reminder: reminder),
                        reminder: Binding(
                            get: { database.wrappedValue.users[userID]![date]! },
                            set: { database.wrappedValue.users[userID]![date]! = $0 }
                        ),
                        showEditButton: showEditButton,
                        showDeleteButton: showDeleteButton,
                        database: database,
                        userID: userID,
                        dateKey: date
                    ) //ReminderRow ending
                } //HStack ending
                //.padding()
            } // if statement ending
        } //ForEach() ending
    } //VStack ending
}


//----------------------------------------------------------------- 3


func formattedReminders(database: Binding<Database>, userID: Int, period: String = "all", showEditButton: Bool = true, showDeleteButton: Bool = false) -> some View {
    let userData = database.wrappedValue.users[userID] ?? [:]
    
    let filteredUserData: [Date: ReminderData]
    if period == "today" {
        filteredUserData = filterRemindersForToday(userData: userData)
    } else if period == "week" {
        filteredUserData = filterRemindersForWeek(userData: userData)
    } else if period == "month" {
        filteredUserData = filterRemindersForMonth(userData: userData)
    } else {
        filteredUserData = userData
    }
    
    let dateFormatter = DateFormatter()
        //can change to .short, .medium, or .long format
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
    
    return VStack {
        ForEach(filteredUserData.keys.sorted(), id: \.self) { date in
            if let reminder = filteredUserData[date] {
                HStack {
                    ReminderRow(
                        title: getTitle(reminder: reminder),
                        time: getTimeFromReminder(reminder: reminder),
                        date: getMonthFromReminder(reminder: reminder),
                        reminder: Binding(
                            get: { database.wrappedValue.users[userID]![date]! },
                            set: { database.wrappedValue.users[userID]![date]! = $0 }
                        ),
                        showEditButton: showEditButton,
                        showDeleteButton: showDeleteButton,
                        database: database,
                        userID: userID,
                        dateKey: date
                    )

                } //HStack ending
                //.padding()
            }// if statement ending
        } //ForEach() ending
    } //VStack ending

}
