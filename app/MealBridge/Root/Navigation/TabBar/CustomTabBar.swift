//
//  CustomTabBar.swift
//  MealBridge
//
//  Created by Aarav Gupta on 12/06/25.
//

import SwiftUI

struct NeubrutalismTabBar: View {
    @Binding var selectedTab: Int
    let isNGO: Bool
    let isRestaurant: Bool
    
    private let tabs = [
        TabItem(icon: "house.fill", title: "Home", tag: 0),
        TabItem(icon: "square.grid.2x2.fill", title: "Dashboard", tag: 1),
        TabItem(icon: "message.fill", title: "Messages", tag: 2),
    ]
    
    var body: some View {
        ZStack {
            // Main tab bar
            VStack(spacing: 10) {
                Rectangle()
                    .frame(maxWidth: .infinity)
                    .frame(height: 2)
                    .foregroundStyle(.black)
                
                HStack(spacing: 0) {
                    ForEach(tabs, id: \.tag) { tab in
                        TabBarButton(
                            icon: tab.icon,
                            title: tab.title,
                            isSelected: selectedTab == tab.tag,
                            color: colorForTab(tab.tag)
                        ) {
                            selectedTab = tab.tag
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                .padding(.horizontal, 10)
            }
            .frame(height: 70)
            .background(.white)
        }
    }
    
    private func colorForTab(_ tag: Int) -> Color {
        switch tag {
        case 0: return .atomicTangerine  // Home
        case 1: return .steelBlue        // Dashboard
        case 2: return .pistachio        // Messages
        default: return .steelBlue
        }
    }
}

struct TabBarButton: View {
    let icon: String
    let title: String
    let isSelected: Bool
    let color: Color
    let action: () -> Void
    
    var body: some View {
        VStack(spacing: 4) {
            ZStack {
                if isSelected {
                    // Selected state with neubrutalism shadow
                    Rectangle()
                        .fill(.black)
                        .frame(width: 44, height: 44)
                        .offset(x: 2, y: 2)
                }
                
                Rectangle()
                    .fill(isSelected ? color : .white)
                    .frame(width: 44, height: 44)
                    .overlay(
                        Rectangle()
                            .stroke(.black, lineWidth: 2)
                    )
                    .offset(x: isSelected ? -2 : 0, y: isSelected ? -2 : 0)
                
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.black)
                    .offset(x: isSelected ? -2 : 0, y: isSelected ? -2 : 0)
            }
            
            Text(title)
                .font(.system(size: 10, weight: .bold))
                .fontWidth(.expanded)
                .foregroundColor(isSelected ? .black : .black.opacity(0.6))
                .multilineTextAlignment(.center)
        }
        .onTapGesture {
            withAnimation {
                action()
            }
        }
    }
}

struct TabItem {
    let icon: String
    let title: String
    let tag: Int
}
