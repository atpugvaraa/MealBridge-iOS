import Foundation
import Combine

class DashboardService: ObservableObject {
    static let shared = DashboardService()
    
    @Published var dashboardStats: DashboardStats?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>()
    
    private init() {}
    
    func fetchDashboardStats() {
        isLoading = true
        errorMessage = nil
        
        NetworkManager.shared.getDashboardStats()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    if case .failure(let error) = completion {
                        self?.errorMessage = error.localizedDescription
                    }
                },
                receiveValue: { [weak self] stats in
                    self?.dashboardStats = stats
                }
            )
            .store(in: &cancellables)
    }
}