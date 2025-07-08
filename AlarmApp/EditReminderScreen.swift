////
////  EditReminderScreen.swift
////  AlarmApp
////
////  Created by Adheesh Bhat on 6/30/25.
////

import SwiftUI

struct EditReminderScreen: View {
    @State private var date = Date()

    var body: some View {
        DatePicker(
            "",
            selection: $date,
            displayedComponents: [.date]
        )
        .datePickerStyle(.graphical)
        .scaleEffect(x: 1, y: 1.2)
    
    }
}

//    @Binding var cur_screen: Screen
//    @Binding var DatabaseMock: Database
//    @Binding var reminder: ReminderData
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 16) {
//            TextField("Type Reminder Name...", text: $reminder.title)
//                .font(.largeTitle)
//                .foregroundColor(.black)
//                .padding(.horizontal)
//
//            // Description
//            VStack(alignment: .leading, spacing: 8) {
//                Text("Description")
//                    .foregroundColor(.black)
//                    .font(.headline)
//                    .underline()
//                    .padding(.top)
//                    .padding(.leading)
//
//                ZStack(alignment: .topLeading) {
//                    if reminder.description.isEmpty {
//                        Text("Add your description here!")
//                            .foregroundColor(.gray)
//                            .padding(.horizontal, 2)
//                            .padding(.vertical, 2)
//                    }
//
//                    TextEditor(text: $reminder.description)
//                        .frame(height: 100)
//                        .padding(8)
//                        .background(Color.clear)
//                        .cornerRadius(8)
//                        .scrollContentBackground(.hidden)
//                }
//                .padding(.horizontal)
//            }
//            .background(Color.blue.opacity(0.7))
//            .cornerRadius(12)
//            .padding(.horizontal)
//
//            // Date/Time
//            VStack(spacing: 8) {
//                HStack {
//                    Text("Today")
//                        .foregroundColor(.black)
//                        .padding(.leading)
//                    Spacer()
//                    Image(systemName: "chevron.right")
//                        .foregroundColor(.black)
//                        .padding(.trailing)
//                }
//                .frame(height: 40)
//                .background(Color.gray.opacity(0.7))
//                .cornerRadius(8)
//                .padding(.horizontal)
//
//                DatePicker("", selection: $reminder.date, displayedComponents: [.hourAndMinute])
//                    .labelsHidden()
//                    .datePickerStyle(.wheel)
//                    .padding(.horizontal)
//            }
//            .background(Color.blue.opacity(0.7))
//            .cornerRadius(12)
//            .padding(.horizontal)
//
//            // Repeat
//            HStack {
//                Text("Repeat")
//                    .foregroundColor(.black)
//                    .font(.headline)
//                    .underline()
//                    .padding()
//
//                TextField("Type Repeat Setting", text: Binding(
//                    get: { reminder.repeatSettings.repeat_type ?? "" },
//                    set: { reminder.repeatSettings = RepeatSettings(repeat_type: $0) }
//                ))
//                .font(.headline)
//                .foregroundColor(.black)
//                .padding(.horizontal)
//            }
//            .frame(maxWidth: .infinity, alignment: .leading)
//            .background(Color.blue.opacity(0.7))
//            .cornerRadius(12)
//            .padding(.horizontal)
//
//            // Priority
//            HStack {
//                Text("Priority")
//                    .foregroundColor(.black)
//                    .font(.headline)
//                    .underline()
//                    .padding()
//
//                TextField("Type Priority Setting", text: $reminder.priority)
//                    .font(.headline)
//                    .foregroundColor(.black)
//                    .padding(.horizontal)
//            }
//            .frame(maxWidth: .infinity, alignment: .leading)
//            .background(Color.blue.opacity(0.7))
//            .cornerRadius(12)
//            .padding(.horizontal)
//
//            Spacer()
//
//            // Save Button
//            Button(action: {
//
//            }) {
//                Text("Save Changes")
//                    .foregroundColor(.green)
//                    .font(.headline)
//                    .frame(maxWidth: .infinity)
//                    .padding()
//                    .background(Color.blue.opacity(0.7))
//                    .cornerRadius(10)
//                    .padding(.horizontal)
//            }
//
//            NavigationBarExperience(cur_screen: $cur_screen, DatabaseMock: $DatabaseMock)
//        }
//    }
//}
