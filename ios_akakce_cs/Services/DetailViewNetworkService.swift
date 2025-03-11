//
//  DetailViewNetworkService.swift
//  ios_akakce_cs
//
//  Created by İhsan Akbay on 11.03.2025.
//

import Combine
import Foundation

protocol DetailViewNetworkServiceProtocol {
    func getProductDetail(productId: Int) -> AnyPublisher<Product, NetworkRequestError>
}

class DetailViewNetworkService: DetailViewNetworkServiceProtocol {
    func getProductDetail(productId: Int) -> AnyPublisher<Product, NetworkRequestError> {
        let request = NetworkRouter.getProductDetail(id: productId)
        return NetworkClient.dispatch(request)
    }
}
