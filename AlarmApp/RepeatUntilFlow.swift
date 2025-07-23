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
    @State var selectedDate: Date
    @Binding var repeatUntil: String
    @State private var repeatUntilOptionSelected: String
    //define a string variable to use to check if specific date is pressed
    
    
    init(title: String, cur_screen: Binding<Screen>, DatabaseMock: Binding<Database>, repeatUntil: Binding<String>) {
        self.title = title
        self._cur_screen = cur_screen
        self._DatabaseMock = DatabaseMock
        self._repeatUntil = repeatUntil
        self._repeatUntilOptionSelected = State(initialValue: "")
        if _repeatUntil.wrappedValue != "Forever" {
            self.selectedDate = createDateFromText(dateString: repeatUntil.wrappedValue)
        } else {
            self.selectedDate = Date()
        }
       
    }

    var body: some View {
        VStack(spacing: 20) {
            Text(title)
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top)

            VStack(spacing: 0) {
                ForEach(["Forever", "Specific Date"], id: \.self) { option in
                    Button(action: {
                        repeatUntilOptionSelected = option
                    }) {
                        HStack {
                            Text(option)
                                .foregroundColor(.black)
                                .font(.title3)
                                .padding(.leading)
                            Spacer()
                            if repeatUntilOptionSelected == option {
                                Image(systemName: "checkmark")
                                    .font(.title)
                                    .foregroundColor(Color(red: 0.0, green: 1, blue: 0.0))
                                    .padding(.trailing)
                            }
                        } //HStack ending
                        .padding(.vertical, 18)
                    }
                    Divider()
                        .background(Color.gray)
                        .padding(.horizontal, 20)
                }
            }
            .background(Color.blue.opacity(0.7))
            .cornerRadius(12)
            .padding(.horizontal)

            // CALENDAR
            if repeatUntilOptionSelected == "Specific Date" {
                DatePicker(
                    "Select Date",
                    selection: $selectedDate,
                    displayedComponents: [.date]
                )
                .datePickerStyle(.graphical)
                .padding()
            }
            
            Spacer()

            //DONE BUTTON
            Button(action: {
                if repeatUntilOptionSelected == "Specific Date" {
                    repeatUntil = createTextFromDate(date: selectedDate)
                } else {
                    repeatUntil = repeatUntilOptionSelected
                }

                
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
            
            
            .onAppear {
                if repeatUntil == "Forever" {
                    repeatUntilOptionSelected = repeatUntil
                } else {
                    repeatUntilOptionSelected = "Specific Date"
                }
            }

            NavigationBarExperience(cur_screen: $cur_screen, DatabaseMock: $DatabaseMock)
        }
    }
}
