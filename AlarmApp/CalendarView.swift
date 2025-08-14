//
//  CalendarView.swift
//  AlarmApp
//
//  Created by Adheesh Bhat on 7/31/25.
//
//

import SwiftUI

struct CalendarReminder: Identifiable {
    let id: UUID
    let title: String
    let date: Date
}

class CalendarHelper {
    let calendar = Calendar.current
    
    func plusMonth(_ date: Date) -> Date {
        calendar.date(byAdding: .month, value: 1, to: date) ?? date
    }
    
    func minusMonth(_ date: Date) -> Date {
        calendar.date(byAdding: .month, value: -1, to: date) ?? date
    }
    
    func getNumberOfDaysInMonth(date: Date) -> Int {
        guard let range = calendar.range(of: .day, in: .month, for: date) else {
            return 0
        }
        return range.count
    }
    
    func getSpecificDay(day: Int, from date: Date) -> Date {
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: date))!
        let maxDays = getNumberOfDaysInMonth(date: startOfMonth)

        let validDay = min(day, maxDays - 1)
        return calendar.date(byAdding: .day, value: validDay, to: startOfMonth)!
    }
    
    func findOffset(_ date: Date) -> Int {
        let firstOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: date))!
        let weekday = calendar.component(.weekday, from: firstOfMonth)
        return weekday - 1
    }

    func generateWeekDays(for date: Date) -> [Date] {
        let calendar = Calendar.current
        let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: date))!
        return (0..<7).compactMap { calendar.date(byAdding: .day, value: $0, to: startOfWeek) }
    }
    
    
    func generateCalendarDays(for date: Date) -> [Date?] {
        var days: [Date?] = []
        let helper = CalendarHelper()
        let firstOfMonth = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: date))!
        let numberOfDays = helper.getNumberOfDaysInMonth(date: date)
        let startingOffset = helper.findOffset(date)
        
        for i in 0..<42 {
            if i < startingOffset || i >= startingOffset + numberOfDays {
                days.append(nil)
            } else {
                days.append(Calendar.current.date(byAdding: .day, value: i - startingOffset, to: firstOfMonth))
            }
        }
        return days
    }
}

func normalizeDate(_ date: Date) -> Date {
    Calendar.current.startOfDay(for: date)
}



class CalendarViewModel: ObservableObject {
    @Published var selectedDate: Date = Date()
    @Published var remindersByDate: [Date: [CalendarReminder]] = [:]
    
    func remindersOnGivenDay(for date: Date) -> [CalendarReminder] {
        remindersByDate[normalizeDate(date)] ?? []
    }
    
    func loadReminders(from allReminders: [Date: ReminderData]) {
        var grouped: [Date: [CalendarReminder]] = [:]
        
        for (_, reminder) in allReminders {
            let dateKey = normalizeDate(reminder.date)
            let simpleReminder = CalendarReminder(id: UUID(), title: reminder.title, date: reminder.date)
            
            grouped[dateKey, default: []].append(simpleReminder)
        }
        
        remindersByDate = grouped
    }
}

enum ZoomLevel {
    case day, week, month
}

struct CalendarDayCellView: View {
    let date: Date?
    let reminders: [CalendarReminder]

    var body: some View {
        VStack {
            if let date = date {
                // If there are reminders, show date with colored circle background
                if !reminders.isEmpty {
                    let reminderCount = reminders.count
                    let circleColor: Color = reminderCount == 1 ? .green : (reminderCount <= 3 ? .yellow : .red)
                    ZStack {
                        Circle()
                            .fill(circleColor)
                            .frame(width: 30, height: 30)
                        Text("\(Calendar.current.component(.day, from: date))")
                            .font(.title2)
                            .foregroundColor(.black)
                    }
                } else {
                    // No reminders, just the date
                    Text("\(Calendar.current.component(.day, from: date))")
                        .font(.title2)
                        .foregroundColor(.black)
                }
            } else {
                Text("")
                    .frame(height: 30)
            }
        }
        .frame(maxWidth: .infinity, minHeight: 40) //define a height binding and pass it in to CalendarDayCellView for WeekView vs MonthView
        .padding(4)
    }
}





