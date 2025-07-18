//
//  RepeatSettingFlow.swift
//  AlarmApp
//
//  Created by Adheesh Bhat on 7/8/25.
//

import SwiftUI

struct RepeatSettingsFlow: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var cur_screen: Screen
    @Binding var DatabaseMock: Database
    @State var title: String
    @Binding var repeatSetting: String
    @State private var localRepeatSetting: String? = nil
    @Binding var repeatUntil: String
    @State private var localRepeatScreenRepeatUntil: String
    
    
    init(cur_screen: Binding<Screen>, DatabaseMock: Binding<Database>, title: String, repeatSetting: Binding<String>, repeatUntil: Binding<String> ) {
        self._cur_screen = cur_screen
        self._DatabaseMock = DatabaseMock
        self.title = title
        self._repeatSetting = repeatSetting
        self._repeatUntil = repeatUntil
        //local variables
        self._localRepeatSetting = State(initialValue: repeatSetting.wrappedValue)
        self._localRepeatScreenRepeatUntil = State(initialValue: repeatUntil.wrappedValue)
    }

    let options = ["None", "Daily", "Weekly", "Monthly", "Yearly", "Custom"]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(title)
                .font(.largeTitle)
                .padding()
                .frame(maxWidth: .infinity, alignment: .center)

            HStack {
                Text("Repeat")
                    .foregroundColor(.black)
                    .font(.title3)
                    .underline()
                Image(systemName: "arrow.2.circlepath")
                    .foregroundColor(.black)
                    .padding(.leading, 6)
            }
            .frame(maxWidth: .infinity, alignment: .center)

            VStack(spacing: 0) {
                ForEach(options.indices, id: \.self) { index in
                    Button(action: {
                        localRepeatSetting = options[index]
                    }) {
                        HStack {
                            Text(options[index])
                                .foregroundColor(.black)
                                .font(.title3)
                                .padding(.leading)
                            Spacer()
                            if options[index] == "Custom" {
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.black)
                                    .padding(.trailing)
                            }
                            if (localRepeatSetting == nil && repeatSetting == options[index]) || (localRepeatSetting == options[index]){
                                Image(systemName: "checkmark")
                                    .font(.title)
                                    .foregroundColor(Color(red: 0.0, green: 1, blue: 0.0))
                                    .padding(.trailing)
                            }
                        }
                        .padding(.vertical, 14)
                    }

                    if index < options.count - 1 {
                        Divider()
                            .background(Color.gray)
                            .padding(.horizontal, 20)
                    }
                }
            }
            .background(Color.blue.opacity(0.7))
            .cornerRadius(12)

            
            
            //REPEAT UNTIL BUTTON
            
            if (localRepeatSetting != "None" && localRepeatSetting != nil) {
                NavigationLink(destination: RepeatUntilFlow(title: title, cur_screen: $cur_screen, DatabaseMock: $DatabaseMock, repeatUntil: $localRepeatScreenRepeatUntil)) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Until")
                                .foregroundColor(.black)
                                .font(.title3)
                            Text(localRepeatScreenRepeatUntil)
                                .foregroundColor(.gray)
                                .font(.title3)
                        }
                        .padding(.leading)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.black)
                            .padding(.trailing)
                    }
                    .frame(maxWidth: .infinity, minHeight: 80)
                    .background(Color.blue.opacity(0.7))
                    .cornerRadius(12)
                    .padding(.top, 8)
                }
            }

            // DONE BUTTON
            Button(action: {
                if localRepeatSetting != nil {
                    repeatSetting = localRepeatSetting!
                }
                repeatUntil = localRepeatScreenRepeatUntil
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Done")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color(red: 0.0, green: 1, blue: 0.0))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue.opacity(0.7))
                    .cornerRadius(12)
            }
            .padding(.top)

            Spacer()
        }
        .padding()
        
        VStack {
            NavigationBarExperience(cur_screen: $cur_screen, DatabaseMock: $DatabaseMock)
        }
    }
}
