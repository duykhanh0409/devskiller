
//
//  SpaceXHomeScreen_Tests.swift
//  DevskillerTests
//
//  Created by Khanh Nguyen on 2/9/25.
//  Copyright © 2025 Mindera. All rights reserved.
//

import XCTest
import SwiftUI
import Combine
@testable import Devskiller

final class SpaceXHomeScreen_Tests: XCTestCase {
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
    
    func testSpaceXHomeScreenRendersWithoutCrashing() throws {
        let homeScreen = SpaceXHomeScreen()
        
        XCTAssertNotNil(homeScreen)
    }
    
    func testHomeScreenLoadsDataSuccessfully() throws {
        mockService = SpaceXService(
            fetchCompanyPublisher: MockSpaceXService.fetchCompanySuccess,
            fetchLaunchesPublisher: MockSpaceXService.fetchLaunchesSuccess
        )
        viewModel = SpaceXViewModel(service: mockService)
        
        viewModel.loadData()

        let expectation = XCTestExpectation(description: "Data loaded successfully")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertNotNil(self.viewModel.company)
            XCTAssertFalse(self.viewModel.launches.isEmpty)
            XCTAssertFalse(self.viewModel.isLoading)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testErrorHandling() throws {
        mockService = SpaceXService(
            fetchCompanyPublisher: MockSpaceXService.fetchCompanyFailure,
            fetchLaunchesPublisher: MockSpaceXService.fetchLaunchesFailure
        )
        viewModel = SpaceXViewModel(service: mockService)
    
        viewModel.loadData()
        
        let expectation = XCTestExpectation(description: "Error handled")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertNotNil(self.viewModel.errorMessage)
            XCTAssertTrue(self.viewModel.launches.isEmpty)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
}
