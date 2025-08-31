//
//  SpaceXViewModelTests.swift
//  DevskillerTests
//
//  Created by Khanh Nguyen on 31/8/25.
//  Copyright © 2025 Mindera. All rights reserved.
//

import XCTest
import Combine
@testable import Devskiller

class MockSpaceXService: SpaceXServiceProtocol {
    var shouldFail = false
    var mockCompany: Company?
    var mockLaunches: [Launch] = []
    
    func fetchCompany() -> AnyPublisher<Company, Error> {
        if shouldFail {
            return Fail(error: NSError(domain: "Test", code: 500, userInfo: nil))
                .eraseToAnyPublisher()
        }
        
        if let company = mockCompany {
            return Just(company)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        
        return Fail(error: NSError(domain: "Test", code: 404, userInfo: nil))
            .eraseToAnyPublisher()
    }
    
    func fetchLaunches() -> AnyPublisher<[Launch], Error> {
        if shouldFail {
            return Fail(error: NSError(domain: "Test", code: 500, userInfo: nil))
                .eraseToAnyPublisher()
        }
        
        return Just(mockLaunches)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}

class SpaceXViewModelTests: XCTestCase {
    var viewModel: SpaceXViewModel!
    var mockService: MockSpaceXService!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockService = MockSpaceXService()
        viewModel = SpaceXViewModel(service: mockService)
        cancellables = Set<AnyCancellable>()
    }
    
    override func tearDown() {
        viewModel = nil
        mockService = nil
        cancellables = nil
        super.tearDown()
    }
    
    func testLoadDataSuccess() {
        // Given
        let mockCompany = Company(
            id: "test-id",
            headquarters: Headquarters(address: "Test Address", city: "Test City", state: "Test State"),
            links: CompanyLinks(website: "https://test.com", flickr: "https://flickr.com", twitter: "https://twitter.com", elonTwitter: "https://twitter.com/elon"),
            name: "Test Company",
            founder: "Test Founder",
            founded: 2000,
            employees: 1000,
            vehicles: 2,
            launchSites: 3,
            testSites: 1,
            ceo: "Test CEO",
            cto: "Test CTO",
            coo: "Test COO",
            ctoPropulsion: "Test CTO Propulsion",
            valuation: 1000000000,
            summary: "Test summary"
        )
        
        let mockLaunch = Launch(
            id: "launch-1",
            fairings: nil,
            links: LaunchLinks(
                patch: Patch(small: "https://test.com/small.png", large: "https://test.com/large.png"),
                reddit: nil,
                flickr: nil,
                presskit: nil,
                webcast: nil,
                youtubeId: nil,
                article: nil,
                wikipedia: nil
            ),
            staticFireDateUtc: nil,
            staticFireDateUnix: nil,
            tdb: false,
            net: false,
            window: 0,
            rocket: "Test Rocket",
            success: true,
            failures: [],
            details: "Test launch details",
            crew: [],
            ships: [],
            capsules: [],
            payloads: [],
            launchpad: "test-pad",
            autoUpdate: true,
            flightNumber: 1,
            name: "Test Launch",
            dateUtc: "2023-01-01T00:00:00.000Z",
            dateUnix: 1672531200,
            dateLocal: "2023-01-01T00:00:00-00:00",
            datePrecision: "hour",
            upcoming: false,
            cores: []
        )
        
        mockService.mockCompany = mockCompany
        mockService.mockLaunches = [mockLaunch]
        
        // When
        viewModel.loadData()
        
        // Then
        let expectation = XCTestExpectation(description: "Data loaded")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(self.viewModel.company?.name, "Test Company")
            XCTAssertEqual(self.viewModel.launches.count, 1)
            XCTAssertEqual(self.viewModel.launches.first?.name, "Test Launch")
            XCTAssertFalse(self.viewModel.isLoading)
            XCTAssertNil(self.viewModel.errorMessage)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testLoadDataFailure() {
        // Given
        mockService.shouldFail = true
        
        // When
        viewModel.loadData()
        
        // Then
        let expectation = XCTestExpectation(description: "Error occurred")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertNil(self.viewModel.company)
            XCTAssertTrue(self.viewModel.launches.isEmpty)
            XCTAssertFalse(self.viewModel.isLoading)
            XCTAssertNotNil(self.viewModel.errorMessage)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testFilterByYear() {
        // Given
        let launch1 = createMockLaunch(name: "Launch 1", dateUtc: "2023-01-01T00:00:00.000Z")
        let launch2 = createMockLaunch(name: "Launch 2", dateUtc: "2022-01-01T00:00:00.000Z")
        let launch3 = createMockLaunch(name: "Launch 3", dateUtc: "2023-06-01T00:00:00.000Z")
        
        viewModel.launches = [launch1, launch2, launch3]
        
        // When
        viewModel.selectedYear = 2023
        viewModel.applyFilters()
        
        // Then
        XCTAssertEqual(viewModel.filteredLaunches.count, 2)
        XCTAssertTrue(viewModel.filteredLaunches.allSatisfy { launch in
            launch.name == "Launch 1" || launch.name == "Launch 3"
        })
    }
    
    func testFilterBySuccess() {
        // Given
        let successfulLaunch = createMockLaunch(name: "Successful", success: true)
        let failedLaunch = createMockLaunch(name: "Failed", success: false)
        
        viewModel.launches = [successfulLaunch, failedLaunch]
        
        // When
        viewModel.showSuccessfulOnly = true
        viewModel.applyFilters()
        
        // Then
        XCTAssertEqual(viewModel.filteredLaunches.count, 1)
        XCTAssertEqual(viewModel.filteredLaunches.first?.name, "Successful")
    }
    
    func testClearFilters() {
        // Given
        viewModel.selectedYear = 2023
        viewModel.showSuccessfulOnly = true
        viewModel.sortOrder = .ascending
        
        // When
        viewModel.clearFilters()
        
        // Then
        XCTAssertNil(viewModel.selectedYear)
        XCTAssertFalse(viewModel.showSuccessfulOnly)
        XCTAssertEqual(viewModel.sortOrder, .descending)
    }
    
    // Helper method to create mock launches
    private func createMockLaunch(name: String, dateUtc: String, success: Bool? = true) -> Launch {
        return Launch(
            id: UUID().uuidString,
            fairings: nil,
            links: LaunchLinks(
                patch: nil,
                reddit: nil,
                flickr: nil,
                presskit: nil,
                webcast: nil,
                youtubeId: nil,
                article: nil,
                wikipedia: nil
            ),
            staticFireDateUtc: nil,
            staticFireDateUnix: nil,
            tdb: false,
            net: false,
            window: 0,
            rocket: "Test Rocket",
            success: success,
            failures: [],
            details: nil,
            crew: [],
            ships: [],
            capsules: [],
            payloads: [],
            launchpad: "test-pad",
            autoUpdate: true,
            flightNumber: 1,
            name: name,
            dateUtc: dateUtc,
            dateUnix: 0,
            dateLocal: dateUtc,
            datePrecision: "hour",
            upcoming: false,
            cores: []
        )
    }
}
