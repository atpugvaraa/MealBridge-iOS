//
//  AddFoodListingView.swift
//  MealBridge
//
//  Created by Aarav Gupta on 12/06/25.
//

import SwiftUI

struct AddFoodListingView: View {
    @Environment(NavigationManager.self) var navigate
    @State private var scrollOffset: CGFloat = 0
    
    // Form states
    @State private var foodName = ""
    @State private var quantity = ""
    @State private var selectedType = "Vegetarian"
    @State private var expiryTime = Date()
    @State private var description = ""
    @State private var isAvailable = true
    
    private let foodTypes = ["Veg", "Non-Veg", "Mixed"]
    
    var body: some View {
        ZStack {
            Color.offWhite.ignoresSafeArea()
            
            NavigationBarView(title: "Add Listing", scrollOffset: $scrollOffset, showBackButton: true) {
                content
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    var content: some View {
        VStack(spacing: 0) {
            VStack {
                VStack(spacing: 20) {
                    // Food Type Selection
                    VStack(alignment: .leading, spacing: 12) {
                        HStack(spacing: 12) {
                            ForEach(foodTypes, id: \.self) { type in
                                TypeButton(
                                    title: type,
                                    isSelected: selectedType == type,
                                    color: colorForType(type)
                                ) {
                                    selectedType = type
                                }
                            }
                        }
                    }
                    
                    // Form Fields
                    VStack(spacing: 16) {
                        FormField(title: "Food Name", text: $foodName, placeholder: "e.g., Vegetable Biryani")
                        FormField(title: "Quantity", text: $quantity, placeholder: "e.g., 20 meals")
                        
                        // Expiry Time
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Available Until")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .fontWidth(.expanded)
                                .foregroundColor(.black)
                            
                            ZStack {
                                Rectangle()
                                    .foregroundStyle(.black)
                                    .offset(x: 3, y: 3)
                                
                                DatePicker("", selection: $expiryTime, displayedComponents: [.date, .hourAndMinute])
                                    .datePickerStyle(.compact)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(12)
                                    .background(.white)
                                    .overlay(
                                        Rectangle()
                                            .stroke(.black, lineWidth: 2)
                                    )
                            }
                        }
                        
                        // Description
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Description")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .fontWidth(.expanded)
                                .foregroundColor(.black)
                            
                            ZStack {
                                Rectangle()
                                    .foregroundStyle(.black)
                                    .offset(x: 2, y: 2)
                                
                                TextField("Describe the food items...", text: $description, axis: .vertical)
                                    .lineLimit(3...6)
                                    .padding(12)
                                    .background(.white)
                                    .overlay(
                                        Rectangle()
                                            .stroke(.black, lineWidth: 2)
                                    )
                            }
                        }
                    }
                    
                    // Availability Toggle
                    HStack {
                        Text("Available Now")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .fontWidth(.expanded)
                            .foregroundColor(.black)
                        
                        Spacer()
                        
                        Toggle("", isOn: $isAvailable)
                            .tint(.pistachio)
                    }
                }
                .padding(.bottom)
                .padding(.horizontal)
            }
            
            // Bottom Action Button
            VStack {
                Button {
                    // Handle form submission
                } label: {
                    ZStack {
                        Rectangle()
                            .foregroundStyle(.black)
                            .offset(x: 3, y: 3)
                        
                        Text("Create Listing")
                            .font(.headline)
                            .fontWeight(.bold)
                            .fontWidth(.expanded)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding(16)
                            .background(.atomicTangerine)
                            .overlay(
                                Rectangle()
                                    .stroke(.black, lineWidth: 2)
                            )
                    }
                }
                .disabled(foodName.isEmpty || quantity.isEmpty)
                .opacity(foodName.isEmpty || quantity.isEmpty ? 0.6 : 1.0)
            }
            .padding(.horizontal)
            .padding(.bottom)
            .background(.offWhite)
        }
    }
    
    private func colorForType(_ type: String) -> Color {
        switch type {
        case "Veg": return .pistachio
        case "Non-Veg": return .persianRed
        default: return .atomicTangerine
        }
    }
}

struct TypeButton: View {
    let title: String
    let isSelected: Bool
    let color: Color
    let action: () -> Void
    
    var body: some View {
        VStack {
            Text(title)
                .font(.subheadline)
                .fontWeight(.semibold)
                .fontWidth(.expanded)
                .foregroundColor(.black)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background {
                    ZStack {
                        if isSelected {
                            Rectangle()
                                .foregroundStyle(.black)
                                .offset(x: 2, y: 2)
                        }
                        
                        isSelected ? color : .white
                    }
                }
                .overlay(
                    Rectangle()
                        .stroke(.black, lineWidth: 2)
                )
                .offset(x: isSelected ? -2 : 0, y: isSelected ? -2 : 0)
        }
        .onTapGesture {
            withAnimation {
                action()
            }
        }
    }
}

struct FormField: View {
    let title: String
    @Binding var text: String
    let placeholder: String
    
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
                    .offset(x: 3, y: 3)
                
                TextField(placeholder, text: $text)
                    .padding(12)
                    .background(.white)
                    .overlay(
                        Rectangle()
                            .stroke(.black, lineWidth: 2)
                    )
            }
        }
    }
}
