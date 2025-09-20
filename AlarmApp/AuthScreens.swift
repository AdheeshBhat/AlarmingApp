//
//  AuthScreens.swift
//  AlarmApp
//
//  Created by Adheesh Bhat on 9/14/25.
//

import SwiftUI
import FirebaseAuth

struct LoginScreen: View {
    @Binding var cur_screen: Screen
    @Binding var DatabaseMock: Database
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var errorMessage: String = ""
    @State private var navigateToHome: Bool = false
    @State private var showRegistration: Bool = false
    let firestoreManager = FirestoreManager()

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                TextField("Email", text: $email)
                    .autocapitalization(.none)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress)

                SecureField("Password", text: $password)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .textContentType(.password)

                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundColor(.red)
                }

                Button(action: {
                    login()
                }) {
                    Text("Login")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                
                Button(action: {
                    showRegistration.toggle()
                }) {
                    Text("Register")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .padding()
            .navigationDestination(isPresented: $navigateToHome) {
                HomeView(DatabaseMock: $DatabaseMock, cur_screen: $cur_screen, firestoreManager: firestoreManager)
            }
            .navigationDestination(isPresented: $showRegistration) {
                RegistrationScreen(cur_screen: $cur_screen, DatabaseMock: $DatabaseMock)
            }
        }
    }

    private func login() {
        errorMessage = ""
        
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                errorMessage = error.localizedDescription
            } else {
                errorMessage = ""
                // Navigate to HomeScreen
                cur_screen = .HomeScreen
                navigateToHome = true
                
            }
        }
    }
}

struct RegistrationScreen: View {
    @Binding var cur_screen: Screen
    @Binding var DatabaseMock: Database
    @State private var email: String = ""
    @State private var name: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var isCaretaker: Bool = false
    @State private var errorMessage: String = ""
    @State private var navigateToHome: Bool = false
    let firestoreManager = FirestoreManager()

    var body: some View {
        VStack(spacing: 20) {
            TextField("Email", text: $email)
                .autocapitalization(.none)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .textContentType(.emailAddress)
                .keyboardType(.emailAddress)

            TextField("Full Name", text: $name)
                .autocapitalization(.words)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .textContentType(.name)

            SecureField("Password", text: $password)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .textContentType(.password)

            SecureField("Confirm Password", text: $confirmPassword)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .textContentType(.password)

            Toggle("Caretaker", isOn: $isCaretaker)
                .padding()

            Button(action: {
                register()
            }) {
                Text("Register")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            
            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
            }
        }
        .padding()
        .navigationDestination(isPresented: $navigateToHome) {
            HomeView(DatabaseMock: $DatabaseMock, cur_screen: $cur_screen, firestoreManager: firestoreManager)
        }
    }

    private func register() {
        errorMessage = ""
        guard password == confirmPassword else {
            errorMessage = "Passwords do not match."
            return
        }
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                errorMessage = error.localizedDescription
            } else if let user = authResult?.user {
                errorMessage = ""
                // Save additional user info to Firestore
                let userData: [String: Any] = [
                    "fullName": name,
                    "isCaretaker": isCaretaker,
                    "email": email,
                    "uid": user.uid
                ]
                firestoreManager.saveUserData(userId: user.uid, data: userData) { error in
                    if let error = error {
                        errorMessage = error.localizedDescription
                    } else {
                        // Navigate to HomeScreen
                        cur_screen = .HomeScreen
                        navigateToHome = true
                    }
                }
            }
        }
    }
}
