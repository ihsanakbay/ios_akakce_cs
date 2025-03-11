import Combine
import Foundation
@testable import ios_akakce_cs

class MockDetailViewNetworkService: DetailViewNetworkServiceProtocol {
    var productToReturn: Product?
    var shouldFail = false
    var error: NetworkRequestError = .serverError

    func getProductDetail(productId: Int) -> AnyPublisher<Product, NetworkRequestError> {
        if shouldFail {
            return Fail(error: error).eraseToAnyPublisher()
        } else if let product = productToReturn {
            return Just(product)
                .setFailureType(to: NetworkRequestError.self)
                .eraseToAnyPublisher()
        } else {
            return Fail(error: .decodingError("Decoding error")).eraseToAnyPublisher()
        }
    }
}
