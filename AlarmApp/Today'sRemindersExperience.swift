import SwiftUI

// Import utility functions
func getTitle(reminder: ReminderData) -> String {
    return reminder.title
}

func getTimeFromReminder(reminder: ReminderData) -> String {
    let formatter = DateFormatter()
    formatter.timeStyle = .short
    return formatter.string(from: reminder.date)
}

func getMonthFromReminder(reminder: ReminderData) -> String {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    return formatter.string(from: reminder.date)
}

func filterReminders(userData: [String: ReminderData], period: String, filteredDay: Date?) -> [String: ReminderData] {
    return userData.filter { (documentID, reminder) in
        let reminderDate = reminder.date
        let calendar = Calendar.current
        
        if period == "today" {
            let today = filteredDay ?? Date()
            let startOfDay = calendar.startOfDay(for: today)
            let endOfDay = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: startOfDay)!
            return reminderDate >= startOfDay && reminderDate <= endOfDay
        }
        return true
    }
}

struct TodayRemindersExperience: View {
    @Binding var cur_screen: Screen
    var isHideCompletedReminders: Bool
    var firestoreManager: FirestoreManager

    @State private var reminders: [String: ReminderData] = [:]
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
                    VStack {
                        ForEach(visibleReminders.sorted(by: { $0.value.date < $1.value.date }), id: \.key) { (documentID, reminder) in
                            ReminderRow(
                                cur_screen: $cur_screen,
                                title: getTitle(reminder: reminder),
                                time: getTimeFromReminder(reminder: reminder),
                                reminderDate: getMonthFromReminder(reminder: reminder),
                                reminder: reminder,
                                showEditButton: false,
                                showDeleteButton: false,
                                userID: 1,
                                dateKey: reminder.date,
                                documentID: documentID,
                                firestoreManager: firestoreManager
                            )
                        }
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
                    for (documentID, reminder) in fetchedReminders {
                        print("DocumentID: \(documentID), Title: \(reminder.title)")
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
