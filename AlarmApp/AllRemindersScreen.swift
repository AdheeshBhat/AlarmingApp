//
//  AllRemindersScreen.swift
//  AlarmApp
//
//  Created by Adheesh Bhat on 7/17/25.
//

import SwiftUI

struct AllRemindersScreen: View {
    @Environment(\.presentationMode) private var
        presentationMode: Binding<PresentationMode>
    @Binding var cur_screen: Screen
    @Binding var DatabaseMock: Database

    @State var currentYear: Int = Calendar.current.component(.year, from: Date())
    
    var body: some View {
        //NOTIFICATION BELL BUTTON + CREATE REMINDER BUTTON
        VStack {
            HStack {
                //NotificationBellExperience(cur_screen: $cur_screen, DatabaseMock: $DatabaseMock)
                    //.padding(.trailing, 10)
                CreateReminderExperience(cur_screen: $cur_screen, DatabaseMock: $DatabaseMock)
            }
        } //VStack ending
        .frame(maxWidth: .infinity, alignment: .topTrailing)
        
        VStack {
            Text("Reminders")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            .padding()
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Day")
                        .font(.title)
                }
                .foregroundColor(.black)
                .padding(.horizontal)
                .background(Color(.systemGray3))
                .cornerRadius(5)
                
                
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Week")
                        .font(.title)
                }
                .foregroundColor(.black)
                .padding(.horizontal)
                .background(Color(.systemGray3))
                .cornerRadius(5)
                
                
                Button(action: {
                    presentationMode.wrappedValue.dismiss() //change period, not dismiss
                }) {
                    Text("Month")
                        .font(.title)
                }
                .foregroundColor(.black)
                .padding(.horizontal)
                .background(Color(.systemGray3))
                .cornerRadius(5)
                
                
                Button(action: {
                    
                }) {
                    Text("All")
                        .font(.title)
                }
                .foregroundColor(.white)
                .padding(.horizontal)
                .background(Color(.blue))
                .cornerRadius(5)
                
            } //HStack ending
            .font(.headline)
            .padding(.bottom, 10)
            
            
            HStack {
                Button(action: {
                    currentYear -= 1
                }) {
                    Image(systemName: "chevron.left")
                        .font(.title)
                        .foregroundColor(.black)
                }

                Spacer()

                Text(String(currentYear))
                    .font(.largeTitle)
                    .fontWeight(.semibold)

                Spacer()

                Button(action: {
                    currentYear += 1
                }) {
                    Image(systemName: "chevron.right")
                        .font(.title)
                        .foregroundColor(.black)
                }
            } //HStack ending
            .padding(.horizontal, 50)
            .padding(.vertical, 10)

            // Month grid
            
            let months = Calendar.current.shortMonthSymbols

            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 20), count: 3), spacing: 20) {
                ForEach(0..<12, id: \.self) { index in
                    
//                    dateComponents.year = currentYear
//                    dateComponents.month = index + 1
//                    dateComponents.day = 1
                    let dateComponents = DateComponents(year: currentYear, month: index + 1, day: 1)

                    
                    NavigationLink(
                        destination: RemindersScreen(cur_screen: $cur_screen, DatabaseMock: $DatabaseMock, filterPeriod: "month", filteredDay: Calendar.current.date(from: dateComponents)!)
                    ) {
                        Text(months[index])
                            .font(.title)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity, minHeight: 60)
                            .background(Color(.systemBlue).opacity(0.5))
                            .cornerRadius(10)
                    }
                    
                }
            }
            .padding(.horizontal, 30)
            .padding(.vertical, 10)
            
        } //VStack ending
        
        
        
            
        
        
        Spacer()
        
        VStack {
            NavigationBarExperience(cur_screen: $cur_screen, DatabaseMock: $DatabaseMock)
        }
    } //body ending
} //struct ending
