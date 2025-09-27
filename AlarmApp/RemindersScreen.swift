import SwiftUI
import FirebaseFirestore

struct RemindersScreen: View {
    //@Environment(\.dismiss) var dismiss also works for back button
    @Environment(\.presentationMode) private var
        presentationMode: Binding<PresentationMode>
    @State private var navigate_to_home_screen : Bool = false
    @State private var notifications : Bool = false
    @State private var showCalendarView : Bool = false
    @State private var isDeleteViewOn : Bool = false
    @Binding var cur_screen: Screen
    
    @State var filterPeriod : String
    @State var dayFilteredDay: Date? = Date()
    @State private var weekFilteredDay: Date? = Date()
    @State private var monthFilteredDay: Date? = Date()
    @State private var isEditingMonthYear: Bool = false
    @State private var swipeOffset: Int = 0
    @State private var calendarViewType: String = "month"
    @State private var canResetDate: Bool = false
    @State var remindersForUser: [Date: ReminderData]
    let firestoreManager: FirestoreManager
    
    //create a variable that would change the period depending on the button pressed
    var currentPeriodText: String {
        let today = Date()
        
        switch filterPeriod {
        case "today":
            return dayString(from: dayFilteredDay ?? today)
            
        case "week":
            return weekString(from: weekFilteredDay ?? today)
            
        case "month":
            return monthString(monthFilteredDay ?? today) + " " + yearString(monthFilteredDay ?? today)
            
        default:
            return ""
        }
    }
    
    
    var body: some View {
        VStack(spacing: 0) {
            header
            filterButtons
            remindersList
            Divider()
                .background(Color.blue)
                .frame(height: 2)
            footerToggles
            NavigationBarExperience(cur_screen: $cur_screen, firestoreManager: firestoreManager)
        }
        .navigationDestination(isPresented: $showCalendarView) {
            calendarView
        }
        .onAppear {
            cur_screen = .RemindersScreen
            canResetDate = displayedPeriodDiffersFromToday()
            
            firestoreManager.getRemindersForUser() { reminders in
                self.remindersForUser = reminders ?? [:]
                
            }
        }
        .onChange(of: dayFilteredDay) { _, _ in
            canResetDate = displayedPeriodDiffersFromToday()
        }
        .onChange(of: weekFilteredDay) { _, _ in
            canResetDate = displayedPeriodDiffersFromToday()
        }
        .onChange(of: monthFilteredDay) { _, _ in
            canResetDate = displayedPeriodDiffersFromToday()
        }
        .onChange(of: filterPeriod) { _, _ in
            canResetDate = displayedPeriodDiffersFromToday()
        }
    }

    // MARK: - Subviews split for type-checking
    private var header: some View {
        ZStack {
            HStack {
                SettingsExperience(cur_screen: $cur_screen, firestoreManager: firestoreManager)
                Spacer()
            }
            Text("Reminders")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity, alignment: .center)
            HStack {
                Spacer()
                CreateReminderExperience(cur_screen: $cur_screen, firestoreManager: firestoreManager)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(Color(.systemBackground))
    }

    private var filterButtons: some View {
        VStack(spacing: 8) {
            HStack(spacing: 4) {
                Button(action: {
                    filterPeriod = "today"
                }) {
                    Text("Day")
                        .font(.body)
                        .fontWeight(.medium)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(filterPeriod == "today" ? Color.blue : Color.blue.opacity(0.1))
                        .foregroundColor(filterPeriod == "today" ? .white : .blue)
                        .cornerRadius(8)
                }
                Button(action: {
                    filterPeriod = "week"
                }) {
                    Text("Week")
                        .font(.body)
                        .fontWeight(.medium)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(filterPeriod == "week" ? Color.blue : Color.blue.opacity(0.1))
                        .foregroundColor(filterPeriod == "week" ? .white : .blue)
                        .cornerRadius(8)
                }
                Button(action: {
                    filterPeriod = "month"
                }) {
                    Text("Month")
                        .font(.body)
                        .fontWeight(.medium)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(filterPeriod == "month" ? Color.blue : Color.blue.opacity(0.1))
                        .foregroundColor(filterPeriod == "month" ? .white : .blue)
                        .cornerRadius(8)
                }
            }
            .padding(.horizontal)
            VStack(spacing: 4) {
                if filterPeriod == "month" {
                    MonthYearSelector(
                        filteredDay: $monthFilteredDay,
                        isEditingMonthYear: $isEditingMonthYear,
                        currentPeriodText: currentPeriodText,
                        onDone: {
                            isEditingMonthYear = false
                            swipeOffset = 0
                        }
                    )
                } else {
                    Text(currentPeriodText)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                }
                if canResetDate == true {
                    Button("Today") {
                        swipeOffset = 0
                        dayFilteredDay = Date.now
                        weekFilteredDay = Date.now
                        monthFilteredDay = Date.now
                        canResetDate = false
                    }
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 6)
                    .background(Color.green)
                    .cornerRadius(16)
                }
            }
            .padding(.horizontal)
        }
    }

