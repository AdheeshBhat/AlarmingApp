//
//  Util.swift
//  Alarm App
//
//  Created by Adheesh Bhat on 4/1/25.
//

import SwiftUI

func createDate(year: Int, month: Int, day: Int, hour: Int, minute: Int, second: Int) -> Date {
    var calendar = Calendar.current
    calendar.timeZone = TimeZone(identifier: "America/Los_Angeles")!
    let created_date = calendar.date(from: DateComponents(year: year, month: month, day: day, hour: hour, minute: minute, second: second))
    return created_date ?? Date.now
    
}

func createDateFromText(dateString: String) -> Date {
    let format = DateFormatter()
    
    format.dateFormat = "yyyy-MM-dd HH:mm:ss"
    if let date = format.date(from: dateString) {
        return date
    }
    
    print("Invalid date format.")
    return Date.now
}

func createTextFromDate(date: Date) -> String {
    let format = DateFormatter()
    format.dateFormat = "yyyy-MM-dd"
    return format.string(from: date)
}

func createUniqueIDFromDate(date: Date) -> String {
    let format = DateFormatter()
    format.dateFormat = "yyyy-MM-dd HH:mm:ss"
    return format.string(from: date)
}


func getTitle(reminder: ReminderData) -> String {
    return reminder.title
}

func getUserData(cur_database: Database, userID: Int) -> [Date: ReminderData] {
    return cur_database.users[userID] ?? [:]
}

func getReminderFromDate(userData: [Date: ReminderData], date: Date) -> ReminderData {
    return userData[date] ?? ReminderData(ID: 1, date: createDate(year: 2025, month: 1, day: 1, hour: 1, minute: 1, second: 1), title: "undefined", description: "1/1/2025", repeatSettings: RepeatSettings(repeat_type: "None", repeat_until_date: "Specific Date"), priority: "Low", isComplete: false, author: "user", isLocked: false)
}

func getDescriptionFromReminder(reminder: ReminderData) -> String {
    return reminder.description
}

func getDayFromReminder(reminder: ReminderData) -> String {
    let DateFormatter = DateFormatter()
    DateFormatter.dateFormat = "EEEE"
    return DateFormatter.string(from: reminder.date as Date)
}
    
func getTimeFromReminder(reminder: ReminderData) -> String {
    let calendar = Calendar.current
    let hour = calendar.component(.hour, from: reminder.date)
    let minute = calendar.component(.minute, from: reminder.date)
    var minuteString = String(minute)
    if minute < 10 {
        minuteString = "0" + String(minute)
    }
    return String(hour) + ":" + minuteString
}

func getMonthFromReminder(reminder: ReminderData) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MMMM d"
    return dateFormatter.string(from: reminder.date as Date)
    
}

func getDateFromReminder(reminder: ReminderData) -> Date {
    return reminder.date
}

func getRepeatTypeFromReminder(reminder: ReminderData) -> String {
    return reminder.repeatSettings.repeat_type
}

//
//func getMaxRepeatDateFromReminder(reminder: ReminderData) -> Date {
//    return reminder.repeatSettings.repeat_until_date ?? Date.now
//}

func getCurrentDateString() -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "EEEE, MMM d"
    return formatter.string(from: Date())
}

func getRepeatIntervalsFromReminder(reminder: ReminderData) -> CustomRepeatType {
    return reminder.repeatSettings.repeatIntervals ?? CustomRepeatType(days: "Monday", weeks: [0], months: [0])
}


func addToDatabase(database: inout Database, userID: Int, date: Date, reminder: ReminderData) {
    if var userReminders = database.users[userID] {
        userReminders[date] = reminder
        database.users[userID] = userReminders
    } else {
        database.users[userID] = [date: reminder]
    }
}

func deleteFromDatabase(database: inout Database, userID: Int, date: Date) {
    if var userReminders = database.users[userID] {
        userReminders.removeValue(forKey: date)
        database.users[userID] = userReminders
    }
}


func timeAsDate(_ timeString: String) -> Date? {
    let formatter = DateFormatter()
    formatter.dateFormat = "H:mm"
    return formatter.date(from: timeString)
}

func timeAsString(_ time: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "H:mm"
    return formatter.string(from: time)
}

func dayString(from date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "EEEE, MMM d"
    return formatter.string(from: date)
}

func weekString(from date: Date) -> String {
    let calendar = Calendar.current
    let formatter = DateFormatter()
    formatter.dateFormat = "MMM d"
    
    let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: date))!
    let endOfWeek = calendar.date(byAdding: .day, value: 6, to: startOfWeek)!
    
    return "\(formatter.string(from: startOfWeek)) – \(formatter.string(from: endOfWeek))"
}

func monthString(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "LLLL"
    return formatter.string(from: date)
}

func yearString(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy"
    return formatter.string(from: date)
}



