//
//  UserTypeSelectionView.swift
//  MealBridge
//
//  Created by Aarav Gupta on 12/06/25.
//

import SwiftUI

struct UserTypeSelectionView: View {
    @EnvironmentObject var authManager: AuthManager
    @Environment(NavigationManager.self) var navigate
    
    var body: some View {
        VStack(spacing: 0) {
            Text("How would you like to contribute?")
                .foregroundStyle(.black)
                .fontWeight(.semibold)
                .fontWidth(.expanded)
            
            HStack {
                ZStack {
                    Rectangle()
                        .foregroundStyle(.black)
                        .offset(x: 2, y: 2)
                    
                    Group {
                        ZStack {
                            Rectangle()
                                .fill(.atomicTangerine)
                                .border(.black, width: 1)
                            
                            if authManager.currentUser?.isNGO == true {
                                Rectangle()
                                    .fill(.black.opacity(0.2))
                            }
                        }
                        
                        Text("Distribute")
                            .foregroundStyle(.black)
                            .fontWeight(.semibold)
                            .fontWidth(.expanded)
                    }
                    .offset(x: (authManager.currentUser?.isNGO == true) ? 2 : -2, y: (authManager.currentUser?.isNGO == true) ? 2 : -2)
                    .animation(.snappy, value: authManager.currentUser?.isNGO)
                }
                .frame(height: 48)
                .onTapGesture {
                    // Navigate to NGO specific flow
                    navigate.to(.ngoDashboard)
                }
                
                ZStack {
                    Rectangle()
                        .foregroundStyle(.black)
                        .offset(x: 2, y: 2)
                    
                    Group {
                        ZStack {
                            Rectangle()
                                .fill(.steelBlue)
                                .border(.black, width: 1)
                            
                            if authManager.currentUser?.isRestaurant == true {
                                Rectangle()
                                    .fill(.black.opacity(0.2))
                            }
                        }
                        
                        Text("Donate")
                            .foregroundStyle(.black)
                            .fontWeight(.semibold)
                            .fontWidth(.expanded)
                    }
                    .offset(x: (authManager.currentUser?.isRestaurant == true) ? 2 : -2, y: (authManager.currentUser?.isRestaurant == true) ? 2 : -2)
                    .animation(.snappy, value: authManager.currentUser?.isRestaurant)
                }
                .frame(height: 48)
                .onTapGesture {
                    // Navigate to Restaurant specific flow
                    navigate.to(.restaurantDashboard)
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
        }
    }
}

#Preview {
    UserTypeSelectionView()
        .environmentObject(AuthManager.shared)
}
