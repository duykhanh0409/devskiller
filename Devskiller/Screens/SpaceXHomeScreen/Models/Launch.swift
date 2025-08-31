//
//  Launch.swift
//  Devskiller
//
//  Created by Khanh Nguyen on 31/8/25.
//  Copyright © 2025 Mindera. All rights reserved.
//

import Foundation

struct Launch: Codable, Identifiable {
    let id: String
    let flightNumber: Int
    let name: String
    let dateUtc: String
    let dateUnix: Int
    let dateLocal: String
    let datePrecision: String
    let staticFireDateUtc: String?
    let staticFireDateUnix: Int?
//    let tdb: Bool
    let net: Bool
    let window: Int?
    let rocket: String?
    let success: Bool?
    let failures: [Failure]?
    let upcoming: Bool
    let details: String?
    let fairings: Fairings?
    let crew: [Crew]?
    let ships: [String]?
    let capsules: [String]?
    let payloads: [String]?
    let launchpad: String?
    let cores: [Core]?
    let links: LaunchLinks?
    let autoUpdate: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case flightNumber = "flight_number"
        case name
        case dateUtc = "date_utc"
        case dateUnix = "date_unix"
        case dateLocal = "date_local"
        case datePrecision = "date_precision"
        case staticFireDateUtc = "static_fire_date_utc"
        case staticFireDateUnix = "static_fire_date_unix"
//        case tdb
        case net
        case window
        case rocket
        case success
        case failures
        case upcoming
        case details
        case fairings
        case crew
        case ships
        case capsules
        case payloads
        case launchpad
        case cores
        case links
        case autoUpdate = "auto_update"
    }
    
    // Computed properties for UI
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        if let date = formatter.date(from: dateUtc) {
            let displayFormatter = DateFormatter()
            displayFormatter.dateStyle = .medium
            displayFormatter.timeStyle = .short
            return displayFormatter.string(from: date)
        }
        return "Unknown date"
    }
    
    var daysFromNow: Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        if let launchDate = formatter.date(from: dateUtc) {
            let calendar = Calendar.current
            let now = Date()
            let components = calendar.dateComponents([.day], from: now, to: launchDate)
            return components.day ?? 0
        }
        return 0
    }
    
    var daysText: String {
        let days = daysFromNow
        if days > 0 {
            return "in \(days) days"
        } else if days < 0 {
            return "\(abs(days)) days ago"
        } else {
            return "today"
        }
    }
}

struct Fairings: Codable {
    let reused: Bool?
    let recoveryAttempt: Bool?
    let recovered: Bool?
    let ships: [String]?
    
    enum CodingKeys: String, CodingKey {
        case reused
        case recoveryAttempt = "recovery_attempt"
        case recovered
        case ships
    }
}

struct LaunchLinks: Codable {
    let patch: Patch?
    let reddit: Reddit?
    let flickr: Flickr?
    let presskit: String?
    let webcast: String?
    let youtubeId: String?
    let article: String?
    let wikipedia: String?
    
    enum CodingKeys: String, CodingKey {
        case patch
        case reddit
        case flickr
        case presskit
        case webcast
        case youtubeId = "youtube_id"
        case article
        case wikipedia
    }
}

struct Patch: Codable {
    let small: String?
    let large: String?
}

struct Reddit: Codable {
    let campaign: String?
    let launch: String?
    let media: String?
    let recovery: String?
}

struct Flickr: Codable {
    let small: [String]?
    let original: [String]?
}

struct Failure: Codable {
    let time: Int?
    let altitude: Int?
    let reason: String?
}

struct Core: Codable {
    let core: String?
    let flight: Int?
    let gridfins: Bool?
    let legs: Bool?
    let reused: Bool?
    let landingAttempt: Bool?
    let landingSuccess: Bool?
    let landingType: String?
    let landpad: String?
    
    enum CodingKeys: String, CodingKey {
        case core
        case flight
        case gridfins
        case legs
        case reused
        case landingAttempt = "landing_attempt"
        case landingSuccess = "landing_success"
        case landingType = "landing_type"
        case landpad
    }
}

struct Crew: Codable {
    let crew: String?
    let role: String?
    
    enum CodingKeys: String, CodingKey {
        case crew
        case role
    }
}
