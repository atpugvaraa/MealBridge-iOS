//
//  MealBridgeApp.swift
//  MealBridge
//
//  Created by Aarav Gupta on 12/06/25.
//

import SwiftUI

@main
struct MealBridgeApp: App {
    @AppStorage("isOnboarding") var isOnboarding = true
    @State var isNGO: Bool = false
    @State var isRestraunt: Bool = false
    
    var body: some Scene {
        WindowGroup {
            if isOnboarding  {
                OnboardingView(isNGO: $isNGO, isRestraunt: $isRestraunt)
            } else {
                ContentView(isNGO: $isNGO, isRestraunt: $isRestraunt)
            }
        }
    }
}
