//
//  LaunchQueryResponse.swift
//  Devskiller
//
//  Created by Khanh Nguyen on 31/8/25.
//  Copyright © 2025 Mindera. All rights reserved.
//

import Foundation

struct LaunchQueryResponse: Codable {
    let docs: [Launch]
    let totalDocs: Int
    let limit: Int
    let totalPages: Int
    let page: Int
    let pagingCounter: Int
    let hasPrevPage: Bool
    let hasNextPage: Bool
    let prevPage: Int?
    let nextPage: Int?
}

struct LaunchQuery: Codable {
    let query: [String: String]
    let options: LaunchQueryOptions
    
    init(query: [String: String] = [:], options: LaunchQueryOptions = LaunchQueryOptions()) {
        self.query = query
        self.options = options
    }
}

struct LaunchQueryOptions: Codable {
    let limit: Int
    let page: Int
    let sort: [String: String]
    
    init(limit: Int = 10, page: Int = 1, sort: [String: String] = ["date_utc": "desc"]) {
        self.limit = limit
        self.page = page
        self.sort = sort
    }
}
