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
    @StateObject private var authManager = AuthManager.shared
    @StateObject private var foodRequestService = FoodRequestService.shared
    @StateObject private var dashboardService = DashboardService.shared
    @State private var navigationManager = NavigationManager()
    
    var body: some Scene {
        WindowGroup {
            content
                .environmentObject(authManager)
                .environmentObject(foodRequestService)
                .environmentObject(dashboardService)
                .environment(navigationManager)
        }
    }
    
    @ViewBuilder
    private var content: some View {
        NavigationStack(path: $navigationManager.path) {
            Group {
                if isOnboarding {
                    OnboardingView()
                } else if authManager.isAuthenticated {
                    ContentView()
                } else {
                    LoginView()
                }
            }
            .navigationDestination(for: AppDestination.self) { destination in
                destinationView(for: destination)
            }
        }
    }
    
    @ViewBuilder
    private func destinationView(for destination: AppDestination) -> some View {
        switch destination {
            // Authentication
        case .login:
            LoginView()
        case .register:
            RegisterView()
        case .onboarding:
            OnboardingView()
            
            // User Type Selection
        case .userTypeSelection:
            UserTypeSelectionView()
            
            // Restaurant Flow
        case .restaurantDashboard:
            RestaurantDashboardView()
        case .addFoodListing:
            AddFoodListingView()
        case .foodListingDetail(let id):
            FoodListingDetailView(id: id)
        case .restaurantProfile:
            RestaurantProfileView()
        case .restaurantOrders:
            RestaurantOrdersView()
            
            // NGO Flow
        case .ngoDashboard:
            NGODashboardView()
        case .browseFoodListings:
            BrowseFoodListingsView()
        case .foodRequestDetail(let id):
            FoodRequestDetailView(id: id)
        case .ngoProfile:
            NGOProfileView()
        case .ngoRequests:
            NGORequestsView()
            
            // Shared Features
        case .chat(let participantId):
            ChatView(participantId: participantId)
        case .notifications:
            NotificationsView()
        case .settings:
            SettingsView()
        case .help:
            HelpView()
        case .about:
            AboutView()
            
            // Food Categories
        case .vegetarianListings:
            VegetarianListingsView()
        case .nonVegetarianListings:
            NonVegetarianListingsView()
        case .mixedListings:
            MixedListingsView()
        }
    }
}
