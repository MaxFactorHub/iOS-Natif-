//
//  Rapid.swift
//  iOS-Natif
//
//  Created by Earth on 22.02.2022.
//

import Foundation

struct Rapid {
    // MARK: - Welcome
    struct Welcome: Codable {
        let data: [Datum]?
        let links: [Link]?
        let metadata: Metadata?
    }

    // MARK: - Datum
    struct Datum: Codable {
        let id: Int
        let wikiDataID, name, country, countryCode: String
        let region, regionCode: String
        let latitude, longitude: Double
        let population: Int

        enum CodingKeys: String, CodingKey {
            case id
            case wikiDataID = "wikiDataId"
            case name, country, countryCode, region, regionCode, latitude, longitude, population
        }
    }

    // MARK: - Link
    struct Link: Codable {
        let rel, href: String
    }

    // MARK: - Metadata
    struct Metadata: Codable {
        let currentOffset, totalCount: Int
    }
}
