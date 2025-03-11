//
//  DetailViewModel.swift
//  ios_akakce_cs
//
//  Created by İhsan Akbay on 11.03.2025.
//

import Combine
import Foundation

final class DetailViewModel {
    private var cancellables = Set<AnyCancellable>()
    private let networkService: DetailViewNetworkServiceProtocol
    private let productId: Int

    @Published var product: Product?
    @Published var isLoading: Bool = false
    @Published var error: NetworkRequestError?

    init(productId: Int, networkService: DetailViewNetworkServiceProtocol = DetailViewNetworkService()) {
        self.productId = productId
        self.networkService = networkService
    }

    func fetchProductDetail() {
        isLoading = true
        error = nil

        networkService.getProductDetail(productId: productId)
            .sink { [weak self] completion in
                guard let self else { return }
                switch completion {
                case .finished:
                    isLoading = false
                    print("Product detail fetched successfully")
                case .failure(let error):
                    self.error = error
                    print("Failed to fetch product detail: \(error)")
                }
            } receiveValue: { [weak self] product in
                guard let self else { return }
                self.product = product
            }
            .store(in: &cancellables)
    }
}
