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
            //Top bar with notification bell and create reminder button
            HStack {
                //NotificationBellExperience(cur_screen: $cur_screen, DatabaseMock: $DatabaseMock)
                    //.padding(.trailing, 10)
                SettingsExperience(cur_screen: $cur_screen, DatabaseMock: $DatabaseMock)
                Spacer()
                CreateReminderExperience(cur_screen: $cur_screen, DatabaseMock: $DatabaseMock)
            }
            //.padding(.horizontal)
            //.frame(maxWidth: .infinity, alignment: .topTrailing)
        }
        
        //"Welcome [user]" & today's date
        WelcomeExperience()
        
        //Displays today's reminders/"No Pending Tasks"
        TodayRemindersExperience(cur_database: $DatabaseMock, cur_screen: $cur_screen, isHideCompletedReminders: isHideCompletedReminders)
            .padding(.bottom)
        
        VStack {
            Toggle("Hide Completed Reminders", isOn: $isHideCompletedReminders)
                .font(.title3)
                .padding()
        }
        
        .onAppear {
            cur_screen = .HomeScreen
        }
        
        VStack {
            NavigationBarExperience(cur_screen: $cur_screen, DatabaseMock: $DatabaseMock)
        }
            
        //.padding(.bottom, 270)
        
    } //body ending
}
