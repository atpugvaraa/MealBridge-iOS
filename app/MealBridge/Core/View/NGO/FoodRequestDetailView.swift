//
//  FoodRequestDetailView.swift
//  MealBridge
//
//  Created by Aarav Gupta on 12/06/25.
//

import SwiftUI

struct FoodRequestDetailView: View {
    let id: String
    
    var body: some View {
        Text("Food Request Detail: \(id)")
            .navigationTitle("Request Details")
    }
}