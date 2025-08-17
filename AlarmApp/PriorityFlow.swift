//
//  PriorityFlow.swift
//  AlarmApp
//
//  Created by Adheesh Bhat on 7/8/25.
//

import SwiftUI

struct PriorityFlow: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var cur_screen: Screen
    @Binding var DatabaseMock: Database
    
    var title: String
    @Binding var priority: String
    @State private var localPriority: String
    @Binding var isLocked: Bool
    @State private var localIsLocked: Bool
    
    

    init(cur_screen: Binding<Screen>, DatabaseMock: Binding<Database>, title: String, priority: Binding<String>, isLocked: Binding<Bool>) {
        self._cur_screen = cur_screen
        self._DatabaseMock = DatabaseMock
        self.title = title
        self._priority = priority
        self._isLocked = isLocked
        // Initialize local state variables
        self._localPriority = State(initialValue: priority.wrappedValue)
        self._localIsLocked = State(initialValue: isLocked.wrappedValue)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(title)
                .font(.largeTitle)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding()

            VStack {
                HStack {
                    Text("Priority")
                        .foregroundColor(.primary)
                        .font(.title3)
                        .underline()
                    Image(systemName: "exclamationmark.triangle")
                        .foregroundColor(.primary)
                        .padding(.leading, 6)
                }
            }
            .frame(maxWidth: .infinity, alignment: .center)

            VStack(spacing: 0) {
                Button(action: {
                    localPriority = "Low"
                }) {
                    HStack {
                        Text("Low")
                            .foregroundColor(.primary)
                            .font(.title3)
                            .padding(.leading)
                        Spacer()
                        if localPriority == "Low" {
                            Image(systemName: "checkmark")
                                .font(.system(size: 30, weight: .bold))
                                .foregroundColor(Color(red: 0.0, green: 1, blue: 0.0))
                                .padding(.trailing)
                        }
                    }
                    .padding(.vertical, 14)
                }

                Divider()
                    .background(Color.gray)
                    .padding(.horizontal, 20)

                Button(action: {
                    localPriority = "High"
                }) {
                    HStack {
                        Text("High")
                            .foregroundColor(.primary)
                            .font(.title3)
                            .padding(.leading)
                        Spacer()
                        if localPriority == "High" {
                            Image(systemName: "checkmark")
                                .font(.system(size: 30, weight: .bold))
                                .foregroundColor(Color(red: 0.0, green: 1, blue: 0.0))
                                .padding(.trailing)
                        }
                    }
                    .padding(.vertical, 14)
                }
                
            }
            .background(Color.blue.opacity(0.7))
            .cornerRadius(12)

            if localPriority == "Low" {
                VStack(alignment: .leading, spacing: 8) {
                    Text("You :").bold()
                    Text("You will be sent a notification.").padding(.vertical).foregroundColor(.secondary)
                    Text("Caretaker :").bold()
                    Text("Your caretaker will be sent a notification after 10 minutes if the reminder is not turned off.").foregroundColor(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(.top)
            } else if localPriority == "High" {
                VStack(alignment: .leading, spacing: 8) {
                    Text("You :").bold()
                    Text("Your alarm will ring.").padding(.vertical).foregroundColor(.secondary)
                    Text("Caretaker :").bold()
                    Text("Your caretaker will be called after 10 minutes if the alarm is not turned off.").foregroundColor(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(.top)
            }

            Button(action: {
                localIsLocked.toggle()
            }) {
                HStack {
                    Text(localIsLocked ? "Locked Reminder" : "Unlocked Reminder")
                        .foregroundColor(.primary)
                        .font(.title3)
                        .padding(.leading)
                    Spacer()
                    Image(systemName: localIsLocked ? "lock.fill" : "lock.open.fill")
                        .font(.title)
                        .foregroundColor(.primary)
                        .padding(.trailing)
                }
                .padding(.vertical, 14)
                .background(Color.blue.opacity(0.7))
                .cornerRadius(12)
            }
            .padding(.top)

            Text(localIsLocked ? "You will not be able to edit this reminder." : "You will be able to edit this reminder.")
                .padding(.top)
                .foregroundColor(.secondary)

            Button(action: {
                priority = localPriority
                isLocked = localIsLocked
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Done")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color(red: 0.0, green: 1, blue: 0.0))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue.opacity(0.7))
                    .cornerRadius(12)
            }
            .padding(.top)

            Spacer()
        } //VStack ending
        .padding()
        
        .onAppear {
            localPriority = priority
            localIsLocked = isLocked
        }
        
        
        VStack {
            NavigationBarExperience(cur_screen: $cur_screen, DatabaseMock: $DatabaseMock)
        }
    } //body ending
}

