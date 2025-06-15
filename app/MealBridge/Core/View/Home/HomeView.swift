//
//  HomeView.swift
//  MealBridge
//
//  Created by Aarav Gupta on 12/06/25.
//

import SwiftUI

struct HomeView: View {
    @Environment(NavigationManager.self) var navigate
    @State private var scrollOffset: CGFloat = 0
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.offWhite.ignoresSafeArea()
                
                NavigationBarView(title: "MealBridge", scrollOffset: $scrollOffset, icon: "person.fill") {
                    content
                }
            }
        }
    }
    
    var content: some View {
        VStack {
            Rectangle()
                .fill(.clear)
            // Quick Actions
            VStack {
                NavigationCard(
                    title: "Browse Food",
                    subtitle: "Find available meals",
                    icon: "fork.knife",
                    color: .steelBlue
                ) {
                    navigate.to(.browseFoodListings)
                }
                
                NavigationCard(
                    title: "Add Listing",
                    subtitle: "Share surplus food",
                    icon: "plus.circle",
                    color: .atomicTangerine
                ) {
                    navigate.to(.addFoodListing)
                }
                
                HStack {
                    NavigationCard(
                        title: "Vegetarian",
                        subtitle: "Veg-only options",
                        icon: "leaf.fill",
                        color: .pistachio
                    ) {
                        navigate.to(.vegetarianListings)
                    }
                    
                    NavigationCard(
                        title: "Non-Vegetarian",
                        subtitle: "All food options",
                        icon: "fork.knife.circle",
                        color: .persianRed
                    ) {
                        navigate.to(.nonVegetarianListings)
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

struct NavigationCard: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                Rectangle()
                    .fill(.black)
                    .offset(x: 4, y: 4)
                
                Rectangle()
                    .fill(color)
                    .border(Color.black, width: 1)
                    .offset(x: 0, y: 0)
                
                VStack(spacing: 12) {
                    Image(systemName: icon)
                        .font(.system(size: 32, weight: .semibold))
                        .foregroundColor(.white)
                    
                    VStack(spacing: 4) {
                        Text(title)
                            .font(.headline)
                            .fontWeight(.semibold)
                            .fontWidth(.expanded)
                            .foregroundColor(.black)
                        
                        Text(subtitle)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .frame(maxWidth: .infinity, minHeight: 120)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
