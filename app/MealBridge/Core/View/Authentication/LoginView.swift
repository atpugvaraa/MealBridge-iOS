//
//  LoginView.swift
//  MealBridge
//
//  Created by Aarav Gupta on 15/06/25.
//

import SwiftUI

struct LoginView: View {
    @Environment(NavigationManager.self) var navigate
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var authManager: AuthManager
    
    @State private var scrollOffset: CGFloat = 0
    @State private var email = ""
    @State private var password = ""
    @State private var showPassword = false
    
    var body: some View {
        ZStack {
            Color.offWhite.ignoresSafeArea()
            
            NavigationBarView(title: "Welcome Back", scrollOffset: $scrollOffset) {
                VStack(spacing: 0) {
                    ScrollView {
                        VStack(spacing: 24) {
                            // Header
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Sign in to your MealBridge account")
                                    .font(.body)
                                    .fontWeight(.medium)
                                    .foregroundColor(.black.opacity(0.7))
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                            .padding(.top, 32)
                            
                            // Error Message
                            if let errorMessage = authManager.errorMessage {
                                Text(errorMessage)
                                    .foregroundColor(.red)
                                    .font(.caption)
                                    .padding(.horizontal)
                            }
                            
                            // Form Fields
                            VStack(spacing: 16) {
                                LoginFormField(title: "Email", text: $email, placeholder: "Enter your email", keyboardType: .emailAddress)
                                
                                // Password Field
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Password")
                                        .font(.headline)
                                        .fontWeight(.semibold)
                                        .fontWidth(.expanded)
                                        .foregroundColor(.black)
                                    
                                    ZStack {
                                        Rectangle()
                                            .foregroundStyle(.black)
                                            .offset(x: 2, y: 2)
                                        
                                        HStack {
                                            if showPassword {
                                                TextField("Enter password", text: $password)
                                            } else {
                                                SecureField("Enter password", text: $password)
                                            }
                                            
                                            Button {
                                                showPassword.toggle()
                                            } label: {
                                                Image(systemName: showPassword ? "eye.slash" : "eye")
                                                    .foregroundColor(.black.opacity(0.6))
                                            }
                                        }
                                        .padding(16)
                                        .background(.white)
                                        .overlay(
                                            Rectangle()
                                                .stroke(.black, lineWidth: 2)
                                        )
                                    }
                                }
                            }
                            .padding(.horizontal)
                            
                            // Login Button
                            Button {
                                authManager.login(email: email, password: password)
                            } label: {
                                ZStack {
                                    Rectangle()
                                        .foregroundStyle(.black)
                                        .offset(x: 3, y: 3)
                                    
                                    HStack {
                                        if authManager.isLoading {
                                            ProgressView()
                                                .progressViewStyle(CircularProgressViewStyle(tint: .black))
                                                .scaleEffect(0.8)
                                        } else {
                                            Text("Sign In")
                                                .font(.headline)
                                                .fontWeight(.bold)
                                                .fontWidth(.expanded)
                                                .foregroundColor(.black)
                                        }
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding(18)
                                    .background(.steelBlue)
                                    .overlay(
                                        Rectangle()
                                            .stroke(.black, lineWidth: 2)
                                    )
                                }
                            }
                            .disabled(!isFormValid || authManager.isLoading)
                            .opacity(isFormValid && !authManager.isLoading ? 1.0 : 0.6)
                            .padding(.horizontal)
                            
                            // Register Link
                            HStack {
                                Text("Don't have an account?")
                                    .font(.subheadline)
                                    .foregroundColor(.black.opacity(0.7))
                                
                                Button("Sign Up") {
                                    navigate.to(.register)
                                }
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.steelBlue)
                            }
                            .padding(.bottom, 32)
                        }
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    private var isFormValid: Bool {
        !email.isEmpty && !password.isEmpty && password.count >= 6
    }
}

struct LoginFormField: View {
    let title: String
    @Binding var text: String
    let placeholder: String
    var keyboardType: UIKeyboardType = .default
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .fontWeight(.semibold)
                .fontWidth(.expanded)
                .foregroundColor(.black)
            
            ZStack {
                Rectangle()
                    .foregroundStyle(.black)
                    .offset(x: 2, y: 2)
                
                TextField(placeholder, text: $text)
                    .keyboardType(keyboardType)
                    .autocapitalization(keyboardType == .emailAddress ? .none : .words)
                    .padding(16)
                    .background(.white)
                    .overlay(
                        Rectangle()
                            .stroke(.black, lineWidth: 2)
                    )
            }
        }
    }
}
