//
//  MainViewNetworkService.swift
//  ios_akakce_cs
//
//  Created by İhsan Akbay on 11.03.2025.
//

import Combine
import Foundation

protocol MainViewNetworkServiceProtocol {
    func fetchAllProducts() -> AnyPublisher<[Product], NetworkRequestError>
    func fetchHorizontalProducts() -> AnyPublisher<[Product], NetworkRequestError>
}

class MainViewNetworkService: MainViewNetworkServiceProtocol {
    func fetchAllProducts() -> AnyPublisher<[Product], NetworkRequestError> {
        let request = NetworkRouter.fetchAllProducts()
        return NetworkClient.dispatch(request)
    }

    func fetchHorizontalProducts() -> AnyPublisher<[Product], NetworkRequestError> {
        let request = NetworkRouter.fetchAllProducts(queryParams: ["limit": "5"])
        return NetworkClient.dispatch(request)
    }
}
