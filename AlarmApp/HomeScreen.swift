//
//  HomeScreen.swift
//  Alarm App
//
//  Created by Adheesh Bhat on 4/10/25.
//

import SwiftUI

struct HomeView: View {
    @Binding var cur_screen: Screen
    @State var isHideCompletedReminders : Bool = false
    let firestoreManager: FirestoreManager
    
    var body: some View {
        VStack {
            //Top bar with notification bell and create reminder button
            HStack {

                SettingsExperience(cur_screen: $cur_screen, firestoreManager: firestoreManager)
                Spacer()
                CreateReminderExperience(cur_screen: $cur_screen, firestoreManager: firestoreManager)
            }

        }
        
        //"Welcome [user]" & today's date
        WelcomeExperience()
        
        //Displays today's reminders/"No Pending Tasks"
        TodayRemindersExperience(cur_screen: $cur_screen, isHideCompletedReminders: isHideCompletedReminders, firestoreManager: firestoreManager)
            .padding(.bottom)
        
        VStack {
            Toggle("Hide Completed Reminders", isOn: $isHideCompletedReminders)
                .font(.headline)
                .fontWeight(.medium)
                .padding(16)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                )
                .padding(.horizontal)
        }
        
        .onAppear {
            cur_screen = .HomeScreen
        }
        
        VStack {
            NavigationBarExperience(cur_screen: $cur_screen, firestoreManager: firestoreManager)
        }
            
        
    }
}

