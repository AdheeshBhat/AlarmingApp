//
//  Today'sRemindersExperience.swift
//  Alarm App
//
//  Created by Adheesh Bhat on 3/31/25.
//
import SwiftUI

func filterReminders(userData: [Date: ReminderData], period: String) -> [Date: ReminderData] {
    switch period {
    case "today":
        return filterRemindersForToday(userData: userData)
    case "week":
        return filterRemindersForWeek(userData: userData)
    case "month":
        return filterRemindersForMonth(userData: userData)
    default:
        return userData
    }
}



func TodayRemindersExperience(cur_database: Binding<Database>, isHideCompletedReminders: Bool) -> some View {
    
    let userID = 1
    let userData = cur_database.wrappedValue.users[userID] ?? [:]
    let filteredReminders = filterReminders(userData: userData, period: "today")
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
                .foregroundColor(.black)
            Spacer()
        } else {
            ScrollView {
                if isHideCompletedReminders {
                    showIncompleteReminders(database: cur_database, userID: 1, period: "today", showEditButton: false, showDeleteButton: false)
                }
                else {
                    showAllReminders(database: cur_database, userID: 1, period: "today", showEditButton: false, showDeleteButton: false)
                }
            }
            .background(RoundedRectangle(cornerRadius: 12).stroke(Color.black, lineWidth: 2))
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

