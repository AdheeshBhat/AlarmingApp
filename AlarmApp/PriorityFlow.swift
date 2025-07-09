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
    @State private var isLocked: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(title)
                .font(.largeTitle)
                .padding()

            VStack {
                HStack {
                    Text("Priority")
                        .foregroundColor(.black)
                        .font(.title3)
                        .underline()
                    Image(systemName: "exclamationmark.triangle")
                        .foregroundColor(.black)
                        .padding(.leading, 6)
                }
            }
            .frame(maxWidth: .infinity, alignment: .center)

            VStack(spacing: 0) {
                Button(action: {
                    priority = "Low"
                }) {
                    HStack {
                        Text("Low")
                            .foregroundColor(.black)
                            .font(.title3)
                            .padding(.leading)
                        Spacer()
                        if priority == "Low" {
                            Image(systemName: "checkmark")
                                .font(.title)
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
                    priority = "High"
                }) {
                    HStack {
                        Text("High")
                            .foregroundColor(.black)
                            .font(.title3)
                            .padding(.leading)
                        Spacer()
                        if priority == "High" {
                            Image(systemName: "checkmark")
                                .font(.title)
                                .foregroundColor(Color(red: 0.0, green: 1, blue: 0.0))
                                .padding(.trailing)
                        }
                    }
                    .padding(.vertical, 14)
                }
                
            } //VStack ending
            .background(Color.blue.opacity(0.7))
            .cornerRadius(12)

            if priority == "Low" {
                VStack(alignment: .leading, spacing: 8) {
                    Text("You :").bold()
                    Text("You will be sent a notification.").padding(.vertical).foregroundColor(.gray)
                    Text("Caretaker :").bold()
                    Text("Your caretaker will be sent a notification after 10 minutes if the reminder is not turned off.").foregroundColor(.gray)
                }
                .padding(.top)
            } else if priority == "High" {
                VStack(alignment: .leading, spacing: 8) {
                    Text("You :").bold()
                    Text("Your alarm will ring.").padding(.vertical).foregroundColor(.gray)
                    Text("Caretaker :").bold()
                    Text("Your caretaker will be called after 10 minutes if the alarm is not turned off.").foregroundColor(.gray)
                }
                .padding(.top)
            }

            Button(action: {
                isLocked.toggle()
            }) {
                HStack {
                    Text(isLocked ? "Locked Reminder" : "Unlocked Reminder")
                        .foregroundColor(.black)
                        .font(.title3)
                        .padding(.leading)
                    Spacer()
                    Image(systemName: isLocked ? "lock.fill" : "lock.open.fill")
                        .font(.title)
                        .foregroundColor(.black)
                        .padding(.trailing)
                }
                .padding(.vertical, 14)
                .background(Color.blue.opacity(0.7))
                .cornerRadius(12)
            }
            .padding(.top)

            Text(isLocked ? "You will not be able to edit this reminder." : "You will be able to edit this reminder.")
                .padding(.top)
                .foregroundColor(.gray)

            Button(action: {
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
        }
        .padding()
        
        VStack {
            NavigationBarExperience(cur_screen: $cur_screen, DatabaseMock: $DatabaseMock)
        }
    }
}
