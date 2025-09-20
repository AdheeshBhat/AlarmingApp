//
//  SettingsScreen.swift
//  AlarmApp
//
//  Created by Adheesh Bhat on 8/6/25.
//

import SwiftUI
import FirebaseAuth

struct SettingsScreen: View {
    @Environment(\.presentationMode) private var presentationMode
    @Binding var cur_screen: Screen
    @Binding var DatabaseMock: Database
    
    @State private var isDropdownVisible = false
    @State var selectedSound: String = "Chord"
    @State private var showLogoutAlert = false
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
        VStack(alignment: .leading, spacing: 12) {
            Button(action: {
                isDropdownVisible.toggle()
            }) {
                HStack {
                    Text("Alert Sound:")
                        .foregroundColor(.primary)
                        .font(.headline)
                        .fontWeight(.medium)
                    Spacer()
                    Text(selectedSound)
                        .foregroundColor(.primary)
                        .font(.headline)
                    Image(systemName: isDropdownVisible ? "chevron.up" : "chevron.down")
                        .foregroundColor(.blue)
                }
                .padding(16)
            } //Button ending

            if isDropdownVisible {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(["Chord", "Alert"], id: \.self) { sound in
                        Button(action: {
                            selectedSound = sound
                            isDropdownVisible = false
                        }) {
                            Text(sound)
                                .font(.headline)
                                .fontWeight(.medium)
                                .foregroundColor(.primary)
                                .padding(16)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color(.systemBackground))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                                )
                        } //Button ending
                    } //For loop ending
                } //VStack ending
                .padding(.horizontal)
            } //if statement ending
        } //VStack ending (sound picker)
        .background(Color.blue.opacity(0.1))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.blue.opacity(0.3), lineWidth: 1)
        )
        .padding(.horizontal)

        // LOGOUT BUTTON
        Button(action: {
            showLogoutAlert = true
        }) {
            Text("Logout")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(18)
                .background(Color.red)
                .cornerRadius(12)
        }
        .padding(.horizontal)
        .alert("Are you sure?", isPresented: $showLogoutAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Logout", role: .destructive) {
                logout()
            }
        } message: {
            Text("You will be signed out of your account.")
        }
        
        Spacer()
        
        // SAVE SETTINGS BUTTON
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            Text("Save Settings")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(18)
                .background(Color.green)
                .cornerRadius(12)
        }
        .padding(.horizontal)
        
        
        
        .onAppear {
            cur_screen = .SettingsScreen
        }

        VStack {
            NavigationBarExperience(cur_screen: $cur_screen, DatabaseMock: $DatabaseMock, firestoreManager: firestoreManager)
        }
    } //body ending
    
    private func logout() {
        do {
            try Auth.auth().signOut()
            // Navigate back to login screen by dismissing all views
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first {
                window.rootViewController = UIHostingController(rootView: ContentView())
            }
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
}


