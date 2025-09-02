//
//  SpaceXViewModel_Tests.swift
//  DevskillerTests
//
//  Created by Khanh Nguyen on 2/9/25.
//  Copyright © 2025 Mindera. All rights reserved.
//

import XCTest
import Combine
@testable import Devskiller

final class SpaceXViewModel_Tests: XCTestCase {
    var viewModel: SpaceXViewModel!
    var mockService: SpaceXService!
    var cancellables: Set<AnyCancellable>!
    
    override func setUpWithError() throws {
        cancellables = Set<AnyCancellable>()
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
        mockService = nil
        cancellables = nil
    }
    
    func testLoadDataSuccess() throws {
        mockService = SpaceXService(
            fetchCompanyPublisher: MockSpaceXService.fetchCompanySuccess,
            fetchLaunchesPublisher: MockSpaceXService.fetchLaunchesSuccess
        )
        viewModel = SpaceXViewModel(service: mockService)
        viewModel.loadData()

        let expectation = XCTestExpectation(description: "Data loaded successfully")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(self.viewModel.company?.name, "Test Company")
            XCTAssertEqual(self.viewModel.launches.count, 2)
            XCTAssertFalse(self.viewModel.isLoading)
            XCTAssertNil(self.viewModel.errorMessage)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testLoadDataFailure() throws {
        mockService = SpaceXService(
            fetchCompanyPublisher: MockSpaceXService.fetchCompanyFailure,
            fetchLaunchesPublisher: MockSpaceXService.fetchLaunchesFailure
        )
        viewModel = SpaceXViewModel(service: mockService)

        viewModel.loadData()
        let expectation = XCTestExpectation(description: "Data loading failed")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertNil(self.viewModel.company)
            XCTAssertTrue(self.viewModel.launches.isEmpty)
            XCTAssertFalse(self.viewModel.isLoading)
            XCTAssertNotNil(self.viewModel.errorMessage)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testFilterByYear() throws {
        mockService = SpaceXService(
            fetchCompanyPublisher: MockSpaceXService.fetchCompanySuccess,
            fetchLaunchesPublisher: MockSpaceXService.fetchLaunchesSuccess
        )
        viewModel = SpaceXViewModel(service: mockService)
        
        viewModel.loadData()
        viewModel.selectedYear = 2023
        viewModel.applyFilters()
        
        let expectation = XCTestExpectation(description: "Filtered by year")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(self.viewModel.selectedYear, 2023)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testClearFilters() throws {
        mockService = SpaceXService(
            fetchCompanyPublisher: MockSpaceXService.fetchCompanySuccess,
            fetchLaunchesPublisher: MockSpaceXService.fetchLaunchesSuccess
        )
        viewModel = SpaceXViewModel(service: mockService)
    
        viewModel.selectedYear = 2023
        viewModel.showSuccessfulOnly = true
        viewModel.sortOrder = .ascending
        
        viewModel.clearFilters()
        
        XCTAssertNil(viewModel.selectedYear)
        XCTAssertFalse(viewModel.showSuccessfulOnly)
        XCTAssertEqual(viewModel.sortOrder, .descending)
    }
    
    func testAvailableYears() throws {
        mockService = SpaceXService(
            fetchCompanyPublisher: MockSpaceXService.fetchCompanySuccess,
            fetchLaunchesPublisher: MockSpaceXService.fetchLaunchesSuccess
        )
        viewModel = SpaceXViewModel(service: mockService)
    
        let years = viewModel.availableYears
    
        XCTAssertEqual(years.count, 20) // 2006 to 2025
        XCTAssertEqual(years.first, 2025) // Sorted descending
        XCTAssertEqual(years.last, 2006)
    }
}
