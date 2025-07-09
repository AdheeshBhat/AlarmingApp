//
//  RepeatUntilFlow.swift
//  AlarmApp
//
//  Created by Adheesh Bhat on 7/8/25.
//



import SwiftUI

struct RepeatUntilFlow: View {
    var title: String = "New Reminder"
    @Binding var cur_screen: Screen
    @Binding var DatabaseMock: Database
    @Environment(\.presentationMode) var presentationMode
    @Binding var repeatUntil: String
    @State private var selectedDate: Date = Date()
    
    var body: some View {
        VStack(spacing: 20) {
            Text(title)
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top)

            VStack(spacing: 0) {
                ForEach(["Forever", "Specific Date"], id: \.self) { option in
                    Button(action: {
                        repeatUntil = option
                    }) {
                        HStack {
                            Text(option)
                                .foregroundColor(.black)
                                .font(.title3)
                                .padding(.leading)
                            Spacer()
                            if repeatUntil == option {
                                Image(systemName: "checkmark")
                                    .font(.title)
                                    .foregroundColor(Color(red: 0.0, green: 1, blue: 0.0))
                                    .padding(.trailing)
                            }
                        }
                        .padding(.vertical, 18)
                    }
                    if option == "Forever" {
                        Divider()
                            .background(Color.gray)
                            .padding(.horizontal, 20)
                    }
                }
            }
            .background(Color.blue.opacity(0.7))
            .cornerRadius(12)
            .padding(.horizontal)

            // CALENDAR
            if repeatUntil == "Specific Date" {
                DatePicker(
                    "Select Date",
                    selection: $selectedDate,
                    displayedComponents: [.date]
                )
                .datePickerStyle(.graphical)
                .padding()
            }
            
            Spacer()

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
            .padding(.horizontal)
            .padding(.bottom)

            NavigationBarExperience(cur_screen: $cur_screen, DatabaseMock: $DatabaseMock)
        }
    }
}
