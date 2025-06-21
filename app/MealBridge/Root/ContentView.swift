//
//  ContentView.swift
//  MealBridge
//
//  Created by Aarav Gupta on 12/06/25.
//

import SwiftUI

struct ContentView: View {
    @State private var navigationManager = NavigationManager()
    @State private var selectedTab = 0
    @EnvironmentObject var authManager: AuthManager
    
    var body: some View {
        ZStack {
            Color.offWhite.ignoresSafeArea()
            
            VStack(spacing: 0) {
                Group {
                    switch selectedTab {
                    case 0:
                        HomeView()
                    case 1:
                        DashboardView()
                    case 2:
                        ChatListView()
                    default:
                        HomeView()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                // Custom Tab Bar
                NeubrutalismTabBar(
                    selectedTab: $selectedTab,
                    isNGO: authManager.currentUser?.isNGO ?? false,
                    isRestaurant: authManager.currentUser?.isRestaurant ?? false
                )
            }
        }
        .onAppear {
            // Refresh user profile and fetch initial data
            authManager.refreshUserProfile()
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

#Preview {
    ContentView()
        .environmentObject(AuthManager.shared)
}
