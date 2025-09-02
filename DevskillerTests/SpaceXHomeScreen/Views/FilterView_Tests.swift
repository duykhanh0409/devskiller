//
//  FilterView_Tests.swift
//  DevskillerTests
//
//  Created by Khanh Nguyen on 2/9/25.
//  Copyright © 2025 Mindera. All rights reserved.
//

import XCTest
import SwiftUI
@testable import Devskiller

final class FilterView_Tests: XCTestCase {
    
    func testShowSuccessfulOnly() throws {
        let mockService = SpaceXService(
            fetchCompanyPublisher: MockSpaceXService.fetchCompanySuccess,
            fetchLaunchesPublisher: MockSpaceXService.fetchLaunchesSuccess
        )
        let viewModel = SpaceXViewModel(service: mockService)
        
        let filterView = FilterView(viewModel: viewModel)
        
        XCTAssertNotNil(filterView)
        
        XCTAssertFalse(viewModel.showSuccessfulOnly)
        
        viewModel.showSuccessfulOnly = true
        XCTAssertTrue(viewModel.showSuccessfulOnly)
        
        viewModel.showSuccessfulOnly = false
        XCTAssertFalse(viewModel.showSuccessfulOnly)
    }
    
    func testSortOrder() throws {
        let mockService = SpaceXService(
            fetchCompanyPublisher: MockSpaceXService.fetchCompanySuccess,
            fetchLaunchesPublisher: MockSpaceXService.fetchLaunchesSuccess
        )
        let viewModel = SpaceXViewModel(service: mockService)
        
        let filterView = FilterView(viewModel: viewModel)
        
        XCTAssertNotNil(filterView)
        
        XCTAssertEqual(viewModel.sortOrder, .descending)
        
        viewModel.sortOrder = .ascending
        XCTAssertEqual(viewModel.sortOrder, .ascending)
        
        viewModel.sortOrder = .descending
        XCTAssertEqual(viewModel.sortOrder, .descending)
    
        viewModel.toggleSortOrder()
        XCTAssertEqual(viewModel.sortOrder, .ascending)
        
        viewModel.toggleSortOrder()
        XCTAssertEqual(viewModel.sortOrder, .descending)
    }
    
    func testClearAllFilters() throws {
        let mockService = SpaceXService(
            fetchCompanyPublisher: MockSpaceXService.fetchCompanySuccess,
            fetchLaunchesPublisher: MockSpaceXService.fetchLaunchesSuccess
        )
        let viewModel = SpaceXViewModel(service: mockService)
        
        viewModel.selectedYear = 2023
        viewModel.showSuccessfulOnly = true
        viewModel.sortOrder = .ascending
        
        XCTAssertEqual(viewModel.selectedYear, 2023)
        XCTAssertTrue(viewModel.showSuccessfulOnly)
        XCTAssertEqual(viewModel.sortOrder, .ascending)
        
        let filterView = FilterView(viewModel: viewModel)
        viewModel.clearFilters()
        
        XCTAssertNotNil(filterView)
        
        XCTAssertNil(viewModel.selectedYear)
        XCTAssertFalse(viewModel.showSuccessfulOnly)
        XCTAssertEqual(viewModel.sortOrder, .descending)
    }
}
