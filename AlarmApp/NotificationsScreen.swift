////
////  Notifications_screen.swift
////  Alarm App
////
////  Created by Adheesh Bhat on 1/30/25.
////
//
//import SwiftUI
//
//struct NotificationsScreen: View {
//    @Environment(\.presentationMode) private var
//        presentationMode: Binding<PresentationMode>
//    @Binding var cur_screen: Screen
//    @Binding var DatabaseMock: Database
//    @State private var home2_pressed : Int = 2
//    @State private var notifications_pressed: Bool = false
//    @State private var navigate_to_home_screen_from_notis: Bool = false
//    @State private var navigate_to_reminders_screen_from_notis: Bool = false    
//    var body: some View {
//        //NOTIFICATION BELL BUTTON
//        //Bell button might not be necessary
////        VStack {
////            NotificationBellExperience(cur_screen: $cur_screen, DatabaseMock: $DatabaseMock)
////        }
//        
//        VStack {
//            
//            Text("Notification Center")
//                .font(.largeTitle)
//                .fontWeight(.bold)
//            
//        }
//        .padding(.top, 1.5)
//        .padding(.bottom, 1)
//        
//        
//        List {
//            ReminderRow2(title: "Pay Utility Bill", time: "03:30 PM", date: "Today")
//            ReminderRow2(title: "Make Doctor's Appointment", time: "05:45 AM", date: "May 6th")
//            ReminderRow2(title: "Reminder", time: "04:15 AM", date: "May 7th")
//        }
//            
//        VStack {
//            NavigationBarExperience(cur_screen: $cur_screen, DatabaseMock: $DatabaseMock)
//        }
//        
//    } //body ending
//    
//} //struct ending
//
//
//struct ReminderRow2: View {
//    var title: String
//    var time: String
//    var date: String
//    
//    var body: some View {
//        HStack {
//
//            VStack(alignment: .leading) {
//                Text("Unfinished Task: ")
//                    .font(.headline)
//                Text(title)
//                    
//                
//            }
//            Spacer()
//            Text(time)
//                .font(.headline)
//            Text(date)
//                .foregroundColor(.gray)
//        }
//        .padding()
//        .background(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 1))
//    }
//}
//
//
//#Preview {
//    ContentView()
//}
