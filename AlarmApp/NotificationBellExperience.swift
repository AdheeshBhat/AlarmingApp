//
//  NotificationBellExperience.swift
//  Alarm App
//
//  Created by Adheesh Bhat on 3/31/25.
//
import SwiftUI

struct NotificationBellExperience: View {
    @Binding var cur_screen: Screen
    @Binding var DatabaseMock: Database
    var body: some View {
        //NOTIFICATION BUTTON
        VStack {
            //NavigationLink(destination: )) {
                HStack {
                    
                    Image(systemName: "bell")
                        .font(.title2)
                        .foregroundColor(.black)
                }
                //.padding(.leading, 270)
                
           //} //Navigation Link ending
        } //VStack ending
    } //body ending

}
    
