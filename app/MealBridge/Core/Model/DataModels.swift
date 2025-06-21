//
//  DataModels.swift
//  MealBridge
//
//  Created by Aarav Gupta on 15/06/25.
//

import Foundation

// MARK: - Authentication Models
struct LoginRequest: Codable {
    let email: String
    let password: String
}

struct RegisterRequest: Codable {
    let email: String
    let password: String
    let name: String
    let organization: String
    let userType: String
    let city: String?
    let pincode: String?
    let googleMapLink: String?
    
    enum CodingKeys: String, CodingKey {
        case email, password, name, organization, city, pincode
        case userType = "user_type"
        case googleMapLink = "google_map_link"
    }
}

struct AuthResponse: Codable {
    let token: String
    let user: UserProfile
}

struct UserProfile: Codable, Identifiable {
    let id: Int
    let email: String
    let name: String
    let organization: String
    let userType: String
    let city: String?
    let pincode: String?
    let googleMapLink: String?
    let isActive: Bool
    let dateJoined: String
    
    enum CodingKeys: String, CodingKey {
        case id, email, name, organization, city, pincode
        case userType = "user_type"
        case googleMapLink = "google_map_link"
        case isActive = "is_active"
        case dateJoined = "date_joined"
    }
    
    var isNGO: Bool {
        return userType.lowercased() == "ngo"
    }
    
    var isRestaurant: Bool {
        return userType.lowercased() == "restaurant"
    }
}

// MARK: - Food Request Models
struct FoodRequest: Codable, Identifiable {
    let id: Int
    let restaurant: UserProfile
    let foodType: String
    let description: String?
    let quantity: String?
    let isVegetarian: Bool
    let isAvailable: Bool
    let isClaimed: Bool
    let claimedBy: UserProfile?
    let createdAt: String
    let updatedAt: String
    let expiresAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id, restaurant, description, quantity
        case foodType = "food_type"
        case isVegetarian = "is_vegetarian"
        case isAvailable = "is_available"
        case isClaimed = "is_claimed"
        case claimedBy = "claimed_by"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case expiresAt = "expires_at"
    }
    
    var foodTypeDisplayName: String {
        switch foodType.lowercased() {
        case "veg":
            return "Vegetarian"
        case "non-veg", "nonveg":
            return "Non-Vegetarian"
        case "mixed":
            return "Mixed"
        default:
            return foodType.capitalized
        }
    }
    
    var statusColor: String {
        if isClaimed {
            return "green"
        } else if isAvailable {
            return "orange"
        } else {
            return "red"
        }
    }
    
    var statusText: String {
        if isClaimed {
            return "Claimed"
        } else if isAvailable {
            return "Available"
        } else {
            return "Expired"
        }
    }
}

struct CreateFoodRequest: Codable {
    let foodType: String
    let description: String?
    let quantity: String?
    let isVegetarian: Bool
    let expiresAt: String?
    
    enum CodingKeys: String, CodingKey {
        case description, quantity
        case foodType = "food_type"
        case isVegetarian = "is_vegetarian"
        case expiresAt = "expires_at"
    }
}

// MARK: - Dashboard Models
struct DashboardStats: Codable {
    let totalRequests: Int
    let activeRequests: Int
    let claimedRequests: Int
    let totalPartners: Int
    let thisWeekRequests: Int
    let thisMonthRequests: Int
    
    enum CodingKeys: String, CodingKey {
        case totalRequests = "total_requests"
        case activeRequests = "active_requests"
        case claimedRequests = "claimed_requests"
        case totalPartners = "total_partners"
        case thisWeekRequests = "this_week_requests"
        case thisMonthRequests = "this_month_requests"
    }
}

// MARK: - General Response Models
struct MessageResponse: Codable {
    let message: String
    let success: Bool?
}

// MARK: - Chat Models (for future implementation)
struct MealBridgeChatMessage: Codable, Identifiable {
    let id: Int
    let sender: UserProfile
    let receiver: UserProfile
    let message: String
    let timestamp: String
    let isRead: Bool
    
    enum CodingKeys: String, CodingKey {
        case id, sender, receiver, message, timestamp
        case isRead = "is_read"
    }
}

struct MealBridgeChatRoom: Codable, Identifiable {
    let id: Int
    let participants: [UserProfile]
    let lastMessage: MealBridgeChatMessage?
    let createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case id, participants
        case lastMessage = "last_message"
        case createdAt = "created_at"
    }
}

// MARK: - Food Category Enum
enum FoodCategory: String, CaseIterable {
    case vegetarian = "veg"
    case nonVegetarian = "non-veg"
    case mixed = "mixed"
    
    var displayName: String {
        switch self {
        case .vegetarian:
            return "Vegetarian"
        case .nonVegetarian:
            return "Non-Vegetarian"
        case .mixed:
            return "Mixed"
        }
    }
    
    var icon: String {
        switch self {
        case .vegetarian:
            return "leaf.fill"
        case .nonVegetarian:
            return "flame.fill"
        case .mixed:
            return "square.stack.fill"
        }
    }
}