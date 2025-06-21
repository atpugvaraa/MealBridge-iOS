//
//  AuthManager.swift
//  MealBridge
//
//  Created by Aarav Gupta on 15/06/25.
//

import Foundation
import Combine

class AuthManager: ObservableObject {
    static let shared = AuthManager()
    
    @Published var isAuthenticated = false
    @Published var currentUser: UserProfile?
    @Published var token: String?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>()
    private let tokenKey = "mealbridge_auth_token"
    private let userKey = "mealbridge_user_profile"
    
    private init() {
        loadStoredAuth()
    }
    
    // MARK: - Authentication Methods
    func login(email: String, password: String) {
        isLoading = true
        errorMessage = nil
        
        NetworkManager.shared.login(email: email, password: password)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    if case .failure(let error) = completion {
                        self?.errorMessage = error.localizedDescription
                    }
                },
                receiveValue: { [weak self] response in
                    self?.handleAuthSuccess(response)
                }
            )
            .store(in: &cancellables)
    }
    
    func register(userData: RegisterRequest) {
        isLoading = true
        errorMessage = nil
        
        NetworkManager.shared.register(userData: userData)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    if case .failure(let error) = completion {
                        self?.errorMessage = error.localizedDescription
                    }
                },
                receiveValue: { [weak self] response in
                    self?.handleAuthSuccess(response)
                }
            )
            .store(in: &cancellables)
    }
    
    func logout() {
        isLoading = true
        
        NetworkManager.shared.logout()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    // Always clear local auth even if server request fails
                    self?.clearAuth()
                },
                receiveValue: { [weak self] _ in
                    self?.clearAuth()
                }
            )
            .store(in: &cancellables)
    }
    
    func refreshUserProfile() {
        guard isAuthenticated else { return }
        
        NetworkManager.shared.getUserProfile()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        print("Failed to refresh user profile: \(error)")
                    }
                },
                receiveValue: { [weak self] user in
                    self?.currentUser = user
                    self?.saveUserProfile(user)
                }
            )
            .store(in: &cancellables)
    }
    
    // MARK: - Private Methods
    private func handleAuthSuccess(_ response: AuthResponse) {
        self.token = response.token
        self.currentUser = response.user
        self.isAuthenticated = true
        
        saveAuthData(token: response.token, user: response.user)
    }
    
    private func clearAuth() {
        self.token = nil
        self.currentUser = nil
        self.isAuthenticated = false
        
        clearStoredAuth()
    }
    
    // MARK: - Persistence
    private func saveAuthData(token: String, user: UserProfile) {
        UserDefaults.standard.set(token, forKey: tokenKey)
        
        if let userData = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(userData, forKey: userKey)
        }
    }
    
    private func saveUserProfile(_ user: UserProfile) {
        if let userData = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(userData, forKey: userKey)
        }
    }
    
    private func loadStoredAuth() {
        if let storedToken = UserDefaults.standard.string(forKey: tokenKey),
           let userData = UserDefaults.standard.data(forKey: userKey),
           let user = try? JSONDecoder().decode(UserProfile.self, from: userData) {
            
            self.token = storedToken
            self.currentUser = user
            self.isAuthenticated = true
        }
    }
    
    private func clearStoredAuth() {
        UserDefaults.standard.removeObject(forKey: tokenKey)
        UserDefaults.standard.removeObject(forKey: userKey)
    }
}