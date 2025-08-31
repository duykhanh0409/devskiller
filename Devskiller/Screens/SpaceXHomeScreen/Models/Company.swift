//
//  Company.swift
//  Devskiller
//
//  Created by Khanh Nguyen on 31/8/25.
//  Copyright © 2025 Mindera. All rights reserved.
//

import Foundation

struct Company: Codable, Identifiable {
    let id: String
    let name: String
    let founder: String
    let founded: Int
    let employees: Int
    let vehicles: Int
    let launchSites: Int
    let testSites: Int
    let ceo: String
    let cto: String
    let coo: String
    let ctoPropulsion: String
    let valuation: Int
    let headquarters: Headquarters
    let links: CompanyLinks
    let summary: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case founder
        case founded
        case employees
        case vehicles
        case launchSites = "launch_sites"
        case testSites = "test_sites"
        case ceo
        case cto
        case coo
        case ctoPropulsion = "cto_propulsion"
        case valuation
        case headquarters
        case links
        case summary
    }
}

struct Headquarters: Codable {
    let address: String
    let city: String
    let state: String
}

struct CompanyLinks: Codable {
    let website: String
    let flickr: String
    let twitter: String
    let elonTwitter: String
    
    enum CodingKeys: String, CodingKey {
        case website
        case flickr
        case twitter
        case elonTwitter = "elon_twitter"
    }
}
