import SwiftUI

struct RemindersScreen: View {
    //@Environment(\.dismiss) var dismiss also works for back button
    @Environment(\.presentationMode) private var
        presentationMode: Binding<PresentationMode>
    @State private var navigate_to_home_screen : Bool = false
    @State private var notifications : Bool = false
    @State private var showCalendarView : Bool = false
    @State private var isDeleteViewOn : Bool = false
    @Binding var cur_screen: Screen
    @Binding var DatabaseMock: Database
    @State var filterPeriod : String
    @State var dayFilteredDay: Date? = Date()
    @State private var weekFilteredDay: Date? = Date()
    @State private var monthFilteredDay: Date? = Date()
    @State private var isEditingMonthYear: Bool = false
    @State private var swipeOffset: Int = 0
    @State private var calendarViewType: String = "month"
    @State private var canResetDate: Bool = false
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
        //TITLE + CREATE REMINDER BUTTON
        VStack {
            ZStack {
                //NotificationBellExperience(cur_screen: $cur_screen, DatabaseMock: $DatabaseMock)
                    //.padding(.trailing, 10)
                HStack {
                    SettingsExperience(cur_screen: $cur_screen, DatabaseMock: $DatabaseMock, firestoreManager: firestoreManager)
                    Spacer()
                }
                
                Text("Reminders")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top)

                HStack {
                    Spacer()
                    CreateReminderExperience(cur_screen: $cur_screen, DatabaseMock: $DatabaseMock, firestoreManager: firestoreManager)
                }
            } //ZStack ending
            .padding(.bottom)
        } //VStack ending
        
        
        VStack {
            //REMINDER FILTERS
            HStack(spacing: 0) {
                //DAY
                Button(action: {
                    filterPeriod = "today"
                }) {
                    Text("Day")
                        .font(.title)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical)
                        .background(filterPeriod == "today" ? Color.blue : Color(.systemGray3))
                        .foregroundColor(filterPeriod == "today" ? .white : .primary)
                }

                //WEEK
                Button(action: {
                    filterPeriod = "week"
                }) {
                    Text("Week")
                        .font(.title)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical)
                        .background(filterPeriod == "week" ? Color.blue : Color(.systemGray3))
                        .foregroundColor(filterPeriod == "week" ? .white : .primary)
                }

                //MONTH
                Button(action: {
                    filterPeriod = "month"
                }) {
                    Text("Month")
                        .font(.title)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical)
                        .background(filterPeriod == "month" ? Color.blue : Color(.systemGray3))
                        .foregroundColor(filterPeriod == "month" ? .white : .primary)
                }

            } //HStack ending (filters)
            .font(.headline)
            
            
            //Displays current period right below filters
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
                    .font(.title)
                    .foregroundColor(.primary)
            }
            //RESET BUTTON
            if canResetDate == true {
                Button("Reset") {
                    swipeOffset = 0
                    dayFilteredDay = Date.now
                    weekFilteredDay = Date.now
                    monthFilteredDay = Date.now
                    canResetDate = false
                }
                .font(.title2)
                .bold()
                .foregroundColor(.blue)
                .padding(.top, 5)
            }
            
        } //VStack ending
        
        VStack {
            //REMINDERS
            TabView(selection: $swipeOffset) {
                ForEach(-6...6, id: \.self) { index in
                    ScrollView {
                        formattedReminders(
                            database: $DatabaseMock,
                            userID: 1,
                            period: filterPeriod,
                            cur_screen: $cur_screen,
                            showEditButton: !isDeleteViewOn,
                            showDeleteButton: isDeleteViewOn,
                            filteredDay: calculateDateFor(),
                            firestoreManager: firestoreManager
                        )
                        
                    }
                    .tag(index)
                }
            }
            .background(RoundedRectangle(cornerRadius: 12).stroke(Color.primary, lineWidth: 2))
            .padding(.horizontal)
            .tabViewStyle(.page(indexDisplayMode: .never))
            .onChange(of: swipeOffset) { _, _ in
                updateFilteredDay()
            }
            //.frame(height: 400) // adjust as needed
        } //VStack ending
        Spacer()
        NavigationStack {
            VStack {
                //TOGGLES
                Toggle("Delete View", isOn: $isDeleteViewOn)
                    .font(.title3)
                    .padding(.horizontal)
                HStack {
                    Toggle(isOn: $showCalendarView) {
                        Text("Calendar View")
                            .font(.title3)
                    }
                    .onChange(of: showCalendarView) { _, newValue in
                        if newValue {
                            calendarViewType = filterPeriod == "today" ? "week" : filterPeriod
                        }
                    }
                }
                .padding()
            } //VStack ending
            .padding(.leading)
        } //NavigationStack ending
        .navigationDestination(isPresented: $showCalendarView) {
            CalendarView(cur_screen: $cur_screen, DatabaseMock: $DatabaseMock, initialViewType: $calendarViewType, firestoreManager: firestoreManager)
                .onDisappear {
                    if calendarViewType == "week" {
                        filterPeriod = "week"
                    } else if calendarViewType == "month" {
                        filterPeriod = "month"
                    }
                }
        }
        
        .onAppear {
            cur_screen = .RemindersScreen
            canResetDate = displayedPeriodDiffersFromToday()
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
        
        VStack {
            NavigationBarExperience(cur_screen: $cur_screen, DatabaseMock: $DatabaseMock, firestoreManager: firestoreManager)
        }
    
    } //body ending
    
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
    var date: String
    // Remove local copy of reminder
    @State var reminder: ReminderData
    var showEditButton: Bool = false
    var showDeleteButton: Bool = false
    //Used to show "mark as incomplete" alert
    @State private var showConfirmation = false
    //Used to show "delete" alert
    @State private var showDeleteConfirmation = false
    @Binding var database: Database
    var userID: Int
    var dateKey: Date
    let firestoreManager: FirestoreManager

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
        HStack {
            VStack(alignment: .leading) {
                Text(title)
                    .font(.title2)
                HStack {
                    //DONE BUTTON
                    Button(action: {
                        if database.users[userID]?[dateKey]?.isComplete == true {
                            showConfirmation = true
                        } else {
                            database.users[userID]![dateKey]!.isComplete.toggle()
                        }
                    }) {
                        HStack {
                            Image(systemName: database.users[userID]?[dateKey]?.isComplete == true ? "checkmark.circle.fill" : "circle")
                                .font(.title)
                                .foregroundColor(database.users[userID]?[dateKey]?.isComplete == true ? .green : .gray)
                            Text("Done")
                                .font(.title3)
                                .bold()
                                .foregroundColor(.primary)
                        }
                        
                    } // Button ending
                    
                    .alert("Are you sure you want to mark this reminder as incomplete?", isPresented: $showConfirmation) {
                        Button("Yes", role: .destructive) {
                            database.users[userID]![dateKey]!.isComplete = false
                        }
                        Button("Nevermind", role: .cancel) {}
                    } // Alert ending

                    //EDIT BUTTON
                    if showEditButton {
                        Spacer().frame(width: 20)

                        NavigationLink(destination: EditReminderScreen(
                            cur_screen: $cur_screen,
                            DatabaseMock: $database,
                            reminder: Binding(
                                get: { database.users[userID]![dateKey]! },
                                set: { database.users[userID]![dateKey]! = $0 }
                            ),
                            firestoreManager: firestoreManager
                        )) {
                            HStack {
                                Image(systemName: "pencil")
                                    .font(.title3)
                                Text("Edit")
                                    .font(.title3)
                                    .bold()
                                    .foregroundColor(.primary)
                            }
                        }
                        
                      // DELETE BUTTON
                    } else if showDeleteButton {
                        Spacer().frame(width: 20)
                        Button(action: {
                            showDeleteConfirmation = true
                        }) {
                            HStack {
                                Image(systemName: "trash")
                                    .font(.title3)
                                    .foregroundColor(.red)
                                Text("Delete")
                                    .font(.title3)
                                    .bold()
                                    .foregroundColor(.primary)
                            }
                        }
                        .alert("Are you sure you want to delete this reminder?", isPresented: $showDeleteConfirmation) {
                            Button("Yes", role: .destructive) {
                                deleteFromDatabase(database: &database, userID: userID, date: dateKey)
                            }
                            Button("Nevermind", role: .cancel) {}
                        }
                    } // else if ending
                    Spacer()
                } // HStack ending
            } // VStack ending
            Spacer()
            //Spacer()
            VStack {
                Text(formattedTime)
                    .font(.title2)
                    .fontWeight(.semibold)
                Text(date)
                    .foregroundColor(.primary)
            }
        } // HStack ending
        .padding()
        .background(RoundedRectangle(cornerRadius: 12).stroke(Color.primary, lineWidth: 1))
    }
}


#Preview {
    ContentView()
}
