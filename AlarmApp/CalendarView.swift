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
    let isReminderViewOn: Bool
    @Binding var cur_screen: Screen
    @Binding var DatabaseMock: Database

    // Helper to safely fetch ReminderData for a normalized date
    private func reminderData(for reminder: CalendarReminder) -> ReminderData? {
        let normalizedDate = normalizeDate(reminder.date)
        if let userReminders = DatabaseMock.users[1] {
            // Find the ReminderData with the same normalized date and matching title
            return userReminders.first(where: {
                normalizeDate($0.value.date) == normalizedDate && $0.value.title == reminder.title
            })?.value
        }
        return nil
    }

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
                            .foregroundColor(.primary)
                    }
                } else {
                    Text("\(Calendar.current.component(.day, from: date))")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.primary)
                        .frame(width: 20, height: 20)
                }

                if (zoomScale > 1.2 || isReminderViewOn) && !reminders.isEmpty {
                    VStack(spacing: 1) {
                        ForEach(reminders.prefix(min(3, reminders.count))) { reminder in
                            if let reminderData = reminderData(for: reminder) {
                                NavigationLink(
                                    destination: EditReminderScreen(
                                        cur_screen: $cur_screen,
                                        DatabaseMock: $DatabaseMock,
                                        reminder: Binding(
                                            get: { reminderData },
                                            set: { updated in
                                                // Update the correct ReminderData in DatabaseMock
                                                let normalizedDate = normalizeDate(reminder.date)
                                                if let userReminders = DatabaseMock.users[1] {
                                                    if let key = userReminders.first(where: {
                                                        normalizeDate($0.value.date) == normalizedDate && $0.value.title == reminder.title
                                                    })?.key {
                                                        DatabaseMock.users[1]?[key] = updated
                                                    }
                                                }
                                            }
                                        )
                                    ) // destination ending
                                ) {
                                    Text(reminder.title)
                                        .font(.system(size: 8))
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 2)
                                        .padding(.vertical, 1)
                                        .background(RoundedRectangle(cornerRadius: 2).fill(Color.blue))
                                        .lineLimit(1)
                                }
                            } else {
                                Text(reminder.title)
                                    .font(.system(size: 8))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 2)
                                    .padding(.vertical, 1)
                                    .background(RoundedRectangle(cornerRadius: 2).fill(Color.gray))
                                    .lineLimit(1)
                            }
                        }

                        if reminders.count > 3 {
                            Text("+\(reminders.count - 3)")
                                .font(.system(size: 6))
                                .foregroundColor(.secondary)
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

struct WeekDayCellView: View {
    let date: Date
    let reminders: [CalendarReminder]
    let cellWidth: CGFloat
    let cellHeight: CGFloat
    @Binding var cur_screen: Screen
    @Binding var DatabaseMock: Database

    // Helper to safely fetch ReminderData for a normalized date
    private func reminderData(for reminder: CalendarReminder) -> ReminderData? {
        let normalizedDate = normalizeDate(reminder.date)
        if let userReminders = DatabaseMock.users[1] {
            return userReminders.first(where: {
                normalizeDate($0.value.date) == normalizedDate && $0.value.title == reminder.title
            })?.value
        }
        return nil
    }

    var body: some View {
        VStack(spacing: 4) {
            Text("\(Calendar.current.component(.day, from: date))")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.primary)

            ScrollView {
                VStack(spacing: 2) {
                    ForEach(reminders) { reminder in
                        if let reminderData = reminderData(for: reminder) {
                            NavigationLink(
                                destination: EditReminderScreen(
                                    cur_screen: $cur_screen,
                                    DatabaseMock: $DatabaseMock,
                                    reminder: Binding(
                                        get: { reminderData },
                                        set: { updated in
                                            let normalizedDate = normalizeDate(reminder.date)
                                            if let userReminders = DatabaseMock.users[1] {
                                                if let key = userReminders.first(where: {
                                                    normalizeDate($0.value.date) == normalizedDate && $0.value.title == reminder.title
                                                })?.key {
                                                    DatabaseMock.users[1]?[key] = updated
                                                }
                                            }
                                        }
                                    )
                                )
                            ) {
                                Text(reminder.title)
                                    .font(.system(size: 10))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 4)
                                    .padding(.vertical, 2)
                                    .background(RoundedRectangle(cornerRadius: 4).fill(Color.blue))
                                    .lineLimit(2)
                            }
                        } else {
                            Text(reminder.title)
                                .font(.system(size: 10))
                                .foregroundColor(.white)
                                .padding(.horizontal, 4)
                                .padding(.vertical, 2)
                                .background(RoundedRectangle(cornerRadius: 4).fill(Color.gray))
                                .lineLimit(2)
                        }
                    }
                }
            }
        }
        .frame(width: cellWidth, height: cellHeight)
        .background(
            RoundedRectangle(cornerRadius: 4)
                .stroke(Color.gray.opacity(0.3), lineWidth: 0.5)
        )
        .padding(1)
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
    @State private var zoomAnchor: UnitPoint = .center
    @State private var swipeOffset: Int = 0
    
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
    }
    
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
                        filteredDay: $filteredDay,
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
                if swipeOffset != 0 {
                    Button(action: {
                        swipeOffset = 0
                        updateFilteredDay()
                    }) {
                        Text("Reset")
                            .font(.caption)
                            .padding(6)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(6)
                    }
                }
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
                                        let days = helper.generateCalendarDays(for: calculateDateFor(index: index))
                                        ForEach(0..<6, id: \.self) { row in
                                            HStack(spacing: 0) {
                                                ForEach(0..<7, id: \.self) { col in
                                                    let dayIndex = row * 7 + col
                                                    let day = dayIndex < days.count ? days[dayIndex] : nil
                                                    CalendarDayCellView(
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
                                let weekDays = helper.generateWeekDays(for: calculateDateFor(index: index))
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

    private func calculateDateFor(index: Int) -> Date {
        let base = filteredDay ?? Date()
        if calendarViewType == "month" {
            return Calendar.current.date(byAdding: .month, value: index + swipeOffset, to: base) ?? base
        } else {
            return Calendar.current.date(byAdding: .weekOfYear, value: index + swipeOffset, to: base) ?? base
        }
    }

    private func updateFilteredDay() {
        let base = filteredDay ?? Date()
        if calendarViewType == "month" {
            filteredDay = Calendar.current.date(byAdding: .month, value: swipeOffset, to: base)
        } else {
            filteredDay = Calendar.current.date(byAdding: .weekOfYear, value: swipeOffset, to: base)
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

