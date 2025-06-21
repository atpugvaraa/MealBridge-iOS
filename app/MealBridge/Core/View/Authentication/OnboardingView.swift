//
//  OnboardingView.swift
//  MealBridge
//
//  Created by Aarav Gupta on 12/06/25.
//

import SwiftUI

struct OnboardingView: View {
    @AppStorage("isOnboarding") var isOnboarding = true
    @Environment(NavigationManager.self) var navigate
    
    var body: some View {
        ZStack {
            Color.offWhite.ignoresSafeArea()
            
            VStack(spacing: 32) {
                Spacer()
                
                // App Logo/Icon
                ZStack {
                    Circle()
                        .fill(Color.black)
                        .frame(width: 120, height: 120)
                        .offset(x: 3, y: 3)
                    
                    Circle()
                        .fill(Color.atomicTangerine)
                        .frame(width: 120, height: 120)
                        .overlay(
                            Circle()
                                .stroke(.black, lineWidth: 3)
                        )
                    
                    Image(systemName: "heart.fill")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(.black)
                }
                
                // Title and Description
                VStack(spacing: 16) {
                    Text("MealBridge")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .fontWidth(.expanded)
                        .foregroundColor(.black)
                    
                    Text("Connecting surplus food with those in need")
                        .font(.headline)
                        .fontWeight(.medium)
                        .foregroundColor(.black.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                }
                
                Spacer()
                
                // Action Buttons
                VStack(spacing: 16) {
                    Button {
                        navigate.to(.register)
                    } label: {
                        ZStack {
                            Rectangle()
                                .foregroundStyle(.black)
                                .offset(x: 3, y: 3)
                            
                            Text("Get Started")
                                .font(.headline)
                                .fontWeight(.bold)
                                .fontWidth(.expanded)
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                                .padding(18)
                                .background(.pistachio)
                                .overlay(
                                    Rectangle()
                                        .stroke(.black, lineWidth: 2)
                                )
                        }
                    }
                    .padding(.horizontal, 32)
                    
                    Button {
                        navigate.to(.login)
                    } label: {
                        Text("Already have an account? Sign In")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.steelBlue)
                    }
                }
                
                Button {
                    isOnboarding = false
                } label: {
                    Text("Skip for now")
                        .font(.caption)
                        .foregroundColor(.black.opacity(0.5))
                }
                .padding(.bottom, 32)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    OnboardingView()
}
