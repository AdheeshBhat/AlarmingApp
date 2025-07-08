//
//  CreateReminderButton.swift
//  AlarmApp
//
//  Created by Adheesh Bhat on 5/28/25.
//

import SwiftUI

struct CreateReminderExperience: View {
    @Binding var cur_screen: Screen
    @Binding var DatabaseMock: Database

    var body: some View {
        NavigationLink(destination: CreateReminderScreen(cur_screen: $cur_screen, DatabaseMock: $DatabaseMock)) {
            Image(systemName: "plus")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white)
                .padding(10)
                .background(Circle().fill(Color.blue))
        }
        .padding(.trailing, 20) 
    }
}
