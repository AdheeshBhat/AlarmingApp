//
//  Today'sRemindersExperience.swift
//  Alarm App
//
//  Created by Adheesh Bhat on 3/31/25.
//
import SwiftUI

func filterReminders(userData: [Date: ReminderData], period: String, filteredDay: Date?) -> [Date: ReminderData] {
    switch period {
    case "today":
        return filterRemindersForToday(userData: userData, filteredDay: filteredDay)
    case "week":
        return filterRemindersForWeek(userData: userData, filteredDay: filteredDay)
    case "month":
        return filterRemindersForMonth(userData: userData, filteredDay: filteredDay)
    default:
        return userData
    }
}



func TodayRemindersExperience(cur_database: Binding<Database>, cur_screen: Binding<Screen>, isHideCompletedReminders: Bool) -> some View {
    
    let userID = 1
    let userData = cur_database.wrappedValue.users[userID] ?? [:]
    let filteredReminders = filterReminders(userData: userData, period: "today", filteredDay: nil)
    let visibleReminders = isHideCompletedReminders ? filteredReminders.filter { !$0.value.isComplete } : filteredReminders

    return VStack {
        
        Text("Today's Reminders")
            .font(.title)
            .underline()
        
        //VStack {
        
        if visibleReminders.isEmpty {
            Spacer()
            Text("No Pending Tasks! 🙂")
                .font(.title)
                .foregroundColor(.primary)
            Spacer()
        } else {
            ScrollView {
                if isHideCompletedReminders {
                    showIncompleteReminders(database: cur_database, userID: 1, period: "today", cur_screen: cur_screen, showEditButton: false, showDeleteButton: false, filteredDay: nil)
                }
                else {
                    showAllReminders(database: cur_database, userID: 1, period: "today", cur_screen: cur_screen, showEditButton: false, showDeleteButton: false, filteredDay: nil)
                }
            }
            .background(RoundedRectangle(cornerRadius: 12).stroke(Color.primary, lineWidth: 2))
            .padding(.horizontal)
            //}
        }
        
        Spacer()

    }
    //.padding(10)
    //.padding(.bottom, 270)
    //UIScreen.main.bounds.width * 0.1
    
    //find alternatives for padding and hard coded values

}