    private var remindersList: some View {
        TabView(selection: $swipeOffset) {
            ForEach(-6...6, id: \.self) { index in
                ScrollView {
                    LazyVStack(spacing: 12) {
                        formattedReminders(
                            userID: 1,
                            period: filterPeriod,
                            cur_screen: $cur_screen,
                            showEditButton: !isDeleteViewOn,
                            showDeleteButton: isDeleteViewOn,
                            filteredDay: calculateDateFor(),
                            firestoreManager: firestoreManager,
                            userData: remindersForUser
                        )
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                }
                .tag(index)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .onChange(of: swipeOffset) { _, _ in
            updateFilteredDay()
        }
    }

    private var footerToggles: some View {
        VStack(spacing: 12) {
            Toggle("Delete View", isOn: $isDeleteViewOn)
                .font(.title3)
                .fontWeight(.semibold)
                .toggleStyle(SwitchToggleStyle(tint: .red))
            Toggle(isOn: $showCalendarView) {
                Text("Calendar View")
                    .font(.title3)
                    .fontWeight(.semibold)
            }
            .toggleStyle(SwitchToggleStyle(tint: .green))
            .onChange(of: showCalendarView) { _, newValue in
                if newValue {
                    calendarViewType = filterPeriod == "today" ? "week" : filterPeriod
                }
            }
        }
        .padding(16)
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.blue.opacity(0.5), lineWidth: 2)
        )
        .padding(.horizontal)
        .padding(.top, 8)
    }

    private var calendarView: some View {
        CalendarView(cur_screen: $cur_screen, initialViewType: $calendarViewType, firestoreManager: firestoreManager)
            .onDisappear {
                if calendarViewType == "week" {
                    filterPeriod = "week"
                } else if calendarViewType == "month" {
                    filterPeriod = "month"
                }
            }
    }
    
    func updateFilteredDay() {
        let calendar = Calendar.current
        let today = Calendar.current.startOfDay(for: Date())
        
        switch filterPeriod {
        case "today":
            let baseDate = dayFilteredDay ?? Date()
            dayFilteredDay = calendar.date(byAdding: .day, value: swipeOffset, to: baseDate)
        case "week":
            let baseDate = weekFilteredDay ?? Date()
            weekFilteredDay = calendar.date(byAdding: .weekOfYear, value: swipeOffset, to: baseDate)
        case "month":
            let baseDate = monthFilteredDay ?? Date()
            monthFilteredDay = calendar.date(byAdding: .month, value: swipeOffset, to: baseDate)
        default:
            dayFilteredDay = today
            weekFilteredDay = today
            monthFilteredDay = today
        }

        if swipeOffset != 0 || displayedPeriodDiffersFromToday() {
            canResetDate = true
        }
        swipeOffset = 0
    }
    
    //Helper function that determines whether the period currently being displayed is different from today's period
    //Used to show/hide the reset button
    private func displayedPeriodDiffersFromToday() -> Bool {
        let cal = Calendar.current
        let today = Date()
        switch filterPeriod {
        case "today":
            if let d = dayFilteredDay {
                //checks if dayFilteredDay is the same as today (returns true if selected day is not today)
                return !cal.isDate(d, inSameDayAs: today)
            }
            return false
        case "week":
            if let d = weekFilteredDay {
                //compares weekFilteredDay's "week number" and year (ex. week 36, 2025) to today's
                let w1 = cal.component(.weekOfYear, from: d)
                let w2 = cal.component(.weekOfYear, from: today)
                let y1 = cal.component(.yearForWeekOfYear, from: d)
                let y2 = cal.component(.yearForWeekOfYear, from: today)
                return w1 != w2 || y1 != y2 //(returns true if weekFilteredDay is different from today's week)
            }
            return false
        case "month":
            if let d = monthFilteredDay {
                //compares monthFilteredDay's month and year to today's
                let m1 = cal.component(.month, from: d)
                let m2 = cal.component(.month, from: today)
                let y1 = cal.component(.year, from: d)
                let y2 = cal.component(.year, from: today)
                return m1 != m2 || y1 != y2 //(returns true if monthFilteredDay is different from today's week)
            }
            return false
        default:
            return false
        }
    }

    func calculateDateFor() -> Date {
        switch filterPeriod {
        case "today":
            let baseDate = dayFilteredDay ?? Date()
            let calculatedDate = Calendar.current.date(byAdding: .day, value: swipeOffset, to: baseDate) ?? baseDate
            return calculatedDate
        case "week":
            let baseDate = weekFilteredDay ?? Date()
            let calculatedDate = Calendar.current.date(byAdding: .weekOfYear, value: swipeOffset, to: baseDate) ?? baseDate
            return calculatedDate
        case "month":
            let baseDate = monthFilteredDay ?? Date()
            let calculatedDate = Calendar.current.date(byAdding: .month, value: swipeOffset, to: baseDate) ?? baseDate
            return calculatedDate
        default:
            return Date()
        }
    }
    
} //struct ending



struct ReminderRow: View {
    @Binding var cur_screen: Screen
    var title: String
    var time: String
    var reminderDate: String
    // Remove local copy of reminder
    @State var reminder: ReminderData
    var showEditButton: Bool = false
    var showDeleteButton: Bool = false
    //Used to show "mark as incomplete" alert
    @State private var showConfirmation = false
    //Used to show "delete" alert
    @State private var showDeleteConfirmation = false
    var userID: Int
    var dateKey: Date
    let firestoreManager: FirestoreManager
    @State private var curReminderDoc: DocumentSnapshot?

