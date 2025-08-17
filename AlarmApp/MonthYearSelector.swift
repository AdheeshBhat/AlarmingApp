//
//  MonthYearSelector.swift
//  AlarmApp
//
//  Created by Adheesh Bhat on 8/11/25.
//

import SwiftUI

struct MonthYearSelector: View {
    @Binding var filteredDay: Date?
    @Binding var isEditingMonthYear: Bool
    var currentPeriodText: String

    var body: some View {
        if isEditingMonthYear {
            VStack {
                HStack {
                    // MONTH PICKER
                    Picker("Month", selection: Binding(
                        get: {
                            Calendar.current.component(.month, from: filteredDay ?? Date()) - 1
                        },
                        set: { newValue in
                            let calendar = Calendar.current
                            var components = calendar.dateComponents([.year, .day], from: filteredDay ?? Date())
                            components.month = newValue + 1
                            components.day = 1
                            if let newDate = calendar.date(from: components) {
                                filteredDay = newDate
                            }
                        }
                    )) {
                        ForEach(0..<12) { index in
                            Text(Calendar.current.monthSymbols[index])
                                .font(.title)
                                .tag(index)
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame(maxWidth: .infinity)

                    // YEAR PICKER
                    Picker("Year", selection: Binding(
                        get: {
                            Calendar.current.component(.year, from: filteredDay ?? Date())
                        },
                        set: { newValue in
                            let calendar = Calendar.current
                            var components = calendar.dateComponents([.month, .day], from: filteredDay ?? Date())
                            components.year = newValue
                            components.day = 1
                            if let newDate = calendar.date(from: components) {
                                filteredDay = newDate
                            }
                        }
                    )) {
                        ForEach(2020...2080, id: \.self) { year in
                            Text(String(year))
                                .font(.title)
                                .tag(year)
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame(maxWidth: .infinity)
                }
                .frame(height: 100)

                HStack {
                    // DONE BUTTON
                    Button(action: {
                        isEditingMonthYear = false
                    }) {
                        Text("Done")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.green)
                    }
                    .padding(.horizontal)

                    // RESET BUTTON
                    Button(action: {
                        let now = Date()
                        let calendar = Calendar.current
                        var components = calendar.dateComponents([.year, .month], from: now)
                        components.day = 1
                        if let currentDate = calendar.date(from: components) {
                            filteredDay = currentDate
                        }
                    }) {
                        Text("Reset")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.blue)
                    }
                }
            }
        } else {
            HStack {
                Image(systemName: "chevron.left")
                    .foregroundColor(.primary)
                    .padding(.leading)
                Text(currentPeriodText)
                    .font(.title)
                    .foregroundColor(.primary)
                    .onTapGesture {
                        isEditingMonthYear = true
                    }
                Image(systemName: "chevron.right")
                    .foregroundColor(.primary)
                    .padding(.trailing)
            }
        }
    }
}

