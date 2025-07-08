import SwiftUI

struct RemindersScreen: View {
    //@Environment(\.dismiss) var dismiss also works for back button
    @Environment(\.presentationMode) private var
        presentationMode: Binding<PresentationMode>
    @State private var home1_pressed : Int = 1
    @State private var navigate_to_home_screen : Bool = false
    @State private var notifications : Bool = false
    @State private var isRemindersViewOn : Bool = false
    @State private var isDeleteViewOn : Bool = false
    @Binding var cur_screen: Screen
    @Binding var DatabaseMock: Database
    @State private var filterPeriod : String = "week"
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
            formatter.dateFormat = "MMMM yyyy"
            return formatter.string(from: today)
            
        default:
            return ""
        }
    }
    
    var body: some View {
        //NOTIFICATION BELL BUTTON
        VStack {
            HStack {
                NotificationBellExperience(cur_screen: $cur_screen, DatabaseMock: $DatabaseMock)
                    .padding(.trailing, 10)
                CreateReminderExperience(cur_screen: $cur_screen, DatabaseMock: $DatabaseMock)
            }
        }
        .frame(maxWidth: .infinity, alignment: .topTrailing)
            
        VStack {
            Text("Reminders")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            .padding()
            HStack {
                Button(action: {
                    //put actions here
                    filterPeriod = "today"
                }) {
                    Text("Day")
                        .font(.title)
                }
                .foregroundColor(filterPeriod == "today" ? .white : .black)
                .padding(.horizontal)
                .background(filterPeriod == "today" ? Color.blue: Color(.systemGray3))
                .cornerRadius(5)
                
                
                Button(action: {
                    //put actions here
                    filterPeriod = "week"
                }) {
                    Text("Week")
                        .font(.title)
                }
                    .foregroundColor(filterPeriod == "week" ? .white : .black)
                    .padding(.horizontal)
                    .background(filterPeriod == "week" ? Color.blue : Color(.systemGray3))
                    .cornerRadius(5)
                
                
                Button(action: {
                    //put actions here
                    filterPeriod = "month"
                }) {
                    Text("Month")
                        .font(.title)
                }
                .foregroundColor(filterPeriod == "month" ? .white : .black)
                .padding(.horizontal)
                .background(filterPeriod == "month" ? Color.blue : Color(.systemGray3))
                .cornerRadius(5)
                
                Button(action: {
                    //put actions here
                    
                }) {
                    Text("All")
                        .font(.title)
                }
                .foregroundColor(.black)
                .padding(.horizontal)
                .background(Color(.systemGray3))
                .cornerRadius(5)
                
            } //HStack ending
            .font(.headline)
            .padding(.bottom, 10)
            
            
            
            Text(currentPeriodText)
                .font(.title2)
                .foregroundColor(.black)
                .padding(.bottom, 10)
            
            ScrollView {
                formattedReminders(
                    database: $DatabaseMock,
                    userID: 1,
                    period: filterPeriod,
                    showEditButton: !isDeleteViewOn,
                    showDeleteButton: isDeleteViewOn
                )
            }
            .background(RoundedRectangle(cornerRadius: 12).stroke(Color.black, lineWidth: 2))
            .padding(.horizontal)
            
            //.border(Color.black, width: 1)
            //replace with filtering variable
            
            
            Toggle("Delete View", isOn: $isDeleteViewOn)
                .padding(.horizontal)
            Toggle("Calendar View", isOn: $isRemindersViewOn)
                .padding()
            
            //SwitchToggleStyle(.blue, "Week Calendar 2", isOn: .constant(false))
            
            Spacer()
        } //VStack ending
        
        VStack {
            NavigationBarExperience(cur_screen: $cur_screen, DatabaseMock: $DatabaseMock)
        }
    
    } //body ending
    
} //struct ending



struct ReminderRow: View {
    var title: String
    var time: String
    var date: String
    // Remove local copy of reminder
    @Binding var reminder: ReminderData
    var showEditButton: Bool = false
    var showDeleteButton: Bool = false
    @State private var showConfirmation = false
    @State private var showDeleteConfirmation = false
    @Binding var database: Database
    
    var userID: Int
    var dateKey: Date
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(title)
                    .font(.title2)
                HStack {
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
                    }
                    .alert("Are you sure you want to mark this reminder as incomplete?", isPresented: $showConfirmation) {
                        Button("Yes", role: .destructive) {
                            database.users[userID]![dateKey]!.isComplete = false
                        }
                        Button("Nevermind", role: .cancel) {}
                    }

                    if showEditButton {
                        Spacer().frame(width: 20)

                        NavigationLink(destination: EditReminderScreen()) {
                            HStack {
                                Image(systemName: "pencil")
                                    .font(.title3)
                                Text("Edit")
                                    .font(.title3)
                                    .bold()
                                    .foregroundColor(.black)
                            }
                        }
                        
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
                    }
                }
            } // VStack ending
            Spacer()
            VStack {
                Text(time)
                    .font(.title2)
                    .fontWeight(.semibold)
                Text(date)
                    .foregroundColor(.black)
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 12).stroke(Color.black, lineWidth: 1))
    }
}


#Preview {
    ContentView()
}
