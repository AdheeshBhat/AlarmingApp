//
//  SettingsExperience.swift
//  AlarmApp
//
//  Created by Adheesh Bhat on 8/6/25.
//

import SwiftUI

struct SettingsExperience: View {
    @Binding var cur_screen: Screen
    @Binding var DatabaseMock: Database
    
    var body: some View {
        NavigationLink(destination: SettingsScreen(cur_screen: $cur_screen, DatabaseMock: $DatabaseMock)) {
            Image(systemName: "gearshape")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.gray)
                .padding(.horizontal)
        }
        .padding(.leading)
        
        
    } //body ending
}
