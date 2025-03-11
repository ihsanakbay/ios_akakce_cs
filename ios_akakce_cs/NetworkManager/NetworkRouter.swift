//
//  NetworkRouter.swift
//  ios_akakce_cs
//
//  Created by İhsan Akbay on 11.03.2025.
//

import Foundation

class NetworkRouter {
    struct fetchAllProducts: NetworkRequest {
        typealias ReturnType = [Product]
        var path: String = "/products"
        var method: HttpMethod = .get
        var body: [String : Any]?
        var queryParams: [String : Any]?
    }

    struct getProductDetail: NetworkRequest {
        typealias ReturnType = Product
        var path: String = "/products"
        var method: HttpMethod = .get
        var body: [String : Any]?
        var queryParams: [String : Any]?

        init(id: Int) {
            self.path = "\(path)/\(id)"
        }
    }
}
