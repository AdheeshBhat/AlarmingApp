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
    
    var body: some View {

        NavigationStack {
            //HomeView(cur_screen: $cur_screen, firestoreManager: firestoreManager)
            //TestRemindersView()
            LoginScreen(cur_screen: $cur_screen)
        }
        
        .onAppear {
            requestNotificationPermission()
            //viewModel.addTestReminder()


        }
    } //Body ending
        
} //Content View ending

#Preview {
    ContentView()
}
