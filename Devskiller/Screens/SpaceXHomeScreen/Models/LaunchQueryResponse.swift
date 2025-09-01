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
    let query: LaunchQueryFilter
    let options: LaunchQueryOptions
    
    init(query: LaunchQueryFilter = LaunchQueryFilter(), options: LaunchQueryOptions = LaunchQueryOptions()) {
        self.query = query
        self.options = options
    }
}

struct LaunchQueryFilter: Codable {
    let dateUtc: DateRangeFilter?
    let success: Bool?
    
    enum CodingKeys: String, CodingKey {
        case dateUtc = "date_utc"
        case success
    }
    
    init(dateUtc: DateRangeFilter? = nil, success: Bool? = nil) {
        self.dateUtc = dateUtc
        self.success = success
    }
}

struct DateRangeFilter: Codable {
    let gte: String
    let lte: String
    
    enum CodingKeys: String, CodingKey {
        case gte = "$gte"
        case lte = "$lte"
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