    //Formats 24-hour input time to 12-hour time with AM/PM
    var formattedTime: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        if let date = timeAsDate(time) {
            return formatter.string(from: date)
        }
        return time
    }


    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.title2)
                    .lineLimit(2)
                HStack(spacing: 12) {
                    //DONE BUTTON
                    Button(action: {
                        if let curReminder = curReminderDoc {
                            let isComplete = curReminder.data()?["isComplete"] as? Bool ?? false
                            if isComplete {
                                showConfirmation = true
                            } else {
                                firestoreManager.updateReminderFields(
                                    dateCreated: createExactStringFromDate(date: dateKey),
                                    fields: ["isComplete": true]
                                )
                            }
                        }

                    }) {
                        //database.users[userID]?[dateKey]?.isComplete == true
                        HStack(spacing: 6) {
                            Image(systemName: (curReminderDoc?.data()?["isComplete"] as? Bool ?? false) ? "checkmark.circle.fill" : "circle")
                                .font(.title2)
                                .foregroundColor((curReminderDoc?.data()?["isComplete"] as? Bool ?? false) ? .green : .gray)
                            Text("Done")
                                .font(.title3)
                                .bold()
                                .foregroundColor(.primary)
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .fixedSize()
                        
                    } // Button ending
                    
                    .alert("Are you sure you want to mark this reminder as incomplete?", isPresented: $showConfirmation) {
                        Button("Yes", role: .destructive) {
                            firestoreManager.updateReminderFields(
                                dateCreated: createExactStringFromDate(date: dateKey),
                                fields: ["isComplete": false]
                            )
                            //database.users[userID]![dateKey]!.isComplete = false
                        }
                        Button("Nevermind", role: .cancel) {}
                    } // Alert ending

                    //EDIT BUTTON
                    Button(action: {
                        print("dateKey is \(createExactStringFromDate(date: dateKey))")
                        print(reminder)
                    }) {
                        VStack {
                            Text("DATEKEY PRINT")
                        }
                    }
                    if showEditButton {
                        NavigationLink(destination: EditReminderScreen(
                            cur_screen: $cur_screen,
                            //reminderDoc: curReminderDoc,
                            reminder: Binding(
                                get: { reminder }, // local reminder copy
                                set: { newValue in
                                    // Update Firestore
                                    firestoreManager.updateReminderFields(
                                        dateCreated: createExactStringFromDate(date: dateKey),
                                        fields: [
                                            "title": newValue.title,
                                            "description": newValue.description,
                                            "priority": newValue.priority,
                                            "isComplete": newValue.isComplete,
                                            "isLocked": newValue.isLocked
                                        ]
                                    )
                                }
                            ),
                            firestoreManager: firestoreManager,
                            reminderID: createExactStringFromDate(date: dateKey)
                            //reminderID: createUniqueIDFromDate(date: dateKey)
                        )) {
                            
                            HStack(spacing: 6) {
                                Image(systemName: "pencil")
                                    .font(.title2)
                                Text("Edit")
                                    .font(.title3)
                                    .bold()
                                    .foregroundColor(.primary)
                            }
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                        }
                        .fixedSize()
                        
                      // DELETE BUTTON
                    } else if showDeleteButton {
                        Button(action: {
                            showDeleteConfirmation = true
                        }) {
                            HStack(spacing: 6) {
                                Image(systemName: "trash")
                                    .font(.title2)
                                    .foregroundColor(.red)
                                Text("Delete")
                                    .font(.body)
                                    .bold()
                                    .foregroundColor(.primary)
                            }
                        }
                        .fixedSize()
                        .alert("Are you sure you want to delete this reminder?", isPresented: $showDeleteConfirmation) {
                            Button("Yes", role: .destructive) {
                                //deleteFromDatabase(database: &database, userID: userID, date: dateKey)
                                firestoreManager.deleteReminder(
                                    dateCreated: createExactStringFromDate(date: dateKey)
                                )
                            }
                            Button("Nevermind", role: .cancel) {}
                        }
                    } // else if ending
                } // HStack ending
            } // VStack ending
            
            Spacer(minLength: 8)
            
            VStack(alignment: .trailing, spacing: 4) {
                Text(formattedTime)
                    .font(.title2)
                    .fontWeight(.semibold)
                Text(reminderDate)
                    .font(.body)
                    .foregroundColor(.secondary)
            }
        } // HStack ending
        .padding()
        .background(RoundedRectangle(cornerRadius: 12).stroke(Color.primary, lineWidth: 1))
        .onAppear {
            firestoreManager.getReminder(
                dateCreated: createExactStringFromDate(date: dateKey)
            ) { document in
                self.curReminderDoc = document
            }
        }
    }
}


#Preview {
    ContentView()
}

