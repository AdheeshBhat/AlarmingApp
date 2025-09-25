import SwiftUI

func filterReminders(userData: [Date: ReminderData], period: String, filteredDay: Date?) -> [Date: ReminderData] {
    switch period {
    case "today":
        return filterRemindersForToday(userData: userData, filteredDay: filteredDay)
    case "week":
        return filterRemindersForWeek(userData: userData, filteredDay: filteredDay)
    case "month":
        return filterRemindersForMonth(userData: userData, filteredDay: filteredDay)
    default:
        return userData
    }
}

struct TodayRemindersExperience: View {
    @Binding var cur_database: Database
    @Binding var cur_screen: Screen
    var isHideCompletedReminders: Bool
    var firestoreManager: FirestoreManager

    @State private var reminders: [Date: ReminderData] = [:]
    @State private var isLoading = true

    var body: some View {
        VStack {
            Text("Today's Reminders")
                .font(.title)
                .underline()

            if isLoading {
                Spacer()
                ProgressView("Loading...")
                Spacer()
            } else if reminders.isEmpty {
                Spacer()
                Text("No Pending Tasks! 🙂")
                    .font(.title)
                    .foregroundColor(.primary)
                Spacer()
            } else {
                let filteredReminders = filterReminders(userData: reminders, period: "today", filteredDay: nil)
                let visibleReminders = isHideCompletedReminders ? filteredReminders.filter { !$0.value.isComplete } : filteredReminders

                ScrollView {
                    if isHideCompletedReminders {
                        showIncompleteReminders(
                            database: $cur_database,
                            userID: 1,
                            period: "today",
                            cur_screen: $cur_screen,
                            showEditButton: false,
                            showDeleteButton: false,
                            filteredDay: nil,
                            firestoreManager: firestoreManager,
                            userData: visibleReminders
                        )
                    } else {
                        showAllReminders(
                            database: $cur_database,
                            userID: 1,
                            period: "today",
                            cur_screen: $cur_screen,
                            showEditButton: false,
                            showDeleteButton: false,
                            filteredDay: nil,
                            firestoreManager: firestoreManager,
                            userData: visibleReminders
                        )
                    }
                }
                .background(RoundedRectangle(cornerRadius: 12).stroke(Color.primary, lineWidth: 2))
                .padding(.horizontal)
            }

            Spacer()
        }
        .onAppear {
            firestoreManager.getRemindersForUser { fetchedReminders in
                if let fetchedReminders = fetchedReminders {
                    print("Fetched \(fetchedReminders.count) reminders")
                    for (date, reminder) in fetchedReminders {
                        print("Date: \(date), Title: \(reminder.title)")
                    }
                    DispatchQueue.main.async {
                        self.reminders = fetchedReminders
                        self.isLoading = false
                    }
                } else {
                    print("No reminders fetched")
                    DispatchQueue.main.async {
                        self.reminders = [:]
                        self.isLoading = false
                    }
                }
            }
        }
    }
}