//CALENDAR VIEW ---------------------------------------------------------------------------------------------------------------------------------------------

struct CalendarView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var cur_screen: Screen
    @Binding var DatabaseMock: Database
    
    @StateObject var viewModel = CalendarViewModel()
    let helper = CalendarHelper()
    @State private var testDate = Date()
    @State private var calendarViewType: String = "month"
    @State private var isCalendarViewOn: Bool = true
    @State private var isReminderViewOn: Bool = false
    @State private var isEditingMonthYear = false
    @State private var filteredDay: Date? = Date()
    
    let columns = Array(repeating: GridItem(.flexible()), count: 7)
    
    var currentCalendarPeriodText: String {
        let today = filteredDay ?? Date()
        
        switch calendarViewType {
        case "week":
            return weekString(from: today)
        case "month":
            return monthString(today) + " " + yearString(today)
        default:
            return ""
        }
    }
    
    var body: some View {
        //TITLE + CREATE REMINDER BUTTON
        VStack {
            ZStack {
                //NotificationBellExperience(cur_screen: $cur_screen, DatabaseMock: $DatabaseMock)
                //.padding(.trailing, 10)
                HStack {
                    SettingsExperience(cur_screen: $cur_screen, DatabaseMock: $DatabaseMock)
                    Spacer()
                }
                
                Text("Calendar")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top)
                
                HStack {
                    Spacer()
                    CreateReminderExperience(cur_screen: $cur_screen, DatabaseMock: $DatabaseMock)
                }
            } //ZStack ending
            .padding(.bottom)
        } //VStack ending
       
        
        VStack {
            // Week/Month filter buttons
            HStack(spacing: 0) {
                Button(action: { calendarViewType = "week" }) {
                    Text("Week")
                        .font(.title)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(calendarViewType == "week" ? .white : .black)
                        .padding(.vertical)
                        .background(calendarViewType == "week" ? Color.blue : Color(.systemGray3))
                }
                Button(action: { calendarViewType = "month" }) {
                    Text("Month")
                        .font(.title)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(calendarViewType == "month" ? .white : .black)
                        .padding(.vertical)
                        .background(calendarViewType == "month" ? Color.blue : Color(.systemGray3))
                }
            } //HStack ending (filters)
            .font(.headline)
        
            //CALENDAR FILTER PERIOD
            if calendarViewType == "month" {
                MonthYearSelector(
                    filteredDay: $filteredDay,
                    isEditingMonthYear: $isEditingMonthYear,
                    currentPeriodText: currentCalendarPeriodText
                )
            } else {
                Text(currentCalendarPeriodText)
                    .font(.title)
                    .foregroundColor(.black)
            }
        } //VStack ending
        
        //CALENDAR
        VStack {
            //DAYS OF THE WEEK LABEL
            HStack {
                ForEach(["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"], id: \.self) { day in
                    Text(day)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .minimumScaleFactor(0.5)
                        .lineLimit(1)
                }
            }
            .padding(.horizontal)
            .padding(.top)

            ZStack {
                GeometryReader { geo in
                    let width = geo.size.width
                    let height = geo.size.height
                    let numRows = (calendarViewType == "month") ? 6 : 1
                    let cellWidth = width / 7
                    let cellHeight = height / CGFloat(numRows)
                    let weekOffset: Double = 1.1
                    
                    // Vertical lines (between columns)
                    ForEach(1..<7) { col in
                        //if statement to separate week offset from month offset
                        Rectangle()
                            .fill(Color.gray)
                            .frame(width: 1, height: height)
                            .position(x: cellWidth * CGFloat(col) * CGFloat(weekOffset), y: height / 2)
                    }
                    // Horizontal lines (between rows)
                    ForEach(1...numRows, id: \.self) { row in
                        Rectangle()
                            .fill(Color.gray)
                            .frame(width: width, height: 1)
                            .position(x: width / 2, y: cellHeight * CGFloat(row))
                    }
                }
                .allowsHitTesting(false)

                if calendarViewType == "month" {
                    TabView(selection: $viewModel.selectedDate) {
                        ForEach(-12...12, id: \.self) { offset in
                            let baseDate = filteredDay ?? Date()
                            let pageDate = Calendar.current.date(byAdding: .month, value: offset, to: baseDate)!
                            LazyVGrid(columns: columns, spacing: 0) {
                                ForEach(helper.generateCalendarDays(for: pageDate), id: \.self) { day in
                                    CalendarDayCellView(
                                        date: day,
                                        reminders: viewModel.remindersOnGivenDay(for: day ?? Date())
                                    )
                                }
                            }
                            .padding()
                            .tag(pageDate)
                        }
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))

//                    LazyVGrid(columns: columns, spacing: 0) {
//                        ForEach(helper.generateCalendarDays(for: viewModel.selectedDate), id: \.self) { day in
//                            CalendarDayCellView(
//                                date: day,
//                                reminders: viewModel.remindersOnGivenDay(for: day ?? Date())
//                            )
//                        }
//                    }
//                    .padding()
                }
                if calendarViewType == "week" {
                    LazyVGrid(columns: columns, spacing: 0) {
                        ForEach(helper.generateWeekDays(for: viewModel.selectedDate), id: \.self) { day in
                            CalendarDayCellView(
                                date: day,
                                reminders: viewModel.remindersOnGivenDay(for: day)
                            )
                        }
                    }
                    .padding()
                }
            }
        } //VStack ending
        .background(RoundedRectangle(cornerRadius: 12).stroke(Color.black, lineWidth: 2))
        .padding(.horizontal)

        Spacer()
        
        //CALENDAR VIEW TOGGLE
        VStack {
            Toggle(isOn: $isReminderViewOn) {
                Text("Reminder View")
                    .font(.title3)
            }
            .padding(.horizontal)
            .padding(.bottom)
            
            Toggle(isOn: $isCalendarViewOn) {
                Text("Calendar View")
                    .font(.title3)
            }
            .padding(.horizontal)
            .onChange(of: isCalendarViewOn) { _, newValue in
                if !newValue {
                    presentationMode.wrappedValue.dismiss()
                }
            }
        } //VStack ending
        .padding(.leading)
        .padding(.bottom)
        
        
        
        //Spacer()
        //BUTTONS FOR TESTING
