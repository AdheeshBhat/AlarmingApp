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
    let cellHeight: CGFloat
    let zoomScale: CGFloat

    var body: some View {
        VStack(spacing: 2) {
            if let date = date {
                if !reminders.isEmpty {
                    let reminderCount = reminders.count
                    let circleColor: Color = reminderCount == 1 ? .green : (reminderCount <= 3 ? .yellow : .red)
                    ZStack {
                        Circle()
                            .fill(circleColor)
                            .frame(width: 20, height: 20)
                        Text("\(Calendar.current.component(.day, from: date))")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.black)
                    }
                } else {
                    Text("\(Calendar.current.component(.day, from: date))")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.black)
                        .frame(width: 20, height: 20)
                }
                
                if zoomScale > 1.2 && !reminders.isEmpty {
                    VStack(spacing: 1) {
                        ForEach(reminders.prefix(min(3, reminders.count))) { reminder in
                            Text(reminder.title)
                                .font(.system(size: 8))
                                .foregroundColor(.white)
                                .padding(.horizontal, 2)
                                .padding(.vertical, 1)
                                .background(RoundedRectangle(cornerRadius: 2).fill(Color.blue))
                                .lineLimit(1)
                        }
                        
                        if reminders.count > 3 {
                            Text("+\(reminders.count - 3)")
                                .font(.system(size: 6))
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 4)
                .stroke(Color.gray.opacity(0.3), lineWidth: 0.5)
        )
    }
}

struct CalendarView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var cur_screen: Screen
    @Binding var DatabaseMock: Database
    
    @StateObject var viewModel = CalendarViewModel()
    let helper = CalendarHelper()
    @State private var calendarViewType: String = "month"
    @State private var isCalendarViewOn: Bool = true
    @State private var isReminderViewOn: Bool = false
    @State private var isEditingMonthYear = false
    @State private var filteredDay: Date? = Date()
    @State private var zoomScale: CGFloat = 1.0
    @State private var lastZoomScale: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    @State private var lastOffset: CGSize = .zero
    
    let minZoom: CGFloat = 1.0
    let maxZoom: CGFloat = 3.0
    let columns = Array(repeating: GridItem(.flexible(), spacing: 1), count: 7)
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                // Header
                ZStack {
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
                }
                .padding(.bottom)
                
                // Week/Month Toggle
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
                }
                .font(.headline)
                
                // Month/Year Selector
                if calendarViewType == "month" {
                    MonthYearSelector(
                        filteredDay: $filteredDay,
                        isEditingMonthYear: $isEditingMonthYear,
                        currentPeriodText: currentPeriodText
                    )
                } else {
                    Text(currentPeriodText)
                        .font(.title)
                        .foregroundColor(.black)
                }
                
                // Calendar Grid - This takes up the remaining space
                VStack(spacing: 0) {
                    HStack {
                        ForEach(["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"], id: \.self) { day in
                            Text(day)
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.gray)
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 8)

                    if calendarViewType == "month" {
                        LazyVGrid(columns: columns, spacing: 1) {
                            ForEach(helper.generateCalendarDays(for: filteredDay ?? Date()), id: \.self) { day in
                                CalendarDayCellView(
                                    date: day,
                                    reminders: viewModel.remindersOnGivenDay(for: day ?? Date()),
                                    cellHeight: (geometry.size.height - 350) / 6,
                                    zoomScale: zoomScale
                                )
                            }
                        }
                        .padding(.horizontal, 4)
                    } else {
                        LazyVGrid(columns: columns, spacing: 1) {
                            ForEach(helper.generateWeekDays(for: viewModel.selectedDate), id: \.self) { day in
                                CalendarDayCellView(
                                    date: day,
                                    reminders: viewModel.remindersOnGivenDay(for: day),
                                    cellHeight: geometry.size.height - 300,
                                    zoomScale: zoomScale
                                )
                            }
                        }
                        .padding(.horizontal, 4)
                    }
                    
                    if zoomScale > 1.0 {
                        HStack {
                            Spacer()
                            Button("Reset View") {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    zoomScale = 1.0
                                    offset = .zero
                                    lastOffset = .zero
                                }
                            }
                            .padding(8)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                            .padding(.trailing)
                        }
                        .padding(.top, 8)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(RoundedRectangle(cornerRadius: 12).stroke(Color.black, lineWidth: 2))
                .padding(.horizontal)
                .scaleEffect(zoomScale, anchor: .center)
                .offset(offset)
                .animation(.easeOut(duration: 0.1), value: zoomScale)
                .gesture(
                    MagnificationGesture()
                        .onChanged { value in
                            let delta = value / lastZoomScale
                            lastZoomScale = value
                            let newScale = zoomScale * delta
                            zoomScale = min(max(newScale, minZoom), maxZoom)
                            
                            // Reset offset when zooming back to 1.0 or below
                            if zoomScale <= 1.0 {
                                offset = .zero
                                lastOffset = .zero
                            }
                        }
                        .onEnded { _ in
                            lastZoomScale = 1.0
                            // Ensure centered when at normal zoom
                            if zoomScale <= 1.0 {
                                withAnimation(.easeOut(duration: 0.2)) {
                                    offset = .zero
                                    lastOffset = .zero
                                }
                            }
                        }
                )
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            if zoomScale > 1.0 {
                                offset = CGSize(
                                    width: lastOffset.width + value.translation.width,
                                    height: lastOffset.height + value.translation.height
                                )
                            }
                        }
                        .onEnded { _ in
                            if zoomScale > 1.0 {
                                lastOffset = offset
                            }
                        }
                )
                .onTapGesture(count: 2) {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        zoomScale = 1.0
                        offset = .zero
                        lastOffset = .zero
                    }
                }
                .clipped()
                
                // Bottom Controls
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
                }
                .padding(.leading)
                .padding(.bottom)
                
                NavigationBarExperience(cur_screen: $cur_screen, DatabaseMock: $DatabaseMock)
            }
        }
        .onAppear {
            if let userReminders = DatabaseMock.users[1] {
                viewModel.loadReminders(from: userReminders)
            }
            filteredDay = viewModel.selectedDate
            cur_screen = .CalendarScreen
        }
        .onChange(of: filteredDay) { _, newValue in
            if let newValue = newValue {
                viewModel.selectedDate = newValue
            }
        }
        .onChange(of: viewModel.selectedDate) { _, newValue in
            filteredDay = newValue
        }
    }
    
    private var currentPeriodText: String {
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
}
