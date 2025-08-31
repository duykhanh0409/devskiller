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
    func fetchLaunches() -> AnyPublisher<[Launch], Error>
    func fetchLaunchesPaginated(page: Int, limit: Int, query: [String: String]) -> AnyPublisher<LaunchQueryResponse, Error>
}

class SpaceXService: SpaceXServiceProtocol {
    static let shared = SpaceXService()
    
    private init() {}
    
    func fetchCompany() -> AnyPublisher<Company, Error> {
        print("🚀 Fetching company data...")
        return NetworkingManager.fetch(Company.self, from: Constants.companyEndpoint)
    }
    
    func fetchLaunches() -> AnyPublisher<[Launch], Error> {
        print("🚀 Fetching launches data...")
        return NetworkingManager.fetch([Launch].self, from: Constants.launchesEndpoint)
    }
    
    func fetchLaunchesPaginated(page: Int, limit: Int, query: [String: String] = [:]) -> AnyPublisher<LaunchQueryResponse, Error> {
        print("🚀 Fetching launches data (page: \(page), limit: \(limit))...")
        
        let options = LaunchQueryOptions(limit: limit, page: page)
        let queryBody = LaunchQuery(query: query, options: options)
        
        return NetworkingManager.post(LaunchQueryResponse.self, body: queryBody, to: Constants.launchesQueryEndpoint)
    }
}
