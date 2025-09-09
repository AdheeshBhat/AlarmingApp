//
//  SettingsScreen.swift
//  AlarmApp
//
//  Created by Adheesh Bhat on 8/6/25.
//

import SwiftUI

struct SettingsScreen: View {
    @Environment(\.presentationMode) private var presentationMode
    @Binding var cur_screen: Screen
    @Binding var DatabaseMock: Database
    
    @State private var isDropdownVisible = false
    @State var selectedSound: String = "Chord"
    let firestoreManager: FirestoreManager

    

    
    var body: some View {
        //TITLE
        VStack {
            Text("Settings")
                .font(.largeTitle)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top)
        } //VStack ending
        .padding(.bottom)
        
        //Heading
        VStack {
            Text("Account")
                .font(.title)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity, alignment: .leading)
                
        }
        .padding(.horizontal)
        .padding(.bottom)
        
        //Notification Settings
        HStack {
            NotificationBellExperience(cur_screen: $cur_screen, DatabaseMock: $DatabaseMock)
            Text("Notifications")
                .font(.title3)
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(.primary)
             
        }
        .padding(.horizontal)
        .padding(.horizontal)
        
        
        //NOTIFICATION SOUND PICKER
        VStack(alignment: .leading, spacing: 8) {
            Button(action: {
                isDropdownVisible.toggle()
            }) {
                HStack {
                    Text("Alert Sound:")
                        .foregroundColor(.primary)
                        .font(.title3)
                        .underline()
                    Spacer()
                    Text(selectedSound)
                        .foregroundColor(.primary)
                        .font(.title3)
                    Spacer()
                    Image(systemName: isDropdownVisible ? "chevron.up" : "chevron.down")
                        .foregroundColor(.primary)
                }
                .padding(.horizontal)
            } //Button ending

            if isDropdownVisible {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(["Chord", "Alert"], id: \.self) { sound in
                        Button(action: {
                            selectedSound = sound
                            isDropdownVisible = false
                        }) {
                            Text(sound)
                                .font(.title3)
                                .foregroundColor(.primary)
                                .padding(.vertical)
                                .padding(.horizontal)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color(.systemBackground))
                                .cornerRadius(12)
                        } //Button ending
                    } //For loop ending
                } //VStack ending
                .padding(.horizontal)
            } //if statement ending
        } //VStack ending (sound picker)
        .padding(.vertical)
        .padding(.horizontal)
        .background(Color.blue.opacity(0.7))
        .cornerRadius(12)
        .padding(.horizontal)

        Spacer()
        
        // SAVE SETTINGS BUTTON
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            Text("Save Settings")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Color(red: 0.0, green: 1, blue: 0.0))
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue.opacity(0.7))
                .cornerRadius(12)
                .padding(.horizontal)
        }
        
        
        
        .onAppear {
            cur_screen = .SettingsScreen
        }

        VStack {
            NavigationBarExperience(cur_screen: $cur_screen, DatabaseMock: $DatabaseMock, firestoreManager: firestoreManager)
        }
    } //body ending
}

