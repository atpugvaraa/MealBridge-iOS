//
//  BrowseFoodListingsView.swift
//  MealBridge
//
//  Created by Aarav Gupta on 12/06/25.
//

import SwiftUI

struct BrowseFoodListingsView: View {
    @Environment(NavigationManager.self) var navigate
    @State private var scrollOffset: CGFloat = 0
    @State private var selectedFilter = "All"
    
    private let filters = ["All", "Vegetarian", "Non-Veg", "Mixed"]
    
    var body: some View {
        ZStack {
            Color.offWhite.ignoresSafeArea()
            
            NavigationBarView(title: "Available Food", scrollOffset: $scrollOffset, showBackButton: true) {
                content
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    var content: some View {
        VStack(spacing: 0) {
            filterTabs
            foodListings
        }
    }
    
    private var filterTabs: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(filters, id: \.self) { filter in
                    FilterTab(
                        title: filter,
                        isSelected: selectedFilter == filter,
                        color: colorForFilter(filter)
                    ) {
                        selectedFilter = filter
                    }
                }
            }
            .padding(.horizontal)
        }
        .padding(.bottom, 16)
    }

    private var foodListings: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(0..<10) { index in
                    FoodListingCard(
                        restaurantName: restaurantNames[index % restaurantNames.count],
                        foodType: foodTypes[index % foodTypes.count],
                        quantity: "\(Int.random(in: 10...50)) meals",
                        distance: "\(String(format: "%.1f", Double.random(in: 0.5...5.0))) km",
                        expiryTime: expiryTimes[index % expiryTimes.count],
                        isVeg: index % 3 != 0
                    ) {
                        // navigate.to(.foodListingDetail(id: "food-\(index)"))
                    }
                }
            }
            .padding(.horizontal)
        }
    }
    
    private func colorForFilter(_ filter: String) -> Color {
        switch filter {
        case "Vegetarian": return .pistachio
        case "Non-Veg": return .persianRed
        case "Mixed": return .atomicTangerine
        default: return .steelBlue
        }
    }
    
    // Mock data
    private let restaurantNames = ["Bella's Kitchen", "Golden Spoon", "Green Garden", "Spice Route", "Ocean View"]
    private let foodTypes = ["Italian Pasta", "Indian Curry", "Fresh Salads", "Grilled Items", "Desserts"]
    private let expiryTimes = ["2 hours left", "4 hours left", "1 hour left", "6 hours left", "3 hours left"]
}

struct FilterTab: View {
    let title: String
    let isSelected: Bool
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                if isSelected {
                    Rectangle()
                        .foregroundStyle(.black)
                        .offset(x: 2, y: 2)
                }
                
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .fontWidth(.expanded)
                    .foregroundColor(.black)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(isSelected ? color : .white)
                    .overlay(
                        Rectangle()
                            .stroke(.black, lineWidth: 2)
                    )
                    .offset(x: isSelected ? 2 : 0, y: isSelected ? 2 : 0)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct FoodListingCard: View {
    let restaurantName: String
    let foodType: String
    let quantity: String
    let distance: String
    let expiryTime: String
    let isVeg: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                Rectangle()
                    .foregroundStyle(.black)
                    .offset(x: 3, y: 3)
                
                VStack(alignment: .leading, spacing: 12) {
                    // Header
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(restaurantName)
                                .font(.headline)
                                .fontWeight(.bold)
                                .fontWidth(.expanded)
                                .foregroundColor(.black)
                            
                            Text(foodType)
                                .font(.subheadline)
                                .foregroundColor(.black.opacity(0.7))
                        }
                        
                        Spacer()
                        
                        ZStack {
                            Circle()
                                .fill(isVeg ? .pistachio : .persianRed)
                                .frame(width: 20, height: 20)
                                .overlay(
                                    Circle()
                                        .stroke(.black, lineWidth: 1)
                                )
                            
                            if isVeg {
                                Circle()
                                    .fill(.black)
                                    .frame(width: 6, height: 6)
                            }
                        }
                    }
                    
                    // Details
                    HStack(spacing: 16) {
                        DetailTag(icon: "fork.knife", text: quantity, color: .atomicTangerine)
                        DetailTag(icon: "location.fill", text: distance, color: .steelBlue)
                    }
                    
                    // Expiry Warning
                    HStack {
                        Image(systemName: "clock.fill")
                            .foregroundColor(.persianRed)
                            .font(.caption)
                        
                        Text(expiryTime)
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.persianRed)
                        
                        Spacer()
                        
                        Text("Request Now")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.steelBlue)
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
        .buttonStyle(PlainButtonStyle())
    }
}

struct DetailTag: View {
    let icon: String
    let text: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.caption)
                .foregroundColor(.black)
            
            Text(text)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.black)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(color.opacity(0.3))
        .overlay(
            RoundedRectangle(cornerRadius: 4)
                .stroke(.black, lineWidth: 1)
        )
        .cornerRadius(4)
    }
}
