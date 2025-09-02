//
//  SpaceXService_Tests.swift
//  DevskillerTests
//
//  Created by Khanh Nguyen on 2/9/25.
//  Copyright © 2025 Mindera. All rights reserved.
//

import XCTest
import Combine
@testable import Devskiller

final class SpaceXService_Tests: XCTestCase {
    var service: SpaceXService!
    var cancellables: Set<AnyCancellable>!
    
    override func setUpWithError() throws {
        cancellables = Set<AnyCancellable>()
    }
    
    override func tearDownWithError() throws {
        cancellables = nil
    }
    
    func testFetchCompanySuccess() throws {
        service = SpaceXService(fetchCompanyPublisher: MockSpaceXService.fetchCompanySuccess)
        let expectation = XCTestExpectation(description: "Company fetched successfully")
        var receivedCompany: Company?
        var receivedError: Error?
        
        service.fetchCompany()
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        receivedError = error
                    }
                },
                receiveValue: { company in
                    receivedCompany = company
                    expectation.fulfill()
                }
            )
            .store(in: &cancellables)
        wait(for: [expectation], timeout: 2.0)
        XCTAssertNotNil(receivedCompany)
        XCTAssertNil(receivedError)
        XCTAssertEqual(receivedCompany?.name, "Test Company")
    }
    
    func testFetchCompanyFailure() throws {
        service = SpaceXService(fetchCompanyPublisher: MockSpaceXService.fetchCompanyFailure)
        let expectation = XCTestExpectation(description: "Company fetch failed")
        var receivedCompany: Company?
        var receivedError: Error?

        service.fetchCompany()
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        receivedError = error
                        expectation.fulfill()
                    }
                },
                receiveValue: { company in
                    receivedCompany = company
                }
            )
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 2.0)
        XCTAssertNil(receivedCompany)
        XCTAssertNotNil(receivedError)
    }
    
    func testFetchLaunchesPaginatedSuccess() throws {
        service = SpaceXService(fetchLaunchesPublisher: MockSpaceXService.fetchLaunchesSuccess)
        let expectation = XCTestExpectation(description: "Launches fetched successfully")
        var receivedResponse: LaunchQueryResponse?
        var receivedError: Error?
        
        let query = LaunchQueryFilter(dateUtc: nil, success: nil)
        
        service.fetchLaunchesPaginated(page: 1, limit: 10, query: query)
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        receivedError = error
                    }
                },
                receiveValue: { response in
                    receivedResponse = response
                    expectation.fulfill()
                }
            )
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 2.0)
        XCTAssertNotNil(receivedResponse)
        XCTAssertNil(receivedError)
        XCTAssertEqual(receivedResponse?.docs.count, 2)
    }
    
    func testFetchLaunchesPaginatedFailure() throws {
        service = SpaceXService(fetchLaunchesPublisher: MockSpaceXService.fetchLaunchesFailure)
        let expectation = XCTestExpectation(description: "Launches fetch failed")
        var receivedResponse: LaunchQueryResponse?
        var receivedError: Error?
        
        let query = LaunchQueryFilter(dateUtc: nil, success: nil)
        
        service.fetchLaunchesPaginated(page: 1, limit: 10, query: query)
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        receivedError = error
                        expectation.fulfill()
                    }
                },
                receiveValue: { response in
                    receivedResponse = response
                }
            )
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 2.0)
        XCTAssertNil(receivedResponse)
        XCTAssertNotNil(receivedError)
    }
}
