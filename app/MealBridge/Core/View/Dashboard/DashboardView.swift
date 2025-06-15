//
//  DashboardView.swift
//  MealBridge
//
//  Created by Aarav Gupta on 12/06/25.
//

import SwiftUI

struct DashboardView: View {
    @Environment(NavigationManager.self) var navigate
    @State private var scrollOffset: CGFloat = 0
    
    var body: some View {
        ZStack {
            Color.offWhite.ignoresSafeArea()
            
            NavigationBarView(title: "Dashboard", scrollOffset: $scrollOffset) {
                content
            }
        }
    }
    
    var content: some View {
        VStack(spacing: 24) {
            // Statistics Cards
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16) {
                StatCard(
                    title: "Active Listings",
                    value: "12",
                    icon: "fork.knife.circle",
                    color: .atomicTangerine
                )
                
                StatCard(
                    title: "Requests",
                    value: "8",
                    icon: "hand.raised.fill",
                    color: .steelBlue
                )
                
                StatCard(
                    title: "Meals Saved",
                    value: "156",
                    icon: "leaf.fill",
                    color: .pistachio
                )
                
                StatCard(
                    title: "Partners",
                    value: "24",
                    icon: "person.3.fill",
                    color: .persianRed
                )
            }
            .padding(.horizontal)
            
            // Recent Activity Section
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text("Recent Activity")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .fontWidth(.expanded)
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    VStack {
                        Button("See All") {
                            navigate.to(.settings)
                        }
                        .font(.callout)
                        .foregroundColor(.black)
                        .fontWeight(.medium)
                        .fontWidth(.expanded)
                    }
                }
                .padding(.horizontal)
                
                LazyVStack(spacing: 16) {
                    ForEach(0..<5) { index in
                        ActivityCard(
                            title: "Food Request",
                            subtitle: "Green Valley NGO",
                            time: "\(index + 1)h ago",
                            color: index % 2 == 0 ? .pistachio : .atomicTangerine
                        )
                    }
                }
                .padding(.horizontal)
            }
            
            Spacer()
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundStyle(.black)
                .offset(x: 3, y: 3)
            
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(.black)
                
                Text(value)
                    .font(.title)
                    .fontWeight(.bold)
                    .fontWidth(.expanded)
                    .foregroundColor(.black)
                
                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.black.opacity(0.7))
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity, minHeight: 100)
            .background(color)
            .overlay(
                Rectangle()
                    .stroke(.black, lineWidth: 2)
            )
        }
    }
}

struct ActivityCard: View {
    let title: String
    let subtitle: String
    let time: String
    let color: Color
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundStyle(.black)
                .offset(x: 2, y: 2)
            
            Rectangle()
                .fill(color)
                .stroke(.black, lineWidth: 2)
            
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text(title)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .fontWidth(.expanded)
                        .foregroundColor(.black)
                    
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundColor(.black.opacity(0.7))
                }
                
                Spacer()
                
                Text(time)
                    .font(.caption)
                    .foregroundColor(.black.opacity(0.5))
            }
            .padding(10)
        }
        .frame(maxWidth: .infinity)
    }
}
