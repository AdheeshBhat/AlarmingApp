//
//  FilteringReminders.swift
//  AlarmApp
//
//  Created by Adheesh Bhat on 6/17/25.
//

import SwiftUI

// ↓ REMINDER FILTERS ↓

func filterRemindersForToday(userData: [Date: ReminderData], filteredDay: Date?) -> [Date: ReminderData] {
    let calendar = Calendar.current
    let today = Date()
    var startOfDay = calendar.startOfDay(for: today)
    if filteredDay != nil {
        startOfDay = calendar.startOfDay(for: filteredDay!)
    }
    let endOfDay = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: startOfDay)!
    
    return userData.filter { (_, reminder) in
        let reminderDate = reminder.date
        return reminderDate >= startOfDay && reminderDate <= endOfDay
    }
}

func filterRemindersForWeek(userData: [Date: ReminderData], filteredDay: Date?) -> [Date: ReminderData] {
    let calendar = Calendar.current
    let today = Date()
    //(start of the week always begins on Sunday in this case) RAISES SAME QUESTION AS FOR MONTH FILTER
    var startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today))!
    if filteredDay != nil {
        startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: filteredDay!))!
    }
    var endOfWeek = calendar.date(byAdding: .day, value: 6, to: startOfWeek)!
    endOfWeek = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: endOfWeek)!
    
    return userData.filter { (_, reminder) in
        let reminderDate = reminder.date
        return reminderDate >= startOfWeek && reminderDate <= endOfWeek
    }
}


//DOES CURRENT MONTH MEAN ex. MAR 1 - MAR 31 or ex. MAR 30 - APR 30?
    //Today's date is at the top of the page, and scroll up/down from MAR 1 - MAR 31, swipe left/right for next/previous month
func filterRemindersForMonth(userData: [Date: ReminderData], filteredDay: Date?) -> [Date: ReminderData] {
    let calendar = Calendar.current
    let today = Date()
    var startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: today))!
    if filteredDay != nil {
        startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: filteredDay!))!
    }

    let endOfMonth = calendar.date(byAdding: .month, value: 1, to: startOfMonth)!
    
    return userData.filter { (_, reminder) in
        let reminderDate = reminder.date
        return reminderDate >= startOfMonth && reminderDate <= endOfMonth
    }
}

//--------------------------------------------------------------- 1

//Returns reminders based on day, week, or month filter
func showAllReminders(database: Binding<Database>, userID: Int, period: String, cur_screen: Binding<Screen>, showEditButton: Bool = false, showDeleteButton: Bool = false, filteredDay: Date?, firestoreManager: FirestoreManager, userData: [Date: ReminderData]) -> some View {
    //let userData = database.wrappedValue.users[userID] ?? [:]
    
    let filteredUserData: [Date: ReminderData]
    if period == "today" {
        filteredUserData = filterRemindersForToday(userData: userData, filteredDay: filteredDay)
    } else if period == "week" {
        filteredUserData = filterRemindersForWeek(userData: userData, filteredDay: filteredDay)
    } else if period == "month" {
        filteredUserData = filterRemindersForMonth(userData: userData, filteredDay: filteredDay)
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
                        cur_screen: cur_screen,
                        title: getTitle(reminder: reminder),
                        time: getTimeFromReminder(reminder: reminder),
                        reminderDate: getDayFromReminder(reminder: reminder),
                        reminder: reminder,
                        showEditButton: showEditButton,
                        showDeleteButton: showDeleteButton,
                        database: database,
                        userID: userID,
                        dateKey: date,
                        firestoreManager: firestoreManager
                        //pass down date as a reminderID all the way down to editReminderScreen and make setReminder take in a date parameter
                        //when calling setReminder in EditReminderScreen save button, pass in reminderID date
                        //reminderID: date
                    )
                    
                    //Show past reminders that have already been completed
                    
                } //HStack ending
                //.padding()
            }// if statement ending
        } //ForEach() ending
    } //VStack ending

}

//----------------------------------------------------------------- 2


func showIncompleteReminders(database: Binding<Database>, userID: Int, period: String, cur_screen: Binding<Screen>, showEditButton: Bool = false, showDeleteButton: Bool = false, filteredDay: Date?, firestoreManager: FirestoreManager, userData: [Date: ReminderData]) -> some View {
    //let userData = database.wrappedValue.users[userID] ?? [:]
    
    let filteredUserData: [Date: ReminderData]
    if period == "today" {
        filteredUserData = filterRemindersForToday(userData: userData, filteredDay: filteredDay)
    } else if period == "week" {
        filteredUserData = filterRemindersForWeek(userData: userData, filteredDay: filteredDay)
    } else if period == "month" {
        filteredUserData = filterRemindersForMonth(userData: userData, filteredDay: filteredDay)
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
                        cur_screen: cur_screen,
                        title: getTitle(reminder: reminder),
                        time: getTimeFromReminder(reminder: reminder),
                        reminderDate: getDayFromReminder(reminder: reminder),
                        reminder: reminder,
                        showEditButton: showEditButton,
                        showDeleteButton: showDeleteButton,
                        database: database,
                        userID: userID,
                        dateKey: date,
                        firestoreManager: firestoreManager
                    ) //ReminderRow ending
                } //HStack ending
                //.padding()
            } // if statement ending
        } //ForEach() ending
    } //VStack ending
}


//----------------------------------------------------------------- 3


func formattedReminders(database: Binding<Database>, userID: Int, period: String, cur_screen: Binding<Screen>, showEditButton: Bool = true, showDeleteButton: Bool = false, filteredDay: Date?, firestoreManager: FirestoreManager, userData: [Date: ReminderData]) -> some View {
    //let userData = database.wrappedValue.users[userID] ?? [:]
    
    let filteredUserData: [Date: ReminderData]
    if period == "today" {
        filteredUserData = filterRemindersForToday(userData: userData, filteredDay: filteredDay)
    } else if period == "week" {
        filteredUserData = filterRemindersForWeek(userData: userData, filteredDay: filteredDay)
    } else if period == "month" {
        filteredUserData = filterRemindersForMonth(userData: userData, filteredDay: filteredDay)
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
                        cur_screen: cur_screen,
                        title: getTitle(reminder: reminder),
                        time: getTimeFromReminder(reminder: reminder),
                        reminderDate: getMonthFromReminder(reminder: reminder),
                        reminder: reminder,
                        showEditButton: showEditButton,
                        showDeleteButton: showDeleteButton,
                        database: database,
                        userID: userID,
                        dateKey: date,
                        firestoreManager: firestoreManager
                    )

                } //HStack ending
                //.padding()
            }// if statement ending
        } //ForEach() ending
    } //VStack ending

}
