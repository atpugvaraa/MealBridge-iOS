//
//  SettingsView.swift
//  MealBridge
//
//  Created by Aarav Gupta on 12/06/25.
//

import SwiftUI

struct SettingsView: View {
    @Environment(NavigationManager.self) var navigate
    @State private var scrollOffset: CGFloat = 0
    
    var body: some View {
        ZStack {
            Color.offWhite.ignoresSafeArea()
            
            NavigationBarView(title: "Settings", scrollOffset: $scrollOffset, showBackButton: true) {
                content
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    var content: some View {
        VStack(spacing: 20) {
            Button("Go to Notifications") {
                navigate.to(.notifications)
            }
            .padding()
            .background(.pistachio)
            .foregroundColor(.black)
            .cornerRadius(8)
            
            Spacer()
        }
    }
}
