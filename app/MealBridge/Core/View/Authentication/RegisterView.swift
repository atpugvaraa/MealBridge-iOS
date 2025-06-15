//
//  RegisterView.swift
//  MealBridge
//
//  Created by Aarav Gupta on 12/06/25.
//

import SwiftUI

struct RegisterView: View {
    @Environment(NavigationManager.self) var navigate
    
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var organization = ""
    @State private var userType = "NGO"
    @State private var showPassword = false
    @State private var showConfirmPassword = false
    
    private let userTypes = ["NGO", "Restaurant"]
    
    var body: some View {
        ZStack {
            Color.offWhite.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Join MealBridge")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .fontWidth(.expanded)
                            .foregroundColor(.black)
                        
                        Text("Create an account and start making a difference")
                            .font(.body)
                            .fontWeight(.medium)
                            .foregroundColor(.black.opacity(0.7))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .padding(.top, 32)
                    
                    // User Type Selection
                    VStack(alignment: .leading, spacing: 12) {
                        Text("I am a")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .fontWidth(.expanded)
                            .foregroundColor(.black)
                        
                        HStack(spacing: 12) {
                            ForEach(userTypes, id: \.self) { type in
                                Button {
                                    userType = type
                                } label: {
                                    ZStack {
                                        if userType == type {
                                            Rectangle()
                                                .foregroundStyle(.black)
                                                .offset(x: 2, y: 2)
                                        }
                                        
                                        Text(type)
                                            .font(.subheadline)
                                            .fontWeight(.semibold)
                                            .fontWidth(.expanded)
                                            .foregroundColor(.black)
                                            .padding(.horizontal, 20)
                                            .padding(.vertical, 12)
                                            .background(userType == type ? (type == "NGO" ? .pistachio : .atomicTangerine) : .white)
                                            .overlay(
                                                Rectangle()
                                                    .stroke(.black, lineWidth: 2)
                                            )
                                            .offset(x: userType == type ? 2 : 0, y: userType == type ? 2 : 0)
                                    }
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    // Form Fields
                    VStack(spacing: 16) {
                        RegisterFormField(title: "Full Name", text: $name, placeholder: "Enter your full name")
                        RegisterFormField(title: "Email", text: $email, placeholder: "Enter your email", keyboardType: .emailAddress)
                        RegisterFormField(title: "Organization", text: $organization, placeholder: userType == "NGO" ? "NGO Name" : "Restaurant Name")
                        
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
                                        TextField("Create password", text: $password)
                                    } else {
                                        SecureField("Create password", text: $password)
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
                        
                        // Confirm Password Field
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Confirm Password")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .fontWidth(.expanded)
                                .foregroundColor(.black)
                            
                            ZStack {
                                Rectangle()
                                    .foregroundStyle(.black)
                                    .offset(x: 2, y: 2)
                                
                                HStack {
                                    if showConfirmPassword {
                                        TextField("Confirm password", text: $confirmPassword)
                                    } else {
                                        SecureField("Confirm password", text: $confirmPassword)
                                    }
                                    
                                    Button {
                                        showConfirmPassword.toggle()
                                    } label: {
                                        Image(systemName: showConfirmPassword ? "eye.slash" : "eye")
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
                    
                    // Register Button
                    Button {
                        // Handle registration
                    } label: {
                        ZStack {
                            Rectangle()
                                .foregroundStyle(.black)
                                .offset(x: 3, y: 3)
                            
                            Text("Create Account")
                                .font(.headline)
                                .fontWeight(.bold)
                                .fontWidth(.expanded)
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                                .padding(18)
                                .background(userType == "NGO" ? .pistachio : .atomicTangerine)
                                .overlay(
                                    Rectangle()
                                        .stroke(.black, lineWidth: 2)
                                )
                        }
                    }
                    .disabled(!isFormValid)
                    .opacity(isFormValid ? 1.0 : 0.6)
                    .padding(.horizontal)
                    
                    // Login Link
                    HStack {
                        Text("Already have an account?")
                            .font(.subheadline)
                            .foregroundColor(.black.opacity(0.7))
                        
                        Button("Sign In") {
                            navigate.back()
                        }
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.steelBlue)
                    }
                    .padding(.bottom, 32)
                }
            }
        }
        .navigationBarBackButtonHidden(false)
    }
    
    private var isFormValid: Bool {
        !name.isEmpty && !email.isEmpty && !organization.isEmpty &&
        !password.isEmpty && password == confirmPassword && password.count >= 6
    }
}

struct RegisterFormField: View {
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
