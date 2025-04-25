//
//  WelcomeExperience.swift
//  Alarm App
//
//  Created by Adheesh Bhat on 3/31/25.
//
import SwiftUI

func WelcomeExperience() -> some View {
    return VStack {
        
        Text("Welcome Adheesh!")
            .font(.largeTitle)
            .fontWeight(.bold)
            .padding(.top, 1.5)
            .padding(.bottom, 1)
        
        //loadSessionInfo function to show the date
        Text("Sunday, May 5th")
            .font(.title)
            .padding(.bottom)
    } //VStack ending
    
}

