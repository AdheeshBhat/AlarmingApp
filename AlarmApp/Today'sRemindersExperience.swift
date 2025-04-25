//
//  Today'sRemindersExperience.swift
//  Alarm App
//
//  Created by Adheesh Bhat on 3/31/25.
//
import SwiftUI

func TodayRemindersExperience(cur_database: Database) -> some View {
    return VStack {
        
        Text("Today's Reminders")
            .font(.headline)
            .underline()
        
        showAllReminders(userData: getUserData(cur_database: cur_database, userID: 1), period: "month")

    }
    .padding(10)
    .padding(.bottom, 270)

}

