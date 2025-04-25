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
    //let dateString = "2025-03-13 09:20:00"
    
    if let date = format.date(from: dateString) {
        return date
    } else {
        print("Invalid date format.")
    }
    
    //if let date = format.date(from: dateString) {
        //return date
    //}
    return Date.now
}



func getUserData(cur_database: Database, userID: Int) -> [Date: ReminderData] {
    return cur_database.users[userID] ?? [:]
}

func getReminderFromDate(userData: [Date: ReminderData], date: Date) -> ReminderData {
    return userData[date] ?? ReminderData(ID: 1, date: createDate(year: 2025, month: 1, day: 1, hour: 1, minute: 1, second: 1), description: "1/1/2025", repeatSettings: RepeatSettings(repeat_type: "None"))
}

func getDescriptionFromReminder(reminder: ReminderData) -> String {
    return reminder.description
}

func getReminderDateFromReminder(reminder: ReminderData) -> Date {
    return reminder.date
}

func getRepeatTypeFromReminder(reminder: ReminderData) -> String {
    return reminder.repeatSettings.repeat_type
}


func getMaxRepeatDateFromReminder(reminder: ReminderData) -> Date {
    return reminder.repeatSettings.repeat_until_date ?? Date.now
}

func getRepeatIntervalsFromReminder(reminder: ReminderData) -> CustomRepeatType {
    return reminder.repeatSettings.repeatIntervals ?? CustomRepeatType(days: "Monday", weeks: [0], months: [0])
}



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

//Returns reminders based on day, week, or month filter
func showAllReminders(userData: [Date: ReminderData], period: String = "all") -> some View {
    
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
                    Text(dateFormatter.string(from: reminder.date))
                    Text(reminder.description)
                    
                    //Change this function so that all shown reminders are only "today's" reminders
                    //Add parameter that allows me to use the same function for week's/month's/day's reminders
                    //Modify show all reminders function for month's/week's/day's reminders
                    
                    //Show past reminders that have already been completed
                    
                } //HStack ending
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 1))
            }// if statement ending
        } //ForEach() ending
    } //VStack ending

    
}
