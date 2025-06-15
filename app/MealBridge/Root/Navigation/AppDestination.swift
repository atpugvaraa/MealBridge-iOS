//
//  AppDestination.swift
//  MealBridge
//
//  Created by Aarav Gupta on 12/06/25.
//

import Foundation

enum AppDestination: Hashable {
    // Authentication
    case login
    case register
    case onboarding
    
    // User Type Selection
    case userTypeSelection
    
    // Restaurant Flow
    case restaurantDashboard
    case addFoodListing
    case foodListingDetail(id: String)
    case restaurantProfile
    case restaurantOrders
    
    // NGO Flow
    case ngoDashboard
    case browseFoodListings
    case foodRequestDetail(id: String)
    case ngoProfile
    case ngoRequests
    
    // Shared Features
    case chat(participantId: String)
    case notifications
    case settings
    case help
    case about
    
    // Food Categories
    case vegetarianListings
    case nonVegetarianListings
    case mixedListings
    
    var title: String {
        switch self {
        case .login: return "Login"
        case .register: return "Register"
        case .onboarding: return "Welcome"
        case .userTypeSelection: return "Select User Type"
        case .restaurantDashboard: return "Restaurant Dashboard"
        case .addFoodListing: return "Add Food Listing"
        case .foodListingDetail: return "Food Details"
        case .restaurantProfile: return "Restaurant Profile"
        case .restaurantOrders: return "Orders"
        case .ngoDashboard: return "NGO Dashboard"
        case .browseFoodListings: return "Available Food"
        case .foodRequestDetail: return "Request Details"
        case .ngoProfile: return "NGO Profile"
        case .ngoRequests: return "Requests"
        case .chat: return "Chat"
        case .notifications: return "Notifications"
        case .settings: return "Settings"
        case .help: return "Help"
        case .about: return "About"
        case .vegetarianListings: return "Vegetarian Food"
        case .nonVegetarianListings: return "Non-Vegetarian Food"
        case .mixedListings: return "Mixed Food"
        }
    }
}

