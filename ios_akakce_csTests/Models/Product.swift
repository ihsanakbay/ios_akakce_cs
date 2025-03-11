//
//  Product.swift
//  ios_akakce_csTests
//
//  Created by İhsan Akbay on 11.03.2025.
//

import Foundation
@testable import ios_akakce_cs

extension Product: @retroactive Equatable {
    public static func == (lhs: Product, rhs: Product) -> Bool {
        return lhs.id == rhs.id &&
            lhs.title == rhs.title &&
            lhs.price == rhs.price &&
            lhs.description == rhs.description &&
            lhs.category == rhs.category &&
            lhs.image == rhs.image &&
            lhs.rating == rhs.rating
    }
}

extension Rating: @retroactive Equatable {
    public static func == (lhs: Rating, rhs: Rating) -> Bool {
        return lhs.rate == rhs.rate && lhs.count == rhs.count
    }
}
