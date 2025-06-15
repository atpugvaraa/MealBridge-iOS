//
//  VegetarianListingsView.swift
//  MealBridge
//
//  Created by Aarav Gupta on 12/06/25.
//

import SwiftUI

struct VegetarianListingsView: View {
    @Environment(NavigationManager.self) var navigate
    @State private var scrollOffset: CGFloat = 0
    
    var body: some View {
        ZStack {
            Color.offWhite.ignoresSafeArea()
            
            Color.pistachio.opacity(0.2).ignoresSafeArea()
            
            NavigationBarView(title: "Vegetarian Food", scrollOffset: $scrollOffset, showBackButton: true) {
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
    
    var headerCard: some View {
        ZStack {
            Rectangle()
                .foregroundStyle(.black)
                .offset(x: 3, y: 3)
            VStack(spacing: 12) {
                Image(systemName: "leaf.fill")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(.white)
                Text("100% Vegetarian")
                    .font(.title2)
                    .fontWeight(.bold)
                    .fontWidth(.expanded)
                    .foregroundColor(.black)
                Text("Fresh plant-based meals available for pickup")
                    .font(.subheadline)
                    .foregroundColor(.black.opacity(0.7))
                    .multilineTextAlignment(.center)
            }
            .padding(20)
            .frame(maxWidth: .infinity)
            .background(.pistachio)
            .overlay(
                Rectangle()
                    .stroke(.black, lineWidth: 3)
            )
        }
        .padding(.horizontal)
        .padding(.bottom, 20)
    }
    
    var foodListings: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(0..<8) { index in
                    VegFoodCard(
                        restaurantName: vegRestaurants[index % vegRestaurants.count],
                        foodItem: vegFoodItems[index % vegFoodItems.count],
                        quantity: "\(Int.random(in: 15...40)) meals",
                        distance: String(format: "%.1f km", Double.random(in: 0.3...3.5)),
                        freshness: freshnessTags[index % freshnessTags.count],
                        rating: Double.random(in: 4.2...5.0)
                    ) {
                        // navigate.to(.foodListingDetail(id: "veg-\(index)"))
                    }
                }
            }
            .padding(.horizontal)
        }
    }
    
    // Mock data
    private let vegRestaurants = ["Green Garden Café", "Organic Delights", "Pure Veg Kitchen", "Nature's Bounty", "Healthy Harvest"]
    private let vegFoodItems = ["Mixed Vegetable Curry", "Fresh Garden Salad", "Quinoa Bowl", "Lentil Soup", "Veggie Wraps"]
    private let freshnessTags = ["Just Prepared", "2 hrs fresh", "Morning Special", "Farm Fresh", "Organic"]
}

struct VegFoodCard: View {
    let restaurantName: String
    let foodItem: String
    let quantity: String
    let distance: String
    let freshness: String
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
                                .fill(.pistachio)
                                .frame(width: 16, height: 16)
                                .overlay(
                                    Circle()
                                        .stroke(.black, lineWidth: 1)
                                )
                                .overlay(
                                    Circle()
                                        .fill(.black)
                                        .frame(width: 6, height: 6)
                                )
                        }
                    }
                    
                    // Details Row
                    HStack(spacing: 16) {
                        VegDetailBadge(icon: "fork.knife", text: quantity, bgColor: .pistachio.opacity(0.3))
                        VegDetailBadge(icon: "location.fill", text: distance, bgColor: .steelBlue.opacity(0.3))
                        VegDetailBadge(icon: "clock.fill", text: freshness, bgColor: .atomicTangerine.opacity(0.3))
                        
                        Spacer()
                    }
                    
                    // Action Row
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
                            .foregroundColor(.pistachio)
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

struct VegDetailBadge: View {
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
