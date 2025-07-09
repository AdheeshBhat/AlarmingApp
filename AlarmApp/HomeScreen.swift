//
//  HomeScreen.swift
//  Alarm App
//
//  Created by Adheesh Bhat on 4/10/25.
//

import SwiftUI

struct HomeView: View {
    @Binding var DatabaseMock: Database
    @Binding var cur_screen: Screen
    @State var isHideCompletedReminders : Bool = false
    var body: some View {
        VStack {
            HStack {
                NotificationBellExperience(cur_screen: $cur_screen, DatabaseMock: $DatabaseMock)
                    .padding(.trailing, 10)
                CreateReminderExperience(cur_screen: $cur_screen, DatabaseMock: $DatabaseMock)
            }
            .frame(maxWidth: .infinity, alignment: .topTrailing)

        }
        
        WelcomeExperience()
        TodayRemindersExperience(cur_database: $DatabaseMock, cur_screen: $cur_screen, isHideCompletedReminders: isHideCompletedReminders)
            .padding(.bottom)
        
        VStack {
            Toggle("Hide Completed Reminders", isOn: $isHideCompletedReminders)
                .padding()
        }
        
        VStack {
            NavigationBarExperience(cur_screen: $cur_screen, DatabaseMock: $DatabaseMock)
        }
            
        //.padding(.bottom, 270)
        
    } //body ending
}
