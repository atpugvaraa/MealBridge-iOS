//
//  FoodListingDetailView.swift
//  MealBridge
//
//  Created by Aarav Gupta on 12/06/25.
//

import SwiftUI

struct FoodListingDetailView: View {
    let id: String
    
    var body: some View {
        Text("Food Listing Detail: \(id)")
            .navigationTitle("Food Details")
    }
}