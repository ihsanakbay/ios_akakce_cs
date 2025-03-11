//
//  DetailViewModelTests.swift
//  ios_akakce_cs
//
//  Created by İhsan Akbay on 11.03.2025.
//

import Combine
@testable import ios_akakce_cs
import XCTest

final class DetailViewModelTests: XCTestCase {
    private var mockNetworkService: MockDetailViewNetworkService!
    private var viewModel: DetailViewModel!
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockNetworkService = MockDetailViewNetworkService()
        viewModel = DetailViewModel(productId: 1, networkService: mockNetworkService)
        cancellables = []
    }
    
    override func tearDown() {
        mockNetworkService = nil
        viewModel = nil
        cancellables = nil
        super.tearDown()
    }
    
    // MARK: - Tests
    
    func testFetchProductDetailSuccess() {
        // Given
        let expectation = XCTestExpectation(description: "Fetch product detail successfully")
        let mockProduct = createMockProduct()
        mockNetworkService.productToReturn = mockProduct
        
        var loadingStates: [Bool] = []
        var productResult: Product?
        var errorResult: NetworkRequestError?
        
        // When
        viewModel.$isLoading
            .sink { isLoading in
                loadingStates.append(isLoading)
            }
            .store(in: &cancellables)
        
        viewModel.$product
            .compactMap { $0 }
            .sink { product in
                productResult = product
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.$error
            .compactMap { $0 }
            .sink { error in
                errorResult = error
            }
            .store(in: &cancellables)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.viewModel.fetchProductDetail()
        }
        
        // Then
        wait(for: [expectation], timeout: 1.0)
        
        XCTAssertEqual(productResult, mockProduct, "Product should match mock data")
        XCTAssertTrue(loadingStates.contains(true), "Should include loading state true")
        XCTAssertEqual(loadingStates.last, false, "Should end with loading state false")
        XCTAssertNil(errorResult, "Error should be nil on success")
    }
    
    func testFetchProductDetailFailure() {
        // Given
        let expectation = XCTestExpectation(description: "Fetch product detail failure")
        mockNetworkService.shouldFail = true
        mockNetworkService.error = .notFound
        
        var errorResult: NetworkRequestError?
        var loadingStates: [Bool] = []
        
        // When
        viewModel.$isLoading
            .sink { isLoading in
                loadingStates.append(isLoading)
            }
            .store(in: &cancellables)
        
        viewModel.$error
            .compactMap { $0 }
            .sink { error in
                errorResult = error
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.viewModel.fetchProductDetail()
        }
        
        // Then
        wait(for: [expectation], timeout: 1.0)
        
        XCTAssertEqual(errorResult, .notFound, "Error should be not found")
        XCTAssertTrue(loadingStates.contains(true), "Should include loading state true")
        XCTAssertNil(viewModel.product, "Product should be nil on failure")
    }
    
    func testLoadingStateUpdates() {
        // Given
        let expectation = XCTestExpectation(description: "Loading state updates correctly")
        let mockProduct = createMockProduct()
        mockNetworkService.productToReturn = mockProduct
        
        var loadingStates: [Bool] = []
        
        // When
        viewModel.$isLoading
            .sink { isLoading in
                loadingStates.append(isLoading)
                if loadingStates.count >= 3 { // Initial + loading + finished
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.viewModel.fetchProductDetail()
        }
        
        // Then
        wait(for: [expectation], timeout: 1.0)
        
        XCTAssertEqual(loadingStates[0], false, "Initial loading state should be false")
        XCTAssertEqual(loadingStates[1], true, "Loading state should change to true when fetching")
        XCTAssertEqual(loadingStates[2], false, "Loading state should change to false when complete")
    }
    
    // MARK: - Helper Methods
    
    private func createMockProduct(id: Int = 1) -> Product {
        return Product(
            id: id,
            title: "Test Product \(id)",
            price: 99.99,
            description: "This is a test product description",
            category: "Test Category",
            image: "https://example.com/image.jpg",
            rating: Rating(rate: 4.5, count: 100)
        )
    }
}
