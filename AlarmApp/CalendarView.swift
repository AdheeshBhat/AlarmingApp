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



struct CalendarView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var cur_screen: Screen
    @Binding var DatabaseMock: Database
    @Binding var initialViewType: String
    
    @StateObject var viewModel = CalendarViewModel()
    let helper = CalendarHelper()
    @State private var calendarViewType: String = "month"
    @State private var isCalendarViewOn: Bool = true
    @State private var isReminderViewOn: Bool = false
    @State private var isEditingMonthYear = false
    @State private var monthFilteredDay: Date? = Date()
    @State private var weekFilteredDay: Date? = Date()
    @State private var zoomScale: CGFloat = 1.0
    @State private var lastZoomScale: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    @State private var lastOffset: CGSize = .zero
    @State private var zoomAnchor: UnitPoint = .center
    @State private var swipeOffset: Int = 0
    @State private var canResetDate: Bool = false
    
    let minZoom: CGFloat = 1.0
    let maxZoom: CGFloat = 3.0
    let columns = Array(repeating: GridItem(.flexible(), spacing: 1), count: 7)
    
    private var calendarGesture: AnyGesture<Void> {
        if zoomScale > 1.0 {
            return AnyGesture(
                SimultaneousGesture(
                    MagnificationGesture()
                        .onChanged { value in
                            let delta = value / lastZoomScale
                            lastZoomScale = value
                            let newScale = zoomScale * delta
                            zoomScale = min(max(newScale, minZoom), maxZoom)
                            
                            if zoomScale <= 1.0 {
                                offset = .zero
                                lastOffset = .zero
                                zoomAnchor = .center
                            }
                        }
                        .onEnded { _ in
                            lastZoomScale = 1.0
                            if zoomScale <= 1.0 {
                                withAnimation(.easeOut(duration: 0.2)) {
                                    offset = .zero
                                    lastOffset = .zero
                                    zoomAnchor = .center
                                }
                            }
                        },
                    DragGesture()
                        .onChanged { value in
                            offset = CGSize(
                                width: lastOffset.width + value.translation.width,
                                height: lastOffset.height + value.translation.height
                            )
                        }
                        .onEnded { _ in
                            lastOffset = offset
                        }
                ).map { _ in () }
            )
        } else {
            return AnyGesture(
                MagnificationGesture()
                    .onChanged { value in
                        let delta = value / lastZoomScale
                        lastZoomScale = value
                        let newScale = zoomScale * delta
                        zoomScale = min(max(newScale, minZoom), maxZoom)
                        
                        if zoomScale > 1.0 {
                            zoomAnchor = .center
                        }
                    }
                    .onEnded { _ in
                        lastZoomScale = 1.0
                    }
                    .map { _ in () }
            )
        }
    } //AnyGesture ending
   
    var body: some View {
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
                        .foregroundColor(calendarViewType == "week" ? .white : .primary)
                        .padding(.vertical)
                        .background(calendarViewType == "week" ? Color.blue : Color(.systemGray3))
                }
                Button(action: { calendarViewType = "month" }) {
                    Text("Month")
                        .font(.title)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(calendarViewType == "month" ? .white : .primary)
                        .padding(.vertical)
                        .background(calendarViewType == "month" ? Color.blue : Color(.systemGray3))
                }
            }
            .font(.headline)
            
            // Month/Year Selector
            HStack(spacing: 8) {
                if calendarViewType == "month" {
                    MonthYearSelector(
                        filteredDay: $monthFilteredDay,
                        isEditingMonthYear: $isEditingMonthYear,
                        currentPeriodText: currentPeriodText,
                        onDone: {
                            isEditingMonthYear = false
                        }
                    )
                } else {
                    Text(currentPeriodText)
                        .font(.title)
                        .foregroundColor(.primary)
                }
                //RESET BUTTON
                if canResetDate == true {
                    Button(action: {
                        swipeOffset = 0
                        weekFilteredDay = Date.now
                        monthFilteredDay = Date.now
                        canResetDate = false
                    }) {
                        Text("Reset")
                            .font(.caption)
                            .padding(6)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(6)
                    }
                } //if statement ending
            }
            
            // Calendar Grid - Takes remaining space
            GeometryReader { geometry in
                VStack(spacing: 0) {
                    // Day headers
                    HStack(spacing: 0) {
                        ForEach(["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"], id: \.self) { day in
                            Text(day)
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.secondary)
                                .frame(width: geometry.size.width / 7, height: 30)
                        }
                    }

                    let cellWidth = geometry.size.width / 7
                    let cellHeight = (geometry.size.height - 30) / (calendarViewType == "month" ? 6 : 1)

                    TabView(selection: $swipeOffset) {
                        ForEach(-6...6, id: \.self) { index in
                            Group {
                                if calendarViewType == "month" {
                                    VStack(spacing: 0) {
                                        let days = helper.generateCalendarDays(for: calculateDateFor())
                                        ForEach(0..<6, id: \.self) { row in
                                            HStack(spacing: 0) {
                                                ForEach(0..<7, id: \.self) { col in
                                                    let dayIndex = row * 7 + col
                                                    let day = dayIndex < days.count ? days[dayIndex] : nil
                                                    MonthDayCellView(
                                                        date: day,
                                                        reminders: viewModel.remindersOnGivenDay(for: day ?? Date()),
                                                        cellHeight: cellHeight,
                                                        zoomScale: zoomScale,
                                                        isReminderViewOn: isReminderViewOn,
                                                        cur_screen: $cur_screen,
                                                        DatabaseMock: $DatabaseMock
                                                    )
                                                    .frame(width: cellWidth, height: cellHeight)
                                                }
                                            }
                                        }
                                    }
                                } else {
                                    HStack(spacing: 0) {
                                        let weekDays = helper.generateWeekDays(for: calculateDateFor())
                                        ForEach(weekDays, id: \.self) { day in
                                            WeekDayCellView(
                                                date: day,
                                                reminders: viewModel.remindersOnGivenDay(for: day),
                                                cellWidth: cellWidth,
                                                cellHeight: cellHeight,
                                                cur_screen: $cur_screen,
                                                DatabaseMock: $DatabaseMock
                                            )
                                        }
                                    }
                                }
                            }
                            .tag(index)
                        }
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    .onChange(of: swipeOffset) { _, _ in
                        updateFilteredDay()
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
                        }
                        .padding(.top, 4)
                    }
                }
                .background(RoundedRectangle(cornerRadius: 12).stroke(Color.primary, lineWidth: 2))
                .scaleEffect(zoomScale, anchor: zoomAnchor)
                .offset(offset)
                .animation(.easeOut(duration: 0.1), value: zoomScale)
                
                // ZOOM/SWIPE
                .gesture(calendarGesture)
                
                .onTapGesture(count: 2) {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        zoomScale = 1.0
                        offset = .zero
                        lastOffset = .zero
                    }
                }
                .clipped()
            } //Geometry Reader ending
            
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
        .onAppear {
            calendarViewType = initialViewType
            if let userReminders = DatabaseMock.users[1] {
                viewModel.loadReminders(from: userReminders)
            }
            monthFilteredDay = viewModel.selectedDate
            weekFilteredDay = viewModel.selectedDate
            cur_screen = .CalendarScreen
        }
        .onChange(of: calendarViewType) { _, newValue in
            initialViewType = newValue
        }
        .onChange(of: viewModel.selectedDate) { _, newValue in
            // Keep both in sync with selectedDate, but only update the visible one
            if calendarViewType == "month" {
                monthFilteredDay = newValue
            } else {
                weekFilteredDay = newValue
            }
        }
    }

    private func calculateDateFor() -> Date {
        let base: Date
        if calendarViewType == "month" {
            base = monthFilteredDay ?? Date()
            let calculatedDate = Calendar.current.date(byAdding: .month, value: swipeOffset, to: base) ?? base
            return calculatedDate
        } else {
            base = weekFilteredDay ?? Date()
            let calculatedDate = Calendar.current.date(byAdding: .weekOfYear, value: swipeOffset, to: base) ?? base
            return calculatedDate
        }
    }

    private func updateFilteredDay() {
        if calendarViewType == "month" {
            let base = monthFilteredDay ?? Date()
            monthFilteredDay = Calendar.current.date(byAdding: .month, value: swipeOffset, to: base)
        } else {
            let base = weekFilteredDay ?? Date()
            weekFilteredDay = Calendar.current.date(byAdding: .weekOfYear, value: swipeOffset, to: base)
        }
        
        if swipeOffset != 0 {
            canResetDate = true
        }
        swipeOffset = 0
    }

    private var currentPeriodText: String {
        let today: Date
        if calendarViewType == "month" {
            today = monthFilteredDay ?? Date()
            return monthString(today) + " " + yearString(today)
        } else if calendarViewType == "week" {
            today = weekFilteredDay ?? Date()
            return weekString(from: today)
        } else {
            return ""
        }
    }
}
