//
//  NavigationBarExperience.swift
//  Alarm App
//
//  Created by Adheesh Bhat on 3/31/25.
//

import SwiftUI

struct NavigationBarExperience: View {
    //@Environment(\.presentationMode) var
        //presentationMode: Binding<PresentationMode>
    @Environment(\.dismiss) var dismiss
    @Binding var cur_screen: Screen
    @Binding var DatabaseMock: Database
    
    var body: some View {
        VStack {
            VStack {
                Rectangle()
                    .frame(width: 400, height: 2)
                
            }
            //.padding(.top, 300)
            
            HStack(spacing: 60) {
                
                //REMINDERS BUTTON
                VStack() {
                    if cur_screen != .RemindersScreen {
                        NavigationLink(destination: RemindersScreen(cur_screen: $cur_screen, DatabaseMock: $DatabaseMock, filterPeriod: "week")) {
                            Image(systemName: "list.bullet")
                                .font(.title)
                                .padding(7)
                                .foregroundColor((cur_screen == .RemindersScreen) ? Color.blue : Color.black)
                        }
                    } else {
                        Image(systemName: "list.bullet")
                            .font(.title)
                            .padding(7)
                            .foregroundColor(Color.blue)

                        
                    } //Navigation Link ending
                    
                    Text("Reminders")
                    
                } //VStack ending
                
                
                //HOME BUTTON

                VStack() {
                    if cur_screen != .HomeScreen {
                        NavigationLink(destination: HomeView(DatabaseMock: $DatabaseMock, cur_screen: $cur_screen)) {
                            Image(systemName: "house")
                                .font(.title)
                                .foregroundColor((cur_screen == .HomeScreen) ? Color.blue : Color.black)
                        }
                        .padding(4)
                    } else {
                        Image(systemName: "house")
                            .font(.title)
                            .foregroundColor(Color.blue)
                            .padding(4)
                    }
                    
                    Text("Home")
                    
                } //VStack ending
                
                //BACK BUTTON
                .navigationBarBackButtonHidden(true)
                
                VStack() {
                    Button(action: {
                        //presentationMode.wrappedValue.dismiss()
                        dismiss()
                    }) {
                        Image(systemName: "arrowshape.backward")
                            .font(.title)
                            .foregroundColor(.black)
                    }
                    .padding(1.5)
                    .background(RoundedRectangle(cornerRadius: 5).stroke(Color.black, lineWidth: 1))
                    .padding(4)
                    Text("Back")
                    
                } //VStack ending
            } //HStack ending
            .padding(.bottom, 2)
        } //VStack ending
    } //body ending
}
