//
//  ContentView.swift
//  Alarm App

//  Created by Adheesh Bhat on 1/9/25.
//

import SwiftUI

//create functions for all texts on the screen (ex. one function for "welcome and date")
enum Screen {
    case HomeScreen, RemindersScreen, NotificationsScreen, EditScreen, CreateReminderScreen
}

struct ContentView: View {
    @Environment(\.presentationMode) private var
        presentationMode: Binding<PresentationMode>
    @State public var cur_screen: Screen = .HomeScreen
    
    @State public var DatabaseMock =
                        //** Key is date on which the reminder is created
    Database(users: [1: [createDate(year: 2025, month: 1, day: 22, hour: 11, minute: 1, second: 1):
                                                //Date on which the reminders should trigger
                         ReminderData(ID: 1, date: createDate(year: 2025, month: 1, day: 22, hour: 11, minute: 1, second: 1), title: "Pay Utility Bill", description: "4/1/2025", repeatSettings: RepeatSettings(repeat_type: "None", repeat_until_date: "Specific Date"), priority: "Low", isComplete: true, author: "user", isLocked: false),
                         createDate(year: 2025, month: 7, day: 22, hour: 10, minute: 1, second: 1):
                            ReminderData(ID: 1, date: createDate(year: 2025, month: 7, day: 22, hour: 10, minute: 1, second: 1), title: "Make Doctor's Appointment",description: "3/31/2025", repeatSettings: RepeatSettings(repeat_type: "Daily", repeat_until_date: "Specific Date"), priority: "Low", isComplete: false, author: "user", isLocked: false),
                         createDate(year: 2025, month: 7, day: 22, hour: 9, minute: 1, second: 1):
                            ReminderData(ID: 1, date: createDate(year: 2025, month: 7, day: 22, hour: 9, minute: 1, second: 1), title: "Take Out Trash", description: "4/2/2025", repeatSettings: RepeatSettings(repeat_type: "Daily", repeat_until_date: "2025-07-23"), priority: "High", isComplete: false, author: "user", isLocked: false),
                         createDate(year: 2025, month: 7, day: 23, hour: 6, minute: 1, second: 1):
                            ReminderData(ID: 1, date: createDate(year: 2025, month: 7, day: 23, hour: 6, minute: 1, second: 1), title: "Pick up Groceries", description: "4/15/2025", repeatSettings: RepeatSettings(repeat_type: "None", repeat_until_date: "Specific Date"), priority: "Low", isComplete: false, author: "user", isLocked: false),
                         createDate(year: 2025, month: 7, day: 23, hour: 7, minute: 1, second: 1):
                            ReminderData(ID: 1, date: createDate(year: 2025, month: 7, day: 23, hour: 7, minute: 1, second: 1), title: "Water the Plants", description: "4/16/2025", repeatSettings: RepeatSettings(repeat_type: "None", repeat_until_date: "Specific Date"), priority: "Low", isComplete: false, author: "user", isLocked: false),
                         createDate(year: 2025, month: 8, day: 5, hour: 8, minute: 1, second: 1):
                            ReminderData(ID: 1, date: createDate(year: 2025, month: 8, day: 5, hour: 8, minute: 1, second: 1), title: "Example Title 1", description: "5/11/2025", repeatSettings: RepeatSettings(repeat_type: "None", repeat_until_date: "Specific Date"), priority: "Low", isComplete: false, author: "user", isLocked: false),
                         createDate(year: 2025, month: 9, day: 10, hour: 1, minute: 1, second: 1):
                            ReminderData(ID: 1, date: createDate(year: 2025, month: 9, day: 10, hour: 1, minute: 1, second: 1), title: "Example Title 2", description: "5/19/2025", repeatSettings: RepeatSettings(repeat_type: "None", repeat_until_date: "Specific Date"), priority: "Low", isComplete: false, author: "user", isLocked: false)],
                     2: [Date.now:
                            ReminderData(ID: 2, date: Date.now, title: "title reminder", description: "Test description 2", repeatSettings: RepeatSettings(repeat_type: "None", repeat_until_date: "Specific Date"), priority: "Low", isComplete: false, author: "user", isLocked: false)]])
    
    
    

    var body: some View {
        
        NavigationStack {
            HomeView(DatabaseMock: $DatabaseMock, cur_screen: $cur_screen)
        
        }
        
        .onAppear {
            requestNotificationPermission()
        }
    } //Body ending
        
} //Content View ending

#Preview {
    ContentView()
}
