//
//  MainViewModel.swift
//  ios_akakce_cs
//
//  Created by İhsan Akbay on 11.03.2025.
//

import Combine
import Foundation

final class MainViewModel {
    // MARK: - Properties

    private var cancellables = Set<AnyCancellable>()
    private let networkService: MainViewNetworkServiceProtocol

    // Loading state tracking
    private var isLoadingCompleteHorizontal = false
    private var isLoadingCompleteVertical = false

    // Published variables
    @Published var horizontalProducts: [Product] = []
    @Published var verticalProducts: [Product] = []
    @Published var isLoading: Bool = false
    @Published var error: NetworkRequestError?

    init(networkService: MainViewNetworkServiceProtocol = MainViewNetworkService()) {
        self.networkService = networkService
    }

    // MARK: - Methods

    func fetchProducts() {
        isLoading = true
        error = nil
        isLoadingCompleteHorizontal = false
        isLoadingCompleteVertical = false

        fetchAllProducts()
        fetchHorizontalProducts()
    }

    func fetchHorizontalProducts() {
        networkService.fetchHorizontalProducts()
            .sink { [weak self] completion in
                guard let self else { return }
                switch completion {
                case .finished:
                    isLoadingCompleteHorizontal = true
                    self.updateLoadingState()
                    print("All Products fetched successfully")
                case .failure(let error):
                    self.error = error
                    print("Failed to fetch products: \(error)")
                }
            } receiveValue: { [weak self] products in
                guard let self else { return }
                self.horizontalProducts = products
            }
            .store(in: &cancellables)
    }

    func fetchAllProducts() {
        networkService.fetchAllProducts()
            .sink { [weak self] completion in
                guard let self else { return }
                switch completion {
                case .finished:
                    isLoadingCompleteVertical = true
                    self.updateLoadingState()
                    print("All Products fetched successfully")
                case .failure(let error):
                    self.error = error
                    print("Failed to fetch products: \(error)")
                }
            } receiveValue: { [weak self] products in
                guard let self else { return }
                self.verticalProducts = products
            }
            .store(in: &cancellables)
    }

    private func updateLoadingState() {
        if isLoadingCompleteHorizontal, isLoadingCompleteVertical {
            isLoading = false
        }
    }
}
