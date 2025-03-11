//
//  MainViewModelTests.swift
//  ios_akakce_cs
//
//  Created by İhsan Akbay on 11.03.2025.
//

import Combine
@testable import ios_akakce_cs
import XCTest

final class MainViewModelTests: XCTestCase {
    private var mockNetworkService: MockNetworkService!
    private var viewModel: MainViewModel!
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockNetworkService = MockNetworkService()
        viewModel = MainViewModel(networkService: mockNetworkService)
        cancellables = []
    }
    
    override func tearDown() {
        mockNetworkService = nil
        viewModel = nil
        cancellables = nil
        super.tearDown()
    }
    
    // MARK: - Tests
    
    func testFetchProductsSuccess() {
        // Given
        let expectation = XCTestExpectation(description: "Fetch products successfully")
        let horizontalProducts = createMockProducts(count: 4)
        let verticalProducts = createMockProducts(count: 10)
        
        mockNetworkService.horizontalProductsToReturn = horizontalProducts
        mockNetworkService.verticalProductsToReturn = verticalProducts
        
        var loadingStates: [Bool] = []
        var horizontalProductsResult: [Product] = []
        var verticalProductsResult: [Product] = []
        var errorResult: NetworkRequestError?
        
        // When
        viewModel.$isLoading
            .sink { isLoading in
                loadingStates.append(isLoading)
                if loadingStates.count >= 2 && !isLoading {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        viewModel.$horizontalProducts
            .dropFirst() // Skip initial empty value
            .sink { products in
                horizontalProductsResult = products
                XCTAssertEqual(products.count, 4, "Horizontal products count should be 4")
                if !products.isEmpty && !horizontalProducts.isEmpty {
                    XCTAssertEqual(products.first?.id, horizontalProducts.first?.id)
                }
            }
            .store(in: &cancellables)
        
        viewModel.$verticalProducts
            .dropFirst() // Skip initial empty value
            .sink { products in
                verticalProductsResult = products
                print("Vertical products count: \(products.count)")
                XCTAssertEqual(products.count, 10, "Vertical products count should be 10")
                if !products.isEmpty && !verticalProducts.isEmpty {
                    XCTAssertEqual(products.first?.id, verticalProducts.first?.id)
                }
            }
            .store(in: &cancellables)
        
        viewModel.$error
            .compactMap { $0 }
            .sink { error in
                errorResult = error
            }
            .store(in: &cancellables)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.viewModel.fetchProducts()
        }
        
        // Then
        wait(for: [expectation], timeout: 1.0)
        
        XCTAssertEqual(horizontalProductsResult, horizontalProducts, "Horizontal products should match mock data")
        XCTAssertEqual(verticalProductsResult, verticalProducts, "Vertical products should match mock data")
        XCTAssertTrue(loadingStates.contains(true), "Should include loading state true")
        XCTAssertEqual(loadingStates.last, false, "Should end with loading state false")
        XCTAssertNil(errorResult, "Error should be nil on success")
    }
    
    func testFetchProductsHorizontalFailure() {
        // Given
        let expectation = XCTestExpectation(description: "Horizontal products fetch failure")
        let verticalProducts = createMockProducts(count: 2)
        
        mockNetworkService.shouldFailHorizontalProducts = true
        mockNetworkService.error = .serverError
        mockNetworkService.verticalProductsToReturn = verticalProducts
        
        var errorResult: NetworkRequestError?
        
        // When
        viewModel.$error
            .compactMap { $0 }
            .sink { error in
                errorResult = error
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.viewModel.fetchProducts()
        }
        
        // Then
        wait(for: [expectation], timeout: 1.0)
        
        XCTAssertEqual(errorResult, .serverError, "Error should be server error")
        XCTAssertTrue(viewModel.horizontalProducts.isEmpty, "Horizontal products should be empty on failure")
        XCTAssertEqual(viewModel.verticalProducts, verticalProducts, "Vertical products should still be loaded")
    }
    
    func testFetchProductsVerticalFailure() {
        // Given
        let expectation = XCTestExpectation(description: "Vertical products fetch failure")
        let horizontalProducts = createMockProducts(count: 2)
        
        mockNetworkService.horizontalProductsToReturn = horizontalProducts
        mockNetworkService.shouldFailVerticalProducts = true
        mockNetworkService.error = .notFound
        
        var errorResult: NetworkRequestError?
        
        // When
        viewModel.$error
            .compactMap { $0 }
            .sink { error in
                errorResult = error
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.viewModel.fetchProducts()
        }
        
        // Then
        wait(for: [expectation], timeout: 1.0)
        
        XCTAssertEqual(errorResult, .notFound, "Error should be not found")
        XCTAssertEqual(viewModel.horizontalProducts, horizontalProducts, "Horizontal products should still be loaded")
        XCTAssertTrue(viewModel.verticalProducts.isEmpty, "Vertical products should be empty on failure")
    }
    
    func testLoadingStateUpdates() {
        // Given
        let expectation = XCTestExpectation(description: "Loading state updates correctly")
        let horizontalProducts = createMockProducts(count: 1)
        let verticalProducts = createMockProducts(count: 1)
        
        mockNetworkService.horizontalProductsToReturn = horizontalProducts
        mockNetworkService.verticalProductsToReturn = verticalProducts
        
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
            self.viewModel.fetchProducts()
        }
        
        // Then
        wait(for: [expectation], timeout: 1.0)
        
        XCTAssertTrue(loadingStates.contains(true), "Loading states should include true")
        XCTAssertEqual(loadingStates.last, false, "Loading states should end with false")
    }
    
    func testFetchHorizontalProductsOnly() {
        // Given
        let expectation = XCTestExpectation(description: "Fetch horizontal products only")
        let horizontalProducts = createMockProducts(count: 5)
        
        mockNetworkService.horizontalProductsToReturn = horizontalProducts
        
        var horizontalProductsResult: [Product] = []
        
        // When
        viewModel.$horizontalProducts
            .dropFirst() // Skip initial empty value
            .sink { products in
                horizontalProductsResult = products
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.viewModel.fetchHorizontalProducts()
        }
        
        // Then
        wait(for: [expectation], timeout: 1.0)
        
        XCTAssertEqual(horizontalProductsResult, horizontalProducts, "Horizontal products should match mock data")
        XCTAssertTrue(viewModel.verticalProducts.isEmpty, "Vertical products should remain empty")
    }
    
    // MARK: - Helper Methods
    
    private func createMockProducts(count: Int) -> [Product] {
        var products: [Product] = []
            
        for i in 1...count {
            let product = Product(
                id: i,
                title: "Product \(i)",
                price: Double(i) * 10.0,
                description: "Description for product \(i)",
                category: "Category \(i)",
                image: "https://example.com/image\(i).jpg",
                rating: Rating(rate: Double(i) + 1.0, count: i * 10)
            )
            products.append(product)
        }
            
        return products
    }
}