//        VStack(spacing: 16) {
//            Text("Test Date: \(testDate.formatted(date: .long, time: .omitted))")
//            Button("Plus 1 Month") {
//                testDate = helper.plusMonth(testDate)
//                viewModel.selectedDate = testDate
//            }
//            Button("Minus 1 Month") {
//                testDate = helper.minusMonth(testDate)
//                viewModel.selectedDate = testDate
//            }
//            Button("Number of Days in Month") {
//                print("Days in month: \(helper.getNumberOfDaysInMonth(date: testDate))")
//            }
//            Button("Get Specific Day (e.g. 15th)") {
//                let result = helper.getSpecificDay(day: 14, from: testDate)
//                print("15th day of month: \(result)")
//            }
//            Button("Find Offset") {
//                print("Offset: \(helper.findOffset(testDate))")
//            }
//        } //VStack ending
        
        .onAppear {
            if let userReminders = DatabaseMock.users[1] {
                viewModel.loadReminders(from: userReminders)
            }
        }
        
        .onAppear {
            filteredDay = viewModel.selectedDate
        }
        
        .onAppear {
            cur_screen = .CalendarScreen
        }
        
        .onChange(of: filteredDay) { oldValue, newValue in
            if let newValue = newValue {
                viewModel.selectedDate = newValue
            }
        }
        
        .onChange(of: viewModel.selectedDate) { oldValue, newValue in
            filteredDay = newValue
        }
        
        VStack {
            NavigationBarExperience(cur_screen: $cur_screen, DatabaseMock: $DatabaseMock)
        }
        
    } //body ending
}
