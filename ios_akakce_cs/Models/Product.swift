//
//  Product.swift
//  ios_akakce_cs
//
//  Created by İhsan Akbay on 11.03.2025.
//

import Foundation

struct Product: Codable {
    let id: Int
    let title: String
    let price: Double
    let description: String
    let category: String
    let image: String
    let rating: Rating
}

struct Rating: Codable {
    let rate: Double
    let count: Int
}
