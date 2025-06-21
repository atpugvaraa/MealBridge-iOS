//
//  NetworkManager.swift
//  MealBridge
//
//  Created by Aarav Gupta on 15/06/25.
//

import Foundation
import Combine

class NetworkManager: ObservableObject {
    static let shared = NetworkManager()
    
    private let baseURL = "http://127.0.0.1:8000"
    private let session = URLSession.shared
    
    private init() {}
    
    // MARK: - Generic Network Request
    func request<T: Codable>(
        endpoint: String,
        method: HTTPMethod = .GET,
        body: Data? = nil,
        headers: [String: String] = [:],
        responseType: T.Type
    ) -> AnyPublisher<T, NetworkError> {
        guard let url = URL(string: baseURL + endpoint) else {
            return Fail(error: NetworkError.invalidURL)
                .eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = body
        
        // Default headers
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Add custom headers
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        // Add authentication token if available
        if let token = AuthManager.shared.token {
            request.setValue("Token \(token)", forHTTPHeaderField: "Authorization")
        }
        
        return session.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: responseType, decoder: JSONDecoder())
            .mapError { error in
                if error is URLError {
                    return NetworkError.noConnection
                } else if error is DecodingError {
                    return NetworkError.decodingError
                } else {
                    return NetworkError.serverError
                }
            }
            .eraseToAnyPublisher()
    }
    
    // MARK: - Authentication Methods
    func login(email: String, password: String) -> AnyPublisher<AuthResponse, NetworkError> {
        let loginData = LoginRequest(email: email, password: password)
        guard let body = try? JSONEncoder().encode(loginData) else {
            return Fail(error: NetworkError.encodingError)
                .eraseToAnyPublisher()
        }
        
        return request(
            endpoint: "/api/auth/login/",
            method: .POST,
            body: body,
            responseType: AuthResponse.self
        )
    }
    
    func register(userData: RegisterRequest) -> AnyPublisher<AuthResponse, NetworkError> {
        guard let body = try? JSONEncoder().encode(userData) else {
            return Fail(error: NetworkError.encodingError)
                .eraseToAnyPublisher()
        }
        
        return request(
            endpoint: "/api/auth/register/",
            method: .POST,
            body: body,
            responseType: AuthResponse.self
        )
    }
    
    func logout() -> AnyPublisher<MessageResponse, NetworkError> {
        return request(
            endpoint: "/api/auth/logout/",
            method: .POST,
            responseType: MessageResponse.self
        )
    }
    
    // MARK: - User Profile
    func getUserProfile() -> AnyPublisher<UserProfile, NetworkError> {
        return request(
            endpoint: "/api/auth/user/",
            method: .GET,
            responseType: UserProfile.self
        )
    }
    
    // MARK: - Food Requests
    func getFoodRequests() -> AnyPublisher<[FoodRequest], NetworkError> {
        return request(
            endpoint: "/api/food-requests/",
            method: .GET,
            responseType: [FoodRequest].self
        )
    }
    
    func createFoodRequest(request: CreateFoodRequest) -> AnyPublisher<FoodRequest, NetworkError> {
        guard let body = try? JSONEncoder().encode(request) else {
            return Fail(error: NetworkError.encodingError)
                .eraseToAnyPublisher()
        }
        
        return self.request(
            endpoint: "/api/food-requests/",
            method: .POST,
            body: body,
            responseType: FoodRequest.self
        )
    }
    
    func claimFoodRequest(id: Int) -> AnyPublisher<FoodRequest, NetworkError> {
        return request(
            endpoint: "/api/food-requests/\(id)/claim/",
            method: .POST,
            responseType: FoodRequest.self
        )
    }
    
    func getFoodRequestDetail(id: Int) -> AnyPublisher<FoodRequest, NetworkError> {
        return request(
            endpoint: "/api/food-requests/\(id)/",
            method: .GET,
            responseType: FoodRequest.self
        )
    }
    
    // MARK: - Dashboard Statistics
    func getDashboardStats() -> AnyPublisher<DashboardStats, NetworkError> {
        return request(
            endpoint: "/api/dashboard/stats/",
            method: .GET,
            responseType: DashboardStats.self
        )
    }
}

// MARK: - HTTP Methods
enum HTTPMethod: String {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case DELETE = "DELETE"
    case PATCH = "PATCH"
}

// MARK: - Network Errors
enum NetworkError: Error, LocalizedError {
    case invalidURL
    case noConnection
    case serverError
    case decodingError
    case encodingError
    case unauthorized
    case notFound
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .noConnection:
            return "No internet connection"
        case .serverError:
            return "Server error occurred"
        case .decodingError:
            return "Failed to decode response"
        case .encodingError:
            return "Failed to encode request"
        case .unauthorized:
            return "Unauthorized access"
        case .notFound:
            return "Resource not found"
        }
    }
}
