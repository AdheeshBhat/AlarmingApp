////
////  EditReminderScreen.swift
////  AlarmApp
////
////  Created by Adheesh Bhat on 6/30/25.
////

import SwiftUI

struct EditReminderScreen: View {
    @Environment(\.presentationMode) private var presentationMode
    @Binding var cur_screen: Screen
    @Binding var DatabaseMock: Database
    @Binding var reminder: ReminderData
    @State var showReminderNameAlert: Bool = false
    @State var localTitle: String
    @State var localDescription: String
    @State var localEditScreenPriority: String
    @State var localEditScreenIsLocked: Bool
    @State var localEditScreenRepeatSetting: String
    @State var localEditScreenRepeatUntil: String
    @State private var localDate: Date
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: localDate)
    }

    init(cur_screen: Binding<Screen>, DatabaseMock: Binding<Database>, reminder: Binding<ReminderData>) {
        self._cur_screen = cur_screen
        self._DatabaseMock = DatabaseMock
        self._reminder = reminder
        //local variables
        self._localTitle = State(initialValue: reminder.wrappedValue.title)
        self._localDescription = State(initialValue: reminder.wrappedValue.description)
        self._localEditScreenPriority = State(initialValue: reminder.wrappedValue.priority)
        self._localEditScreenIsLocked = State(initialValue: reminder.wrappedValue.isLocked)
        self._localEditScreenRepeatSetting = State(initialValue: reminder.wrappedValue.repeatSettings.repeat_type)
        //HAD TO MAKE REPEAT_UNTIL_DATE A STRING FOR THIS TO WORK -> might need to look into that (was originally a date type)
        self._localEditScreenRepeatUntil = State(initialValue: reminder.wrappedValue.repeatSettings.repeat_until_date)
        self._localDate = State(initialValue: reminder.wrappedValue.date)
        
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            TextField("Type Reminder Name...", text: $localTitle)
                .multilineTextAlignment(.center)
                .font(.largeTitle)
                .foregroundColor(.primary)
                .padding(.horizontal)


            // Description
            VStack(alignment: .leading, spacing: 8) {
                Text("Description")
                    .foregroundColor(.primary)
                    .font(.headline)
                    .underline()
                    .padding(.top)
                    .padding(.leading)

                ZStack(alignment: .topLeading) {
                    if localDescription.isEmpty {
                        Text("Add your description here!")
                            .foregroundColor(.white)
                            .padding(.horizontal, 2)
                            .padding(.vertical, 2)
                    }

                    TextEditor(text: $localDescription)
                        .frame(height: 100)
                        .padding(8)
                        .background(Color.clear)
                        .cornerRadius(8)
                        .scrollContentBackground(.hidden)
                }
                .padding(.horizontal)
            } //VStack ending
            .background(Color.blue.opacity(0.7))
            .cornerRadius(12)
            .padding(.horizontal)

            // Date/Time
            VStack {
                VStack {
                    NavigationLink(
                        destination: DateSelectorScreen(
                            reminderTitle: reminder.title,
                            selectedDate: $localDate,
                            cur_screen: $cur_screen,
                            DatabaseMock: $DatabaseMock
                        )
                    ) {
                        HStack {
                            Text(formattedDate)
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
                        //.padding(.bottom)
                    } //Navigation Link ending
                }
                
                VStack {
                    DatePicker("", selection: $localDate, displayedComponents: [.hourAndMinute])
                        .labelsHidden()
                        .scaleEffect(0.97)
                        .frame(height: 190)
                        .clipped()
                        .datePickerStyle(.wheel)
                }
                
            }
            .background(Color.blue.opacity(0.7))
            .cornerRadius(12)
            .padding(.horizontal)

            // Repeat
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
                        title: localTitle,
                        repeatSetting: $localEditScreenRepeatSetting,
                        repeatUntil: $localEditScreenRepeatUntil
                    )
                ) {
                    Text(localEditScreenRepeatSetting)
                        .foregroundColor(.primary)
                        .font(.title3)
                        .padding(.leading, 75)
                }
                .disabled(localTitle.isEmpty)
                .simultaneousGesture(TapGesture().onEnded {
                    if localTitle.isEmpty {
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

            // Priority
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
                    destination: PriorityFlow(cur_screen: $cur_screen, DatabaseMock: $DatabaseMock, title: localTitle, priority: $localEditScreenPriority, isLocked: $localEditScreenIsLocked)
                ) {
                    Text(localEditScreenPriority)
                        .foregroundColor(.primary)
                        .font(.title3)
                        .padding(.leading, 75)
                }
                .disabled(localTitle.isEmpty)
                .simultaneousGesture(TapGesture().onEnded {
                    if localTitle.isEmpty {
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

            // SAVE CHANGES BUTTON
            Button(action: {
                reminder.title = localTitle
                reminder.description = localDescription
                reminder.priority = localEditScreenPriority
                reminder.isLocked = localEditScreenIsLocked
                reminder.repeatSettings.repeat_type = localEditScreenRepeatSetting
                reminder.repeatSettings.repeat_until_date = localEditScreenRepeatUntil
                reminder.date = localDate
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Save Changes")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color(red: 0.0, green: 1, blue: 0.0))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue.opacity(0.7))
                    .cornerRadius(12)
                    .padding(.horizontal)
            }
            
            .onAppear {
                cur_screen = .EditScreen
            }
            
            VStack {
                NavigationBarExperience(cur_screen: $cur_screen, DatabaseMock: $DatabaseMock)
            }
        } //VStack ending
        .alert("Please type the reminder name first.", isPresented: $showReminderNameAlert) {
            Button("OK", role: .cancel) {}
        }
    } //body ending
}

