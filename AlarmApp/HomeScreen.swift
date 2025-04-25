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
    var body: some View {
        //NavigationStack {
        VStack {
            NotificationBellExperience(cur_screen: $cur_screen, DatabaseMock: $DatabaseMock)
        }
        
        WelcomeExperience()
        TodayRemindersExperience(cur_database: DatabaseMock)
        
        VStack {
            NavigationBarExperience(cur_screen: $cur_screen, DatabaseMock: $DatabaseMock)
        }
            
        //} //Navigation stack ending
        //.padding(.bottom, 270)
        
    } //body ending
}
