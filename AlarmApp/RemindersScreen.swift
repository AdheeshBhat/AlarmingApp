import SwiftUI

struct RemindersScreen: View {
    //@Environment(\.dismiss) var dismiss also works for back button
    @Environment(\.presentationMode) private var
        presentationMode: Binding<PresentationMode>
    @State private var navigate_to_home_screen : Bool = false
    @State private var notifications : Bool = false
    @State private var isRemindersViewOn : Bool = false
    @State private var isDeleteViewOn : Bool = false
    @Binding var cur_screen: Screen
    @Binding var DatabaseMock: Database
    @State var filterPeriod : String
    @State var filteredDay: Date? = nil
    @State private var isEditingMonthYear: Bool = false
    
    //create a variable that would change the period depending on the button pressed
    var currentPeriodText: String {
        let today = Date()
        let calendar = Calendar.current
        let formatter = DateFormatter()
        
        switch filterPeriod {
        case "today":
            formatter.dateFormat = "EEEE, MMM d"
            return formatter.string(from: today)
            
        case "week":
            let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today))!
            let endOfWeek = calendar.date(byAdding: .day, value: 6, to: startOfWeek)!
            formatter.dateFormat = "MMM d"
            return "\(formatter.string(from: startOfWeek)) – \(formatter.string(from: endOfWeek))"
            
        case "month":
            if filteredDay != nil {
                formatter.dateFormat = "MMMM yyyy"
                return formatter.string(from: filteredDay!)
            }
            formatter.dateFormat = "MMMM yyyy"
            return formatter.string(from: today)
            
        default:
            return ""
        }
    }
    
    var body: some View {
        //NOTIFICATION BELL BUTTON + CREATE REMINDER BUTTON
        VStack {
            HStack {
                //NotificationBellExperience(cur_screen: $cur_screen, DatabaseMock: $DatabaseMock)
                    //.padding(.trailing, 10)
                CreateReminderExperience(cur_screen: $cur_screen, DatabaseMock: $DatabaseMock)
            }
            .frame(maxWidth: .infinity, alignment: .topTrailing)
        }
        
        
        VStack {
            Text("Reminders")
                .font(.largeTitle)
                .fontWeight(.bold)
            
                .padding(.bottom)
        }
        
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

                //ALL
                NavigationLink(
                    destination: AllRemindersScreen(cur_screen: $cur_screen, DatabaseMock: $DatabaseMock)
                ) {
                    Text("All")
                        .font(.title)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical)
                        .background(Color(.systemGray3))
                        .foregroundColor(.black)
                }
            }
            .padding(.horizontal, 0)
            .font(.headline)
            .padding(.bottom, 10)
            
            
            //Displays current period right below filters
            if filterPeriod == "month" {
                if isEditingMonthYear {
                    VStack {
                        HStack {
                            //MONTH PICKER
                            Picker("Month", selection: Binding(
                                get: {
                                    Calendar.current.component(.month, from: filteredDay ?? Date()) - 1
                                },
                                set: { newValue in
                                    let calendar = Calendar.current
                                    var components = calendar.dateComponents([.year, .day], from: filteredDay ?? Date())
                                    components.month = newValue + 1
                                    components.day = 1
                                    if let newDate = calendar.date(from: components) {
                                        filteredDay = newDate
                                    }
                                }
                            )) {
                                ForEach(0..<12) { index in
                                    Text(Calendar.current.monthSymbols[index])
                                        .font(.title2)
                                        .tag(index)
                                }
                            } //Picker ending
                            .pickerStyle(.wheel)
                            .frame(maxWidth: .infinity)
                            
                            //YEAR PICKER
                            Picker("Year", selection: Binding(
                                get: {
                                    Calendar.current.component(.year, from: filteredDay ?? Date())
                                },
                                set: { newValue in
                                    let calendar = Calendar.current
                                    var components = calendar.dateComponents([.month, .day], from: filteredDay ?? Date())
                                    components.year = newValue
                                    components.day = 1
                                    if let newDate = calendar.date(from: components) {
                                        filteredDay = newDate
                                    }
                                }
                            )) {
                                ForEach(2020...2080, id: \.self) { year in
                                    Text(String(year))
                                        .font(.title2)
                                        .tag(year)
                                }
                            } //Picker ending
                            .pickerStyle(.wheel)
                            .frame(maxWidth: .infinity)
                        } //HStack ending
                        .frame(height: 100)
                        
                        HStack {
                            //DONE BUTTON
                            Button(action: {
                                isEditingMonthYear = false
                            }) {
                                Text("Done")
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.green)
                            } //Reset button ending
                            .padding(.horizontal)
                            
                            //RESET BUTTON
                            Button(action: {
                                let now = Date()
                                let calendar = Calendar.current
                                var components = calendar.dateComponents([.year, .month], from: now)
                                components.day = 1
                                if let currentDate = calendar.date(from: components) {
                                    filteredDay = currentDate
                                }
                            }) {
                                Text("Reset")
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.blue)
                            } // Done button ending
                        } //HStack ending
                        
                        
                    } //VStack ending
                } else {
                    Text(currentPeriodText)
                        .font(.title2)
                        .foregroundColor(.black)
                        .onTapGesture {
                            isEditingMonthYear = true
                        }
                        .padding(.bottom, 10)
                }
            } else {
                Text(currentPeriodText)
                    .font(.title2)
                    .foregroundColor(.black)
                    .padding(.bottom, 10)
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
        
        VStack {
            //TOGGLES
            Toggle("Delete View", isOn: $isDeleteViewOn)
                .font(.title3)
                .padding(.horizontal)
            Toggle("Calendar View", isOn: $isRemindersViewOn)
                .font(.title3)
                .padding()
        } //VStack ending
        .padding(.leading)
        
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
