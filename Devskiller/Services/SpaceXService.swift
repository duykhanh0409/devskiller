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
    func fetchLaunchesPaginated(page: Int, limit: Int, query: LaunchQueryFilter, options: LaunchQueryOptions?) -> AnyPublisher<LaunchQueryResponse, Error>
}

class SpaceXService: SpaceXServiceProtocol {
    static let shared = SpaceXService()
    
    private let fetchCompanyPublisher: () -> AnyPublisher<Company, Error>
    private let fetchLaunchesPublisher: (Int, Int, LaunchQueryFilter, LaunchQueryOptions?) -> AnyPublisher<LaunchQueryResponse, Error>
    
    init(
        fetchCompanyPublisher: @escaping () -> AnyPublisher<Company, Error> = { NetworkingManager.fetch(Company.self, from: Constants.companyEndpoint) },
        fetchLaunchesPublisher: @escaping (Int, Int, LaunchQueryFilter, LaunchQueryOptions?) -> AnyPublisher<LaunchQueryResponse, Error> = { page, limit, query, options in
            let finalOptions = options ?? LaunchQueryOptions(limit: limit, page: page)
            let queryBody = LaunchQuery(query: query, options: finalOptions)
            return NetworkingManager.post(LaunchQueryResponse.self, body: queryBody, to: Constants.launchesQueryEndpoint)
        }
    ) {
        self.fetchCompanyPublisher = fetchCompanyPublisher
        self.fetchLaunchesPublisher = fetchLaunchesPublisher
    }
    
    func fetchCompany() -> AnyPublisher<Company, Error> {
        return fetchCompanyPublisher()
    }
    
    func fetchLaunchesPaginated(page: Int, limit: Int, query: LaunchQueryFilter = LaunchQueryFilter(), options: LaunchQueryOptions? = nil) -> AnyPublisher<LaunchQueryResponse, Error> {
        return fetchLaunchesPublisher(page, limit, query, options)
    }
}
