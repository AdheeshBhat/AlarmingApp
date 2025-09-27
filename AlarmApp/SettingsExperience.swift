//
//  SettingsExperience.swift
//  AlarmApp
//
//  Created by Adheesh Bhat on 8/6/25.
//

import SwiftUI

struct SettingsExperience: View {
    @Binding var cur_screen: Screen
    let firestoreManager: FirestoreManager
    
    var body: some View {
        NavigationLink(destination: SettingsScreen(cur_screen: $cur_screen, firestoreManager: firestoreManager)) {
            Image(systemName: "gearshape")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.secondary)
                .padding(.horizontal)
        }
        .padding(.leading)
        
        
    } //body ending
}

