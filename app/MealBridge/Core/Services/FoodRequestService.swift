//
//  FoodRequestService.swift
//  MealBridge
//
//  Created by Aarav Gupta on 15/06/25.
//

import Foundation
import Combine

class FoodRequestService: ObservableObject {
    static let shared = FoodRequestService()
    
    @Published var foodRequests: [FoodRequest] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>()
    
    private init() {}
    
    // MARK: - Food Request Operations
    func fetchFoodRequests() {
        isLoading = true
        errorMessage = nil
        
        NetworkManager.shared.getFoodRequests()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    if case .failure(let error) = completion {
                        self?.errorMessage = error.localizedDescription
                    }
                },
                receiveValue: { [weak self] requests in
                    self?.foodRequests = requests
                }
            )
            .store(in: &cancellables)
    }
    
    func createFoodRequest(
        foodType: String,
        description: String?,
        quantity: String?,
        isVegetarian: Bool,
        expiresAt: String? = nil
    ) {
        isLoading = true
        errorMessage = nil
        
        let request = CreateFoodRequest(
            foodType: foodType,
            description: description,
            quantity: quantity,
            isVegetarian: isVegetarian,
            expiresAt: expiresAt
        )
        
        NetworkManager.shared.createFoodRequest(request: request)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    if case .failure(let error) = completion {
                        self?.errorMessage = error.localizedDescription
                    }
                },
                receiveValue: { [weak self] newRequest in
                    self?.foodRequests.insert(newRequest, at: 0)
                }
            )
            .store(in: &cancellables)
    }
    
    func claimFoodRequest(id: Int) {
        isLoading = true
        errorMessage = nil
        
        NetworkManager.shared.claimFoodRequest(id: id)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    if case .failure(let error) = completion {
                        self?.errorMessage = error.localizedDescription
                    }
                },
                receiveValue: { [weak self] updatedRequest in
                    if let index = self?.foodRequests.firstIndex(where: { $0.id == id }) {
                        self?.foodRequests[index] = updatedRequest
                    }
                }
            )
            .store(in: &cancellables)
    }
    
    func getFoodRequestDetail(id: Int, completion: @escaping (Result<FoodRequest, NetworkError>) -> Void) {
        NetworkManager.shared.getFoodRequestDetail(id: id)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { result in
                    if case .failure(let error) = result {
                        completion(.failure(error))
                    }
                },
                receiveValue: { request in
                    completion(.success(request))
                }
            )
            .store(in: &cancellables)
    }
    
    // MARK: - Filtering Methods
    func getAvailableRequests() -> [FoodRequest] {
        return foodRequests.filter { $0.isAvailable && !$0.isClaimed }
    }
    
    func getClaimedRequests() -> [FoodRequest] {
        return foodRequests.filter { $0.isClaimed }
    }
    
    func getRequestsByCategory(_ category: FoodCategory) -> [FoodRequest] {
        return foodRequests.filter { $0.foodType.lowercased() == category.rawValue }
    }
    
    func getMyRequests() -> [FoodRequest] {
        guard let currentUser = AuthManager.shared.currentUser else { return [] }
        return foodRequests.filter { $0.restaurant.id == currentUser.id }
    }
    
    func getMyClaimedRequests() -> [FoodRequest] {
        guard let currentUser = AuthManager.shared.currentUser else { return [] }
        return foodRequests.filter { $0.claimedBy?.id == currentUser.id }
    }
}