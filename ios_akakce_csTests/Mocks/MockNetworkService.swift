import Combine
import Foundation
@testable import ios_akakce_cs

class MockNetworkService: MainViewNetworkServiceProtocol {
    var horizontalProductsToReturn: [Product] = []
    var verticalProductsToReturn: [Product] = []
    var shouldFailHorizontalProducts = false
    var shouldFailVerticalProducts = false
    var error: NetworkRequestError = .serverError

    func fetchHorizontalProducts() -> AnyPublisher<[Product], NetworkRequestError> {
        if shouldFailHorizontalProducts {
            return Fail(error: error).eraseToAnyPublisher()
        } else {
            return Just(horizontalProductsToReturn)
                .setFailureType(to: NetworkRequestError.self)
                .eraseToAnyPublisher()
        }
    }

    func fetchAllProducts() -> AnyPublisher<[Product], NetworkRequestError> {
        if shouldFailVerticalProducts {
            return Fail(error: error).eraseToAnyPublisher()
        } else {
            return Just(verticalProductsToReturn)
                .setFailureType(to: NetworkRequestError.self)
                .eraseToAnyPublisher()
        }
    }
}
