//
//  NotificationBellExperience.swift
//  Alarm App
//
//  Created by Adheesh Bhat on 3/31/25.
//
import SwiftUI

struct NotificationBellExperience: View {
    @State var notifications : Bool = false
    @Binding var cur_screen: Screen
    @Binding var DatabaseMock: Database
    var body: some View {
        //NOTIFICATION BUTTON
        VStack {
            NavigationLink(destination: NotificationsScreen(cur_screen: $cur_screen, DatabaseMock: $DatabaseMock)) {
                HStack {
                    
                    Image(systemName: "bell.badge")
                        .font(.title)
                        .foregroundColor(.black)
                }
                .padding(.leading, 270)
                
            } //Navigation Link ending
        } //VStack ending
    } //body ending

}
    
