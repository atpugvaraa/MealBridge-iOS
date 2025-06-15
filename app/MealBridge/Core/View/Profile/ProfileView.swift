//
//  ProfileView.swift
//  MealBridge
//
//  Created by Aarav Gupta on 12/06/25.
//

import SwiftUI

struct ProfileView: View {
    @Environment(NavigationManager.self) var navigate
    @State private var scrollOffset: CGFloat = 0
    
    var body: some View {
        ZStack {
            Color.offWhite.ignoresSafeArea()
            
            NavigationBarView(title: "", scrollOffset: $scrollOffset, showBackButton: true) {
                content
            }
            .navigationBarBackButtonHidden()
        }
    }
    
    var content: some View {
        VStack(spacing: 24) {
            // Profile Header
            VStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(.black)
                        .frame(width: 102, height: 102)
                        .offset(x: 3, y: 3)
                    
                    Circle()
                        .fill(.atomicTangerine)
                        .frame(width: 100, height: 100)
                        .overlay(
                            Circle()
                                .stroke(.black, lineWidth: 3)
                        )
                        .overlay(
                            Text("JD")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                        )
                }
                
                VStack(spacing: 8) {
                    Text("John Doe")
                        .font(.title2)
                        .fontWeight(.bold)
                        .fontWidth(.expanded)
                        .foregroundColor(.black)
                    
                    Text("Green Valley NGO")
                        .font(.subheadline)
                        .foregroundColor(.black.opacity(0.7))
                    
                    HStack(spacing: 4) {
                        Circle()
                            .fill(.pistachio)
                            .frame(width: 8, height: 8)
                        
                        Text("Active")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.black.opacity(0.6))
                    }
                }
            }
            .padding(.horizontal)
            
            // Stats Section
            HStack(spacing: 16) {
                ProfileStat(title: "Meals\nDistributed", value: "156", color: .pistachio)
                ProfileStat(title: "Active\nRequests", value: "8", color: .steelBlue)
                ProfileStat(title: "Partner\nRestaurants", value: "24", color: .atomicTangerine)
            }
            .padding(.horizontal)
            
            // Menu Items
            VStack(spacing: 12) {
                ProfileMenuItem(icon: "person.fill", title: "Edit Profile", color: .steelBlue)
                ProfileMenuItem(icon: "bell.fill", title: "Notifications", color: .atomicTangerine)
                ProfileMenuItem(icon: "questionmark.circle.fill", title: "Help & Support", color: .pistachio)
                ProfileMenuItem(icon: "info.circle.fill", title: "About", color: .persianRed)
            }
            .padding(.horizontal)
            
            Spacer()
        }
    }
}

struct ProfileStat: View {
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundStyle(.black)
                .offset(x: 2, y: 2)
            
            VStack(spacing: 8) {
                Text(value)
                    .font(.title2)
                    .fontWeight(.bold)
                    .fontWidth(.expanded)
                    .foregroundColor(.black)
                
                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.black.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
            .frame(maxWidth: .infinity, minHeight: 80)
            .background(color)
            .overlay(
                Rectangle()
                    .stroke(.black, lineWidth: 2)
            )
        }
    }
}

struct ProfileMenuItem: View {
    let icon: String
    let title: String
    let color: Color
    var action: (() -> Void)? = nil
    
    var body: some View {
        Button(action: action ?? {}) {
            ZStack {
                Rectangle()
                    .foregroundStyle(.black)
                    .offset(x: 2, y: 2)
                
                HStack(spacing: 16) {
                    ZStack {
                        Circle()
                            .fill(color)
                            .frame(width: 40, height: 40)
                            .overlay(
                                Circle()
                                    .stroke(.black, lineWidth: 2)
                            )
                        
                        Image(systemName: icon)
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.black)
                    }
                    
                    Text(title)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .fontWidth(.expanded)
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.black.opacity(0.6))
                }
                .padding(16)
                .background(.white)
                .overlay(
                    Rectangle()
                        .stroke(.black, lineWidth: 2)
                )
            }
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(action == nil)
    }
}
