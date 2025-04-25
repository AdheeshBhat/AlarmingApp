//
//  ContentView.swift
//  Alarm App

//  Created by Adheesh Bhat on 1/9/25.
//

import SwiftUI

//create functions for all texts on the screen (ex. one function for "welcome and date")
enum Screen {
    case HomeScreen, RemindersScreen, NotificationsScreen
}

struct ContentView: View {
    @Environment(\.presentationMode) private var
        presentationMode: Binding<PresentationMode>
    @State public var cur_screen: Screen = .HomeScreen
    
    @State public var DatabaseMock =
    Database(users: [1: [createDate(year: 2025, month: 4, day: 1, hour: 11, minute: 1, second: 1):
                            ReminderData(ID: 1, date: createDate(year: 2025, month: 4, day: 1, hour: 11, minute: 1, second: 1), description: "4/1/2025", repeatSettings: RepeatSettings(repeat_type: "None")),
                         createDate(year: 2025, month: 3, day: 31, hour: 1, minute: 1, second: 1):
                            ReminderData(ID: 1, date: createDate(year: 2025, month: 3, day: 31, hour: 1, minute: 1, second: 1), description: "3/31/2025", repeatSettings: RepeatSettings(repeat_type: "None")),
                         createDate(year: 2025, month: 4, day: 2, hour: 1, minute: 1, second: 1):
                            ReminderData(ID: 1, date: createDate(year: 2025, month: 4, day: 2, hour: 1, minute: 1, second: 1), description: "4/2/2025", repeatSettings: RepeatSettings(repeat_type: "None")),
                         createDate(year: 2025, month: 4, day: 15, hour: 1, minute: 1, second: 1):
                            ReminderData(ID: 1, date: createDate(year: 2025, month: 4, day: 15, hour: 1, minute: 1, second: 1), description: "4/15/2025", repeatSettings: RepeatSettings(repeat_type: "None")),
                         createDate(year: 2025, month: 4, day: 16, hour: 1, minute: 1, second: 1):
                            ReminderData(ID: 1, date: createDate(year: 2025, month: 4, day: 16, hour: 1, minute: 1, second: 1), description: "4/16/2025", repeatSettings: RepeatSettings(repeat_type: "None")),
                         createDate(year: 2025, month: 5, day: 11, hour: 1, minute: 1, second: 1):
                            ReminderData(ID: 1, date: createDate(year: 2025, month: 5, day: 11, hour: 1, minute: 1, second: 1), description: "5/11/2025", repeatSettings: RepeatSettings(repeat_type: "None")),
                         createDate(year: 2025, month: 5, day: 19, hour: 1, minute: 1, second: 1):
                            ReminderData(ID: 1, date: createDate(year: 2025, month: 5, day: 19, hour: 1, minute: 1, second: 1), description: "5/19/2025", repeatSettings: RepeatSettings(repeat_type: "None"))],
                     2: [Date.now:
                            ReminderData(ID: 2, date: Date.now, description: "Test description 2", repeatSettings: RepeatSettings(repeat_type: "None"))]])
    
    
    

    var body: some View {
        
        NavigationStack {
            
            HomeView(DatabaseMock: $DatabaseMock, cur_screen: $cur_screen)
            //test commit
            //RemindersScreen(cur_screen: $cur_screen, DatabaseMock: $DatabaseMock)
            //NotificationsScreen(cur_screen: $cur_screen, DatabaseMock: $DatabaseMock)
        
        }
        
        
        
    } //Body ending
} //Content View ending

#Preview {
    ContentView()
}




//Old formatting for reminder on home screen
//            VStack {
//
//                HStack(spacing: 50) {
//                    Text("Take Medication")
//                    Text("05:00 PM")
//
//                }
//                .padding()
//
//                HStack {
//                    Text("Done")
//                        .padding(.trailing, 100)
//                },
//
//            }
//            .padding()
//            .background(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 1))
