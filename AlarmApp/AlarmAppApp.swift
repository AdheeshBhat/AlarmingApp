//
//  AlarmAppApp.swift
//  AlarmApp
//
//  Created by Adheesh Bhat on 4/21/25.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore

@main
struct AlarmAppApp: App {
    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
