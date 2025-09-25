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
            .padding(.bottom, 1)
             
        Text(getStringFromCurrentDate())
            .font(.title)
            .padding(.bottom)
    } //VStack ending
    
}

