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
            ScrollView {
                VStack(spacing: 30) {
                    Spacer(minLength: 60)
                    
                    // to do i hardcoded icon, but we should put img of our logo
                    VStack(spacing: 16) {
                        Text("🌟")
                            .font(.system(size: 80))
                        
                        Text("Hello there!") // To Do some welcome msg
                            .font(.title)
                            .fontWeight(.medium)
                            .foregroundColor(.blue)
                        
                        Text("decide name lol") // to DO
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        
                        Text("something we can say here if we want") // To DO
                            .font(.title3)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    .padding(.bottom, 20)
                    
                    // Login Form
                    VStack(spacing: 20) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Email")
                                .font(.title3)
                                .fontWeight(.medium)
                                .foregroundColor(.primary)
                            
                            TextField("Enter your email", text: $email)
                                .font(.title3)
                                .autocapitalization(.none)
                                .padding(16)
                                .background(Color(.systemBackground))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.blue.opacity(0.4), lineWidth: 2)
                                )
                                .textContentType(.emailAddress)
                                .keyboardType(.emailAddress)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Password")
                                .font(.title3)
                                .fontWeight(.medium)
                                .foregroundColor(.primary)
                            
                            SecureField("Enter your password", text: $password)
                                .font(.title3)
                                .padding(16)
                                .background(Color(.systemBackground))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.blue.opacity(0.4), lineWidth: 2)
                                )
                                .textContentType(.password)
                        }
                        
                        if !errorMessage.isEmpty {
                            Text(errorMessage)
                                .font(.title3)
                                .foregroundColor(.red)
                                .padding(.horizontal)
                                .multilineTextAlignment(.center)
                        }
                    }
                    .padding(.horizontal, 24)
                    
                    // Buttons
                    VStack(spacing: 16) {
                        Button(action: {
                            login()
                        }) {
                            Text("Sign In")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(18)
                                .background(Color.green)
                                .cornerRadius(12)
                        }
                        
                        Button(action: {
                            showRegistration.toggle()
                        }) {
                            Text("Create New Account")
                                .font(.title3)
                                .fontWeight(.medium)
                                .foregroundColor(.blue)
                                .frame(maxWidth: .infinity)
                                .padding(16)
                                .background(Color.blue.opacity(0.15))
                                .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal, 24)
                    
                    Spacer(minLength: 40)
                }
            }
            .background(Color(.systemBackground))
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

