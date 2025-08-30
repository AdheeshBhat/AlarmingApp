//
//  CreateReminderScreen.swift
//  AlarmApp
//
//  Created by Adheesh Bhat on 5/28/25.
//

import SwiftUI

struct CreateReminderScreen: View {
    @Environment(\.presentationMode) private var presentationMode
    @Binding var cur_screen: Screen
    @Binding var DatabaseMock: Database
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var date: Date = Date()
    @State private var userID: Int = 1
    @State private var repeat_setting: String = "None"
    @State private var repeatUntil: String = "Forever"
    @State private var priority: String = "Low"
    @State private var isComplete: Bool = false
    @State private var author: String = ""
    @State private var isLocked: Bool = false
    @State private var showReminderNameAlert: Bool = false
    @State var selectedSound: String = "Chord"

    var body: some View {
        VStack(alignment: .leading, spacing : 16) {
            //TITLE
            TextField("Type Reminder Name...", text: $title)
                .multilineTextAlignment(.center)
                .font(.largeTitle)
                .foregroundColor(.primary)
                .padding(.horizontal)

            // DESCRIPTION BOX
            VStack(alignment: .leading, spacing: 8) {
                Text("Description")
                    .foregroundColor(.primary)
                    .font(.title3)
                    .underline()
                    .padding(.top)
                    .padding(.leading)
                
                ZStack(alignment: .topLeading) {
                        if description.isEmpty {
                            Text("Add your description here!")
                                .foregroundColor(.white)
                                .padding(.horizontal, 2)
                                .padding(.vertical, 2)
                        }

                        TextEditor(text: $description)
                            .frame(height: 100)
                            .padding(8)
                            .background(Color.clear)
                            .cornerRadius(8)
                            .scrollContentBackground(.hidden)
                    }
                    .padding(.horizontal)
            } //Description Box VStack ending
            .background(Color.blue.opacity(0.7))
            .cornerRadius(12)
            .padding(.horizontal)

            // TIME SELECTOR
            VStack(spacing: 8) {
                NavigationLink(
                    destination: DateSelectorScreen(
                        reminderTitle: title,
                        selectedDate: $date,
                        cur_screen: $cur_screen,
                        DatabaseMock: $DatabaseMock
                    )
                ) {
                    HStack {
                        Text(date, style: .date)
                            .foregroundColor(.primary)
                            .padding(.leading)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.primary)
                            .padding(.trailing)
                    }
                    .frame(height: 40)
                    .background(Color.gray.opacity(0.7))
                    .cornerRadius(8)
                    .padding(.horizontal)
                }
                DatePicker("", selection: $date, displayedComponents: [.hourAndMinute])
                    .labelsHidden()
                    .datePickerStyle(.wheel)
                    .frame(height: 100)
                    .clipped()
                    .padding(.horizontal)
            }
            .background(Color.blue.opacity(0.7))
            .cornerRadius(12)
            .padding(.horizontal)

            
            
            // REPEAT SECTION
            HStack {
                VStack(alignment: .leading) {
                    Text("Repeat")
                        .foregroundColor(.primary)
                        .font(.title3)
                        .underline()
                }
                .padding(.vertical)
                .padding(.leading)
                
                Image(systemName: "arrow.2.circlepath")
                    .foregroundColor(.primary)
                    .padding(.leading, 6)
                
                NavigationLink(
                    destination: RepeatSettingsFlow(
                        cur_screen: $cur_screen,
                        DatabaseMock: $DatabaseMock,
                        title: title,
                        repeatSetting: $repeat_setting,
                        repeatUntil: $repeatUntil
                    )
                ) {
                    Text(repeat_setting)
                        .foregroundColor(.primary)
                        .font(.title3)
                        .padding(.leading, 75)
                }
                .disabled(title.isEmpty)
                .simultaneousGesture(TapGesture().onEnded {
                    if title.isEmpty {
                        showReminderNameAlert = true
                    }
                })

                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.black)
                    .padding(.trailing)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.blue.opacity(0.7))
            .cornerRadius(12)
            .padding(.horizontal)
            .padding(.vertical, 12)
            
            
            
            // PRIORITY SECTION
            HStack {
                VStack(alignment: .leading) {
                    Text("Priority")
                        .foregroundColor(.primary)
                        .font(.title3)
                        .underline()
                }
                .padding(.vertical)
                .padding(.leading)
                
                Image(systemName: "exclamationmark.triangle")
                    .foregroundColor(.primary)
                    .padding(.leading, 6)

                NavigationLink(
                    destination: PriorityFlow(
                        cur_screen: $cur_screen,
                        DatabaseMock: $DatabaseMock,
                        title: title,
                        priority: $priority,
                        isLocked: $isLocked)
                ) {
                    Text(priority)
                        .foregroundColor(.primary)
                        .font(.title3)
                        .padding(.leading, 75)
                }
                .disabled(title.isEmpty)
                .simultaneousGesture(TapGesture().onEnded {
                    if title.isEmpty {
                        showReminderNameAlert = true
                    }
                })

                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.black)
                    .padding(.trailing)
            } //HStack ending
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.blue.opacity(0.7))
            .cornerRadius(12)
            .padding(.horizontal)

            Spacer()

            
            
            // SAVE NEW REMINDER BUTTON
            Button(action: {
                if title.isEmpty {
                    showReminderNameAlert = true
                } else {
                    let reminder = ReminderData(
                        ID: Int.random(in: 1000...9999),
                        //date that user selects for the reminder
                        date: date,
                        title: title,
                        description: description,
                        repeatSettings: RepeatSettings(repeat_type: repeat_setting, repeat_until_date: repeatUntil),
                        priority: priority,
                        isComplete: isComplete,
                        author: author,
                        isLocked: isLocked
                    )
                    let uniqueID = Date.now
                    addToDatabase(database: &DatabaseMock, userID: userID, date: uniqueID, reminder: reminder)
                    presentationMode.wrappedValue.dismiss()
                    setAlarm(dateAndTime: date, title: title, description: description, repeat_setting: reminder.repeatSettings.repeat_type, uniqueDate: uniqueID, soundType: selectedSound)
                }
            }) {
                Text("Save New Reminder")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color(red: 0.0, green: 1, blue: 0.0))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue.opacity(0.7))
                    .cornerRadius(12)
                    .padding(.horizontal)
            }
        } //VStack ending
        
        .alert("Please type the reminder name first.", isPresented: $showReminderNameAlert) {
            Button("OK", role: .cancel) {}
        }
        
        .onAppear {
            cur_screen = .CreateReminderScreen
        }
        
        VStack {
            NavigationBarExperience(cur_screen: $cur_screen, DatabaseMock: $DatabaseMock)
        }
    }
}

