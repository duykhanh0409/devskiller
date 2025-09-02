//
//  MockSpaceXService.swift
//  DevskillerTests
//
//  Created by Khanh Nguyen on 2/9/25.
//  Copyright © 2025 Mindera. All rights reserved.
//

import Foundation
import Combine
@testable import Devskiller

class MockSpaceXService {
    
    static func fetchCompanySuccess() -> AnyPublisher<Company, Error> {
        let mockCompany = Company(
            id: "test-id",
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
            headquarters: Headquarters(address: "Test Address", city: "Test City", state: "Test State"),
            links: CompanyLinks(website: "https://test.com", flickr: "https://flickr.com", twitter: "https://twitter.com", elonTwitter: "https://twitter.com/elon"),
            summary: "Test summary"
        )
        
        return Just(mockCompany)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    static func fetchCompanyFailure() -> AnyPublisher<Company, Error> {
        return Fail(error: URLError(.badServerResponse))
            .eraseToAnyPublisher()
    }
    
    static func fetchLaunchesSuccess(page: Int, limit: Int, query: LaunchQueryFilter) -> AnyPublisher<LaunchQueryResponse, Error> {
        let mockLaunches = [
            createMockLaunch(name: "Test Launch 1", dateUtc: "2023-01-01T00:00:00.000Z", success: true),
            createMockLaunch(name: "Test Launch 2", dateUtc: "2023-06-01T00:00:00.000Z", success: false)
        ]
        
        let mockResponse = LaunchQueryResponse(
            docs: mockLaunches,
            totalDocs: 2,
            limit: limit,
            totalPages: 1,
            page: page,
            pagingCounter: page,
            hasPrevPage: false,
            hasNextPage: false,
            prevPage: nil,
            nextPage: nil
        )
        
        return Just(mockResponse)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    static func fetchLaunchesFailure(page: Int, limit: Int, query: LaunchQueryFilter) -> AnyPublisher<LaunchQueryResponse, Error> {
        return Fail(error: URLError(.badServerResponse))
            .eraseToAnyPublisher()
    }
    
    private static func createMockLaunch(name: String, dateUtc: String, success: Bool? = true) -> Launch {
        return Launch(
            id: UUID().uuidString,
            flightNumber: 1,
            name: name,
            dateUtc: dateUtc,
            dateUnix: 0,
            dateLocal: dateUtc,
            datePrecision: "hour",
            staticFireDateUtc: nil,
            staticFireDateUnix: nil,
            net: false,
            window: 0,
            rocket: "Test Rocket",
            success: success,
            failures: [],
            upcoming: false,
            details: "Test launch details",
            fairings: nil,
            crew: [],
            ships: [],
            capsules: [],
            payloads: [],
            launchpad: "test-pad",
            cores: [],
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
            autoUpdate: true
        )
    }
}
