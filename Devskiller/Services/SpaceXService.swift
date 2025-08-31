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
}
