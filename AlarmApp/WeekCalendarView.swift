//
//  Extra_screen.swift
//  Alarm App
//
//  Created by Adheesh Bhat on 1/30/25.
//

import SwiftUI

struct WeekCalendarView: View {
    @Environment(\.presentationMode) private var
        presentationMode: Binding<PresentationMode>
    @State private var isReminderViewOn = true
    @State private var isWeekCalendarViewOn = false
    @State private var home_pressed3 : Int = 1
    @State private var navigate_to_home_screen_from_Wcalendar : Bool = false
    @Binding var cur_screen: Screen
    @Binding var DatabaseMock: Database
    //get rid of navigation stacks
    var body: some View {
        //NavigationStack {
        VStack {
            // Back Button
            HStack {
                Button(action: {
                    // Action to go back
                }) {
                    Image(systemName: "arrow.left")
                        .font(.title)
                        .foregroundColor(.black)
                        .padding(3)
                        .background(RoundedRectangle(cornerRadius: 5).stroke(Color.gray, lineWidth: 1))
                    
                }
                Spacer()
            }
            
            // Title
            Text("Calendar")
                .font(.largeTitle)
                .bold()
                .padding(.bottom, 5)
            
            // Navigation Icons (Menu, Month Selector, Search, Calendar Icon)
            HStack {
                Button(action: {}) {
                    Image(systemName: "line.3.horizontal")
                        .font(.title2)
                        .foregroundColor(.black)
                }
                Spacer()
                
                Text("May 2025")
                    .font(.title2)
                Spacer()
                
                HStack {
                    Button(action: {}) {
                        Image(systemName: "magnifyingglass")
                            .font(.title2)
                            .foregroundColor(.black)
                    }
                    Button(action: {}) {
                        Image(systemName: "calendar")
                            .font(.title2)
                            .foregroundColor(.black)
                    }
                    
                } //HStack ending
            } //HStack ending
            .padding(.horizontal, 20)
            
            // Calendar Grid for the Week
            HStack(spacing: 5) {
                ForEach(["3", "4", "5", "6", "7", "8", "9"], id: \.self) { day in
                    Text(day)
                        .font(.title)
                        .frame(width: 40, height: 40)
                        .background(getColor(for: day))
                        .cornerRadius(10)
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 1))
                }
            }
            .padding(.top, 10)
            
            // Reminder View Toggle
            Toggle("Reminder View", isOn: $isReminderViewOn)
                .padding(.top, 20)
            
            // Calendar View Toggle
            Toggle("Calendar View", isOn: $isWeekCalendarViewOn)
                .padding(.bottom, 30)
            
            Spacer()
            
            
            VStack {
                Rectangle()
                    .frame(width: 400, height: 2)
                
            }
            
            // Navigation Bar at Bottom
            HStack(spacing: 70) {
                
                //REMINDERS BUTTON
                VStack() {
                    NavigationLink(destination: RemindersScreen(cur_screen: $cur_screen, DatabaseMock: $DatabaseMock)) {
                        
//                            Button(action: {
//                                home_pressed3 = 1
//                            }) {
                            Image(systemName: "list.bullet")
                                .font(.title)
                                .foregroundColor(home_pressed3 == 1 ? Color.blue : Color.black)
                            
                        //} //button ending
                        .padding(7)
                        
                        Text("Reminders")
                    } //Navigation Link ending
                } //VStack ending
                
                
                //HOME BUTTON
                VStack() {
                    NavigationLink(destination: ContentView()) {
                        
//                        Button(action: {
//                            home_pressed3 = 0
//                            navigate_to_home_screen_from_Wcalendar = true
//                        }) {
                        Image(systemName: "house")
                            .font(.title)
                            .foregroundColor(home_pressed3 == 0 ? Color.blue : Color.black)
                        //}
                            .padding(4)
                        
                        //navigation based on a boolean
//                                .navigationDestination(isPresented: $navigate_to_home_screen_from_Wcalendar) {
//                                    ContentView()
//                                }
                        
                        Text("Home")
                    } //Navigation Link ending
                } //VStack ending
                
                
                //BACK BUTTON
                .navigationBarBackButtonHidden(true)
                VStack() {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "arrowshape.backward")
                            .font(.title)
                            .foregroundColor(.black)
                    }
                    .padding(1.5)
                    .background(RoundedRectangle(cornerRadius: 5).stroke(Color.black, lineWidth: 1))
                    .padding(4)
                    Text("Back")
                    
                } //VStack ending
                
                
            } //HStack ending
            
            
            
//                HStack(spacing: 50) {
//                    VStack {
//                        Button(action: {}) {
//                            Image(systemName: "list.bullet")
//                                .font(.title)
//                                .foregroundColor(.blue)
//                        }
//                        Text("Reminders")
//                            .foregroundColor(.blue)
//                    }
//
//                    VStack {
//                        Button(action: {}) {
//                            Image(systemName: "house")
//                                .font(.title)
//                                .foregroundColor(.black)
//                        }
//                        Text("Home")
//                    }
//
//                    VStack {
//                        Button(action: {}) {
//                            Image(systemName: "arrow.backward")
//                                .font(.title)
//                                .foregroundColor(.black)
//                        }
//                        Text("Back")
//                    }
//                }
//                .padding()
//                .frame(maxWidth: .infinity)
//                .background(Color.white.shadow(radius: 2))
        } //VStack ending
        .padding()
        //} //Navigation stack ending
    } //body ending
    
    // Function to assign colors to the dates based on their number
    func getColor(for day: String) -> Color {
        switch day {
        case "5": return Color.blue
        case "6": return Color.green
        case "8": return Color.orange
        case "9": return Color.red
        default: return Color.clear
        }
    }
}

//#Preview {
//    WeekCalendarView(cur_screen: $cur_screen)
//}
