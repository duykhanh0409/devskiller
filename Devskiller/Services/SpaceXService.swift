//
//  SpaceXService.swift
//  Devskiller
//
//  Created by Khanh Nguyen on 31/8/25.
//  Copyright © 2025 Mindera. All rights reserved.
//

import Foundation
import Combine

protocol SpaceXServiceProtocol {
    func fetchCompany() -> AnyPublisher<Company, Error>
    func fetchLaunchesPaginated(page: Int, limit: Int, query: LaunchQueryFilter) -> AnyPublisher<LaunchQueryResponse, Error>
}

class SpaceXService: SpaceXServiceProtocol {
    static let shared = SpaceXService()
    
    private let fetchCompanyPublisher: () -> AnyPublisher<Company, Error>
    private let fetchLaunchesPublisher: (Int, Int, LaunchQueryFilter) -> AnyPublisher<LaunchQueryResponse, Error>
    
    init(
        fetchCompanyPublisher: @escaping () -> AnyPublisher<Company, Error> = { NetworkingManager.fetch(Company.self, from: Constants.companyEndpoint) },
        fetchLaunchesPublisher: @escaping (Int, Int, LaunchQueryFilter) -> AnyPublisher<LaunchQueryResponse, Error> = { page, limit, query in
            let options = LaunchQueryOptions(limit: limit, page: page)
            let queryBody = LaunchQuery(query: query, options: options)
            return NetworkingManager.post(LaunchQueryResponse.self, body: queryBody, to: Constants.launchesQueryEndpoint)
        }
    ) {
        self.fetchCompanyPublisher = fetchCompanyPublisher
        self.fetchLaunchesPublisher = fetchLaunchesPublisher
    }
    
    func fetchCompany() -> AnyPublisher<Company, Error> {
        print("🚀 Fetching company data...")
        return fetchCompanyPublisher()
    }
    
    func fetchLaunchesPaginated(page: Int, limit: Int, query: LaunchQueryFilter = LaunchQueryFilter()) -> AnyPublisher<LaunchQueryResponse, Error> {
        print("🚀 Fetching launches data (page: \(page), limit: \(limit))...")
        return fetchLaunchesPublisher(page, limit, query)
    }
}
