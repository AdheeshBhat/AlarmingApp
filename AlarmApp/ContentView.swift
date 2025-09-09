//
//  ContentView.swift
//  Alarm App

//  Created by Adheesh Bhat on 1/9/25.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore


class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    //let db = Firestore.firestore()
    print("Firebase and Firestore initialized for SwiftUI!")
    return true
  }
}

//create functions for all texts on the screen (ex. one function for "welcome and date")
enum Screen {
    case HomeScreen, RemindersScreen, NotificationsScreen, EditScreen, CreateReminderScreen, CalendarScreen, SettingsScreen, NotificationSettings, NotificationAlertSounds
}


struct ContentView: View {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @Environment(\.presentationMode) private var
        presentationMode: Binding<PresentationMode>
    @State public var cur_screen: Screen = .HomeScreen
    @StateObject var viewModel = ReminderViewModel()
    let firestoreManager = FirestoreManager()
    @State public var DatabaseMock =
                        //** Key is date on which the reminder is created
    Database(users: [1: [createDate(year: 2025, month: 8, day: 29, hour: 11, minute: 1, second: 1):
                                                //Date on which the reminders should trigger
                         ReminderData(ID: 1, date: createDate(year: 2025, month: 8, day: 29, hour: 11, minute: 1, second: 1), title: "Pay Utility Bill", description: "4/1/2025", repeatSettings: RepeatSettings(repeat_type: "None", repeat_until_date: "Specific Date"), priority: "Low", isComplete: true, author: "user", isLocked: false),
                         createDate(year: 2025, month: 9, day: 7, hour: 10, minute: 1, second: 1):
                            ReminderData(ID: 1, date: createDate(year: 2025, month: 9, day: 7, hour: 10, minute: 1, second: 1), title: "Make Doctor's Appointment",description: "3/31/2025", repeatSettings: RepeatSettings(repeat_type: "Daily", repeat_until_date: "Specific Date"), priority: "Low", isComplete: false, author: "user", isLocked: false),
                         createDate(year: 2025, month: 9, day: 7, hour: 9, minute: 1, second: 1):
                            ReminderData(ID: 1, date: createDate(year: 2025, month: 9, day: 7, hour: 9, minute: 1, second: 1), title: "Take Out Trash", description: "4/2/2025", repeatSettings: RepeatSettings(repeat_type: "Daily", repeat_until_date: "2025-07-30"), priority: "High", isComplete: false, author: "user", isLocked: false),
                         createDate(year: 2025, month: 9, day: 8, hour: 6, minute: 1, second: 1):
                            ReminderData(ID: 1, date: createDate(year: 2025, month: 9, day: 8, hour: 6, minute: 1, second: 1), title: "Pick up Groceries", description: "4/15/2025", repeatSettings: RepeatSettings(repeat_type: "None", repeat_until_date: "Specific Date"), priority: "Low", isComplete: false, author: "user", isLocked: false),
                         createDate(year: 2025, month: 9, day: 8, hour: 7, minute: 1, second: 1):
                            ReminderData(ID: 1, date: createDate(year: 2025, month: 9, day: 8, hour: 7, minute: 1, second: 1), title: "Water the Plants", description: "4/16/2025", repeatSettings: RepeatSettings(repeat_type: "None", repeat_until_date: "Specific Date"), priority: "Low", isComplete: false, author: "user", isLocked: false),
                         createDate(year: 2025, month: 9, day: 15, hour: 8, minute: 1, second: 1):
                            ReminderData(ID: 1, date: createDate(year: 2025, month: 9, day: 15, hour: 8, minute: 1, second: 1), title: "Example Title 1", description: "5/11/2025", repeatSettings: RepeatSettings(repeat_type: "None", repeat_until_date: "Specific Date"), priority: "Low", isComplete: false, author: "user", isLocked: false),
                         createDate(year: 2025, month: 10, day: 15, hour: 1, minute: 1, second: 1):
                            ReminderData(ID: 1, date: createDate(year: 2025, month: 10, day: 15, hour: 1, minute: 1, second: 1), title: "Example Title 2", description: "5/19/2025", repeatSettings: RepeatSettings(repeat_type: "None", repeat_until_date: "Specific Date"), priority: "Low", isComplete: false, author: "user", isLocked: false)],
                     2: [Date.now:
                            ReminderData(ID: 2, date: Date.now, title: "title reminder", description: "Test description 2", repeatSettings: RepeatSettings(repeat_type: "None", repeat_until_date: "Specific Date"), priority: "Low", isComplete: false, author: "user", isLocked: false)]])
    

    var body: some View {
        
        NavigationStack {
            HomeView(DatabaseMock: $DatabaseMock, cur_screen: $cur_screen, firestoreManager: firestoreManager)
        
        }
        
        .onAppear {
            requestNotificationPermission()
            //viewModel.addTestReminder()
            
//            let firestoreDB = Firestore.firestore() //this is calling the database (initializing it/making a new variable)
//            //writing will also be its own helper function
//            //this updates existing values, (doesn't create new values for the same key)
//            firestoreDB.collection("reminder").document("1").setData(["author": "Yousif"])
//            //make a helper function for delete field, delete document, delete collection, and update data
//                //for setData and updateData, make 2 helper functions each that pass in the full reminder or a specific field (one that passes in the full reminder and one that passes in a specific field
//            //firestoreDB.collection("reminder").document("1").setData(["author": "Yousif"])
//            //delete/update
//                //different helper function for deleting a field, document, or collection
//            //firestoreDB.collection("reminder").document("1").updateData(["author": FieldValue.delete()])
//            
//            //make this a helper function with "reminder" (collection) and "1" (document) as parameters
//                //collection and document are parameters
//            
//            firestoreDB.collection("reminder").document("1").getDocument{document, error in
//                if let document = document, document.exists {
//                    print(document.data()!["author"]!)
//                } else {
//                    print("Document doesn't exist")
//                }}

        }
    } //Body ending
        
} //Content View ending

#Preview {
    ContentView()
}
