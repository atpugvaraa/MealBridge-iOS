//
//  AboutView.swift
//  MealBridge
//
//  Created by Aarav Gupta on 12/06/25.
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        VStack {
            Text("About MealBridge")
                .font(.title)
                .fontWeight(.semibold)
                .fontWidth(.expanded)
            
            Text("Connecting restaurants with NGOs to reduce food waste and help those in need.")
                .padding()
                .multilineTextAlignment(.center)
        }
        .navigationTitle("About")
    }
}