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
    @State var filteredDay: Date? = nil
    @State private var isEditingMonthYear: Bool = false
    
    //create a variable that would change the period depending on the button pressed
    var currentPeriodText: String {
        let today = Date()
        
        switch filterPeriod {
        case "today":
            return dayString(from: filteredDay ?? today)
            
        case "week":
            return weekString(from: filteredDay ?? today)
            
        case "month":
            return monthString(filteredDay ?? today) + " " + yearString(filteredDay ?? today)
            
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
                
                Text("Reminders")
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
                        .foregroundColor(filterPeriod == "today" ? .white : .black)
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
                        .foregroundColor(filterPeriod == "week" ? .white : .black)
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
                        .foregroundColor(filterPeriod == "month" ? .white : .black)
                }

            } //HStack ending (filters)
            .font(.headline)
            
            
            //Displays current period right below filters
            if filterPeriod == "month" {
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
        } //VStack ending
        
        VStack {
            //REMINDERS
            ScrollView {
                formattedReminders(
                    database: $DatabaseMock,
                    userID: 1,
                    period: filterPeriod,
                    cur_screen: $cur_screen,
                    showEditButton: !isDeleteViewOn,
                    showDeleteButton: isDeleteViewOn,
                    filteredDay: filteredDay
                )
            }
            .background(RoundedRectangle(cornerRadius: 12).stroke(Color.black, lineWidth: 2))
            .padding(.horizontal)
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
                    .onChange(of: showCalendarView) {
                        if showCalendarView {
                            cur_screen = .RemindersScreen
                        }
                    }
                }
                .padding()
            } //VStack ending
            .padding(.leading)
        } //NavigationStack ending
        .navigationDestination(isPresented: $showCalendarView) {
            CalendarView(cur_screen: $cur_screen, DatabaseMock: $DatabaseMock)
        }
        
        .onAppear {
            cur_screen = .RemindersScreen
        }
        
        VStack {
            NavigationBarExperience(cur_screen: $cur_screen, DatabaseMock: $DatabaseMock)
        }
    
    } //body ending
    
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
                                .foregroundColor(.black)
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
                            )
                        )) {
                            HStack {
                                Image(systemName: "pencil")
                                    .font(.title3)
                                Text("Edit")
                                    .font(.title3)
                                    .bold()
                                    .foregroundColor(.black)
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
                                    .foregroundColor(.black)
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
                    .foregroundColor(.black)
            }
        } // HStack ending
        .padding()
        .background(RoundedRectangle(cornerRadius: 12).stroke(Color.black, lineWidth: 1))
    }
}


#Preview {
    ContentView()
}
