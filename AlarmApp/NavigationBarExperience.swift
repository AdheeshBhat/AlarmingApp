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
    @State var home_pressed : Int = 0
    @State var reminders : Bool = false
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
                //NavigationStack {
                VStack() {
                    NavigationLink(destination: RemindersScreen(cur_screen: $cur_screen, DatabaseMock: $DatabaseMock, filterPeriod: "week")) {
                        //Button(action: {
                        //home_pressed = 1
                        //reminders = true
                        
                        //}) {
                        Image(systemName: "list.bullet")
                            .font(.title)
                        //.foregroundColor(home_pressed == 1 ? Color.blue : Color.black)
                        
                        //} //button ending
                            .padding(7)
                        
                        
                    } //Navigation Link ending
                    
                    Text("Reminders")
                    
                } //VStack ending
                //} //Navigation Stack ending
                
                
                
                //HOME BUTTON
                
                VStack() {
                    NavigationLink(destination: HomeView(DatabaseMock: $DatabaseMock, cur_screen: $cur_screen)) {
                        Image(systemName: "house")
                            .font(.title)
                    }
                    //Button(action: {
                    //home_pressed = 0
                    //}) {
                    //Image(systemName: "house")
                    //.font(.title)
                    //.foregroundColor(home_pressed == 0 ? Color.blue : Color.black)
                    //}
                    .padding(4)
                    
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
