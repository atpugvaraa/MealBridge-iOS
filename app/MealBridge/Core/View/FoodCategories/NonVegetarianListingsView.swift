//
//  NonVegetarianListingsView.swift
//  MealBridge
//
//  Created by Aarav Gupta on 12/06/25.
//

import SwiftUI

struct NonVegetarianListingsView: View {
    @Environment(NavigationManager.self) var navigate
    @State private var scrollOffset: CGFloat = 0
    
    var body: some View {
        ZStack {
            Color.offWhite.ignoresSafeArea()
            Color.persianRed.opacity(0.2).ignoresSafeArea()
            
            NavigationBarView(title: "Non-Veg Food", scrollOffset: $scrollOffset, showBackButton: true) {
                content
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    var content: some View {
        VStack(spacing: 0) {
            headerCard
            foodListings
        }
    }
    
    private var headerCard: some View {
        ZStack {
            Rectangle()
                .foregroundStyle(.black)
                .offset(x: 3, y: 3)
            
            VStack(spacing: 12) {
                Image(systemName: "fork.knife.circle")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(.white)
                
                Text("Non-Vegetarian Meals")
                    .font(.title2)
                    .fontWeight(.bold)
                    .fontWidth(.expanded)
                    .foregroundColor(.black)
                
                Text("Fresh meat and seafood dishes ready for pickup")
                    .font(.subheadline)
                    .foregroundColor(.black.opacity(0.7))
                    .multilineTextAlignment(.center)
            }
            .padding(20)
            .frame(maxWidth: .infinity)
            .background(.persianRed)
            .overlay(
                Rectangle()
                    .stroke(.black, lineWidth: 3)
            )
        }
        .padding(.horizontal)
        .padding(.bottom, 20)
    }
    
    private var foodListings: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(0..<8) { index in
                    makeFoodCard(for: index)
                }
            }
            .padding(.horizontal)
        }
    }
    
    private func makeFoodCard(for index: Int) -> some View {
        NonVegFoodCard(
            restaurantName: nonVegRestaurants[index % nonVegRestaurants.count],
            foodItem: nonVegFoodItems[index % nonVegFoodItems.count],
            quantity: "\(Int.random(in: 10...35)) meals",
            distance: String(format: "%.1f km", Double.random(in: 0.5...4.0)),
            cookedTime: cookedTimes[index % cookedTimes.count],
            rating: Double.random(in: 4.0...5.0)
        ) {
            // navigate.to(.foodListingDetail(id: "nonveg-\(index)"))
        }
    }
    
    // Mock data
    private let nonVegRestaurants = ["Ocean Grill", "Meat & Feast", "Barbecue Corner", "Coastal Kitchen", "Hunter's Table"]
    private let nonVegFoodItems = ["Grilled Chicken", "Fish Curry", "Mutton Biryani", "Prawn Masala", "BBQ Platter"]
    private let cookedTimes = ["Just Cooked", "1 hr ago", "Fresh & Hot", "Recently Prepared", "2 hrs fresh"]
}

struct NonVegFoodCard: View {
    let restaurantName: String
    let foodItem: String
    let quantity: String
    let distance: String
    let cookedTime: String
    let rating: Double
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                Rectangle()
                    .foregroundStyle(.black)
                    .offset(x: 3, y: 3)
                
                VStack(spacing: 16) {
                    // Header
                    HStack {
                        VStack(alignment: .leading, spacing: 6) {
                            Text(restaurantName)
                                .font(.headline)
                                .fontWeight(.bold)
                                .fontWidth(.expanded)
                                .foregroundColor(.black)
                            
                            Text(foodItem)
                                .font(.subheadline)
                                .foregroundColor(.black.opacity(0.7))
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 4) {
                            HStack(spacing: 4) {
                                Image(systemName: "star.fill")
                                    .font(.caption)
                                    .foregroundColor(.black)
                                
                                Text("\(rating, specifier: "%.1f")")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.black)
                            }
                            
                            Circle()
                                .fill(.persianRed)
                                .frame(width: 16, height: 16)
                                .overlay(
                                    Circle()
                                        .stroke(.black, lineWidth: 1)
                                )
                        }
                    }
                    
                    // Details Row
                    HStack(spacing: 16) {
                        NonVegDetailBadge(icon: "fork.knife", text: quantity, bgColor: .persianRed.opacity(0.3))
                        NonVegDetailBadge(icon: "location.fill", text: distance, bgColor: .steelBlue.opacity(0.3))
                        NonVegDetailBadge(icon: "flame.fill", text: cookedTime, bgColor: .atomicTangerine.opacity(0.3))
                        
                        Spacer()
                    }
                    
                    // Warning & Action Row
                    VStack(spacing: 8) {
                        HStack {
                            HStack(spacing: 4) {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .foregroundColor(.persianRed)
                                    .font(.caption)
                                
                                Text("Consume within 2 hours")
                                    .font(.caption)
                                    .fontWeight(.medium)
                                    .foregroundColor(.persianRed)
                            }
                            
                            Spacer()
                        }
                        
                        HStack {
                            HStack(spacing: 6) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.pistachio)
                                    .font(.subheadline)
                                
                                Text("Available Now")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .foregroundColor(.black)
                            }
                            
                            Spacer()
                            
                            Text("Request →")
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .foregroundColor(.persianRed)
                        }
                    }
                }
                .padding(18)
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

struct NonVegDetailBadge: View {
    let icon: String
    let text: String
    let bgColor: Color
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.caption2)
                .foregroundColor(.black)
            
            Text(text)
                .font(.caption2)
                .fontWeight(.medium)
                .foregroundColor(.black)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(bgColor)
        .overlay(
            RoundedRectangle(cornerRadius: 4)
                .stroke(.black, lineWidth: 1)
        )
        .cornerRadius(4)
    }
}
