//
//  CustomRepeatCalendarView.swift
//  AlarmApp
//
//  Created by Adheesh Bhat on 7/31/25.
//

import SwiftUI

struct CustomRepeatCalendarView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var cur_screen: Screen
    @State var title: String
    @State private var selectedDays: Set<String> = []
    @Binding var repeatSetting: String
    @Binding var customPatterns: Set<String>
    let firestoreManager: FirestoreManager
    
    let weekdays = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    let weeks = ["1st", "2nd", "3rd", "4th", "Last"]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 18) {
                Text(title)
                    .font(.title2)
                    .fontWeight(.medium)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
            
            HStack {
                Text("Custom Repeat Pattern")
                    .font(.headline)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Button("Clear") {
                    selectedDays.removeAll()
                }
                .font(.headline)
                .fontWeight(.medium)
                .foregroundColor(.white)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(.red)
                .cornerRadius(8)
            }
            .padding(.horizontal, 16)
            
            // Calendar-like grid
            VStack(spacing: 12) {
                // Header with weekdays
                HStack(spacing: 4) {
                    // Empty space for week labels
                    Text("")
                        .frame(width: 50)
                    
                    ForEach(weekdays, id: \.self) { day in
                        Text(day)
                            .font(.headline)
                            .fontWeight(.medium)
                            .foregroundColor(.primary)
                            .frame(maxWidth: .infinity)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
                
                // Grid of selectable cells
                ForEach(weeks, id: \.self) { week in
                    HStack(spacing: 4) {
                        Text(week)
                            .font(.headline)
                            .fontWeight(.medium)
                            .foregroundColor(.primary)
                            .frame(width: 50)
                        
                        ForEach(weekdays, id: \.self) { day in
                            let cellKey = "\(week) \(day)"
                            Button(action: {
                                if selectedDays.contains(cellKey) {
                                    selectedDays.remove(cellKey)
                                } else {
                                    selectedDays.insert(cellKey)
                                }
                            }) {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(selectedDays.contains(cellKey) ? Color.green : Color.blue.opacity(0.1))
                                    .frame(height: 50)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(selectedDays.contains(cellKey) ? Color.green : Color.blue.opacity(0.3), lineWidth: 2)
                                    )
                                    .overlay(
                                        Text(selectedDays.contains(cellKey) ? "✓" : "")
                                            .foregroundColor(selectedDays.contains(cellKey) ? .white : .clear)
                                            .font(.title2)
                                            .fontWeight(.bold)
                                    )
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                }
                .padding(.bottom, 16)
            }
            .background(Color.blue.opacity(0.1))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.blue.opacity(0.3), lineWidth: 1)
            )
            .cornerRadius(12)
            .padding(.horizontal, 16)
            
                // Selected patterns display
                if !selectedDays.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Selected Pattern:")
                            .font(.headline)
                            .fontWeight(.medium)
                            .foregroundColor(.primary)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            ForEach(Array(selectedDays).sorted(), id: \.self) { pattern in
                                Text("• \(pattern) of each month")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(16)
                    .background(Color.blue.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                    )
                    .cornerRadius(12)
                    .padding(.horizontal, 16)
                }
            
                // Done button
                Button(action: {
                    // Save the custom repeat pattern
                    customPatterns = selectedDays
                    if !selectedDays.isEmpty {
                        repeatSetting = "Custom"
                    }
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Done")
                        .font(.headline)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(16)
                        .background(.green)
                        .cornerRadius(12)
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
            }
        }
        
        .onAppear {
            selectedDays = customPatterns
        }
        
        VStack {
            NavigationBarExperience(cur_screen: $cur_screen, firestoreManager: firestoreManager)
        }
    }
}
