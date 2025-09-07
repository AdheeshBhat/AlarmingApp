//
//  DateSelectorScreen.swift
//  AlarmApp
//
//  Created by Adheesh Bhat on 8/29/25.
//
import SwiftUI

struct DateSelectorScreen: View {
    let reminderTitle: String
    @Binding var selectedDate: Date
    @Binding var cur_screen: Screen
    @Binding var DatabaseMock: Database
    @Environment(\.presentationMode) private var presentationMode
    @State private var localSelectedDate: Date

    init(reminderTitle: String, selectedDate: Binding<Date>, cur_screen: Binding<Screen>, DatabaseMock: Binding<Database>) {
        self.reminderTitle = reminderTitle
        self._selectedDate = selectedDate
        self._cur_screen = cur_screen
        self._DatabaseMock = DatabaseMock
        self._localSelectedDate = State(initialValue: selectedDate.wrappedValue)
    }

    var body: some View {
        VStack(spacing: 24) {
            Text(reminderTitle)
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top)

            DatePicker(
                "Select Date",
                selection: $localSelectedDate,
                displayedComponents: [.date]
            )
            .datePickerStyle(.graphical)
            .labelsHidden()
            .padding()

            Spacer()

            //DONE BUTTON
            Button(action: {
                selectedDate = localSelectedDate
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
        }
        .onAppear {
            cur_screen = .EditScreen
        }
        VStack {
            NavigationBarExperience(cur_screen: $cur_screen, DatabaseMock: $DatabaseMock)
        }
    } //body ending
}
