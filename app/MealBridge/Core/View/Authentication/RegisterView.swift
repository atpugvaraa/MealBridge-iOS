//
//  RegisterView.swift
//  MealBridge
//
//  Created by Aarav Gupta on 12/06/25.
//

import SwiftUI

struct RegisterView: View {
    @Environment(NavigationManager.self) var navigate
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var authManager: AuthManager
    
    @State private var scrollOffset: CGFloat = 0
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var organization = ""
    @State private var city = ""
    @State private var pincode = ""
    @State private var googleMapLink = ""
    @State private var userType = "NGO"
    @State private var showPassword = false
    @State private var showConfirmPassword = false
    
    private let userTypes = ["NGO", "Restaurant"]
    
    var body: some View {
        ZStack {
            Color.offWhite.ignoresSafeArea()
            
            NavigationBarView(title: "Register", scrollOffset: $scrollOffset) {
                VStack(spacing: 0) {
                    // Custom back button
                    ScrollView {
                        VStack(spacing: 24) {
                            // Header
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Create an account and start making a difference")
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
                            
                            // User Type Selection
                            VStack(alignment: .leading, spacing: 12) {
                                Text("We are a/an")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                    .fontWidth(.expanded)
                                    .foregroundColor(.black)
                                
                                HStack(spacing: 12) {
                                    ForEach(userTypes, id: \.self) { type in
                                        ZStack {
                                            Rectangle()
                                                .foregroundStyle(.black)
                                                .offset(x: 2, y: 2)
                                            
                                            Rectangle()
                                                .fill(userType == type ? (type == "NGO" ? .pistachio : .atomicTangerine) : .white)
                                                .stroke(.black, lineWidth: 2)
                                                .offset(x: userType == type ? 2 : -2, y: userType == type ? 2 : -2)
                                            
                                            Text(type)
                                                .font(.subheadline)
                                                .fontWeight(.semibold)
                                                .fontWidth(.expanded)
                                                .foregroundColor(.black)
                                                .padding(.horizontal, 20)
                                                .padding(.vertical, 12)
                                                .offset(x: userType == type ? 2 : -2, y: userType == type ? 2 : -2)
                                        }
                                        .onTapGesture {
                                            withAnimation {
                                                userType = type
                                            }
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal)
                            
                            // Form Fields
                            VStack(spacing: 16) {
                                RegisterFormField(title: "Full Name", text: $name, placeholder: "Enter your full name")
                                RegisterFormField(title: "Email", text: $email, placeholder: "Enter your email", keyboardType: .emailAddress)
                                RegisterFormField(title: "Organization", text: $organization, placeholder: userType == "NGO" ? "NGO Name" : "Restaurant Name")
                                RegisterFormField(title: "City", text: $city, placeholder: "Enter your city")
                                RegisterFormField(title: "Pincode", text: $pincode, placeholder: "Enter pincode", keyboardType: .numberPad)
                                RegisterFormField(title: "Google Maps Link (Optional)", text: $googleMapLink, placeholder: "Paste Google Maps link")
                                
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
                                        
                                        Rectangle()
                                            .fill(.offWhite)
                                            .stroke(.black, lineWidth: 2)
                                            .offset(x: -2, y: -2)
                                        
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
                                        
                                        Rectangle()
                                            .fill(.offWhite)
                                            .stroke(.black, lineWidth: 2)
                                            .offset(x: -2, y: -2)
                                        
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
                                    }
                                }
                            }
                            .padding(.horizontal)
                            
                            // Register Button
                            Button {
                                let registerData = RegisterRequest(
                                    email: email,
                                    password: password,
                                    name: name,
                                    organization: organization,
                                    userType: userType,
                                    city: city.isEmpty ? nil : city,
                                    pincode: pincode.isEmpty ? nil : pincode,
                                    googleMapLink: googleMapLink.isEmpty ? nil : googleMapLink
                                )
                                authManager.register(userData: registerData)
                            } label: {
                                ZStack {
                                    Rectangle()
                                        .foregroundStyle(.black)
                                        .offset(x: 3, y: 3)
                                    
                                    Rectangle()
                                        .fill(userType == "NGO" ? .pistachio : .atomicTangerine)
                                        .stroke(.black, lineWidth: 2)
                                        .offset(x: -3, y: -3)
                                    
                                    HStack {
                                        if authManager.isLoading {
                                            ProgressView()
                                                .progressViewStyle(CircularProgressViewStyle(tint: .black))
                                                .scaleEffect(0.8)
                                        } else {
                                            Text("Create Account")
                                                .font(.headline)
                                                .fontWeight(.bold)
                                                .fontWidth(.expanded)
                                                .foregroundColor(.black)
                                        }
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding(18)
                                }
                            }
                            .disabled(!isFormValid || authManager.isLoading)
                            .opacity(isFormValid && !authManager.isLoading ? 1.0 : 0.6)
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
            }
        }
        .navigationBarBackButtonHidden(true)
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
                
                Rectangle()
                    .fill(.offWhite)
                    .stroke(.black, lineWidth: 2)
                    .offset(x: -2, y: -2)
                
                TextField(placeholder, text: $text)
                    .keyboardType(keyboardType)
                    .autocapitalization(keyboardType == .emailAddress ? .none : .words)
                    .padding(16)
            }
        }
    }
}
