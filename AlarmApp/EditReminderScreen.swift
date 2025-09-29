////
////  EditReminderScreen.swift
////  AlarmApp
////
////  Created by Adheesh Bhat on 6/30/25.
////

import SwiftUI
import FirebaseFirestore

struct EditReminderScreen: View {
    @Environment(\.presentationMode) private var presentationMode
    @Binding var cur_screen: Screen
    @Binding var reminder: ReminderData
    @State var showReminderNameAlert: Bool = false
    @State var localTitle: String
    @State var localDescription: String
    @State var localEditScreenPriority: String
    @State var localEditScreenIsLocked: Bool
    @State var localEditScreenRepeatSetting: String
    @State var localEditScreenRepeatUntil: String
    @State var localCustomPatterns: Set<String> = []
    @State private var localDate: Date
    let firestoreManager: FirestoreManager
    let reminderID: String
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: localDate)
    }

    init(cur_screen: Binding<Screen>, reminder: Binding<ReminderData>, firestoreManager: FirestoreManager, reminderID: String) {
        self._cur_screen = cur_screen
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
        self.firestoreManager = firestoreManager
        self.reminderID = reminderID
        
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    TextField("Type Reminder Name...", text: $localTitle)
                        .multilineTextAlignment(.center)
                        .font(.title2)
                        .foregroundColor(.primary)
                        .padding()
                        .background(Color(.systemBackground))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.blue.opacity(0.4), lineWidth: 2)
                        )

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Description")
                            .foregroundColor(.primary)
                            .font(.headline)
                            .fontWeight(.medium)

                        ZStack(alignment: .topLeading) {
                            if localDescription.isEmpty {
                                Text("Add your description here!")
                                    .foregroundColor(.secondary)
                                    .padding(8)
                            }
                            TextEditor(text: $localDescription)
                                .frame(height: 80)
                                .padding(8)
                                .background(Color(.systemBackground))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                                )
                                .scrollContentBackground(.hidden)
                        }
                    }
                    .padding(16)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(12)

                    VStack(spacing: 16) {
                        NavigationLink(
                            destination: DateSelectorScreen(
                                reminderTitle: reminder.title,
                                selectedDate: $localDate,
                                cur_screen: $cur_screen,
                                firestoreManager: firestoreManager
                            )
                        ) {
                            HStack {
                                Text(formattedDate)
                                    .foregroundColor(.primary)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.blue)
                            }
                            .padding()
                            .background(Color(.systemBackground))
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        Divider()
                        
                        DatePicker("", selection: $localDate, displayedComponents: [.hourAndMinute])
                            .labelsHidden()
                            .datePickerStyle(.wheel)
                            .frame(height: 150)
                            .clipped()
                    }
                    .padding(16)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(12)

                    HStack {
                        Image(systemName: "arrow.2.circlepath")
                            .foregroundColor(.blue)
                        Text("Repeat")
                            .foregroundColor(.primary)
                            .font(.headline)
                            .fontWeight(.medium)
                        Spacer()
                        NavigationLink(
                            destination: RepeatSettingsFlow(
                                cur_screen: $cur_screen,
                                title: localTitle,
                                repeatSetting: $localEditScreenRepeatSetting,
                                repeatUntil: $localEditScreenRepeatUntil,
                                customPatterns: $localCustomPatterns,
                                firestoreManager: firestoreManager
                            )
                        ) {
                            HStack {
                                Text(localEditScreenRepeatSetting)
                                    .foregroundColor(.primary)
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.blue)
                            }
                        }
                        .disabled(localTitle.isEmpty)
                        .simultaneousGesture(TapGesture().onEnded {
                            if localTitle.isEmpty {
                                showReminderNameAlert = true
                            }
                        })
                    }
                    .padding(16)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(12)

                    HStack {
                        Image(systemName: "exclamationmark.triangle")
                            .foregroundColor(.blue)
                        Text("Priority")
                            .foregroundColor(.primary)
                            .font(.headline)
                            .fontWeight(.medium)
                        Spacer()
                        NavigationLink(
                            destination: PriorityFlow(cur_screen: $cur_screen, title: localTitle, priority: $localEditScreenPriority, isLocked: $localEditScreenIsLocked, firestoreManager: firestoreManager)
                        ) {
                            HStack {
                                Text(localEditScreenPriority)
                                    .foregroundColor(.primary)
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.blue)
                            }
                        }
                        .disabled(localTitle.isEmpty)
                        .simultaneousGesture(TapGesture().onEnded {
                            if localTitle.isEmpty {
                                showReminderNameAlert = true
                            }
                        })
                    }
                    .padding(16)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(12)

                    //SAVE BUTTON
                    Button(action: {
                        reminder.title = localTitle
                        reminder.description = localDescription
                        reminder.priority = localEditScreenPriority
                        reminder.isLocked = localEditScreenIsLocked
                        reminder.repeatSettings.repeat_type = localEditScreenRepeatSetting
                        reminder.repeatSettings.repeat_until_date = localEditScreenRepeatUntil
                        reminder.date = localDate
                        
                        print("DEBUG: Updating reminder with ID: \(reminderID)")
                        print("DEBUG: New title: \(reminder.title)")
                        firestoreManager.updateReminderFields(dateCreated: reminderID, fields: ["title": reminder.title, "description": reminder.description, "priority": reminder.priority, "isLocked": reminder.isLocked, "repeat_type": reminder.repeatSettings.repeat_type, "repeat_until_date": reminder.repeatSettings.repeat_until_date, "date": Timestamp(date: reminder.date)])
                        
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Save Changes")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(18)
                            .background(Color.green)
                            .cornerRadius(12)
                    }
                    .padding(.top, 10)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            }
            
            NavigationBarExperience(cur_screen: $cur_screen, firestoreManager: firestoreManager)
        }
        .background(Color(.systemBackground))
        .alert("Please type the reminder name first.", isPresented: $showReminderNameAlert) {
            Button("OK", role: .cancel) {}
        }
        .onAppear {
            cur_screen = .EditScreen
        }
    }
}


