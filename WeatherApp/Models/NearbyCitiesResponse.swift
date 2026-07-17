//
//  NearbyCitiesResponse.swift
//  WeatherApp
//
//  Created by Büşra Mangaoğlu on 17.07.2026.
//

import Foundation

struct NearbyCitiesResponse: Codable {
    let data: [NearbyCity]
    let metadata: NearbyCitiesMetadata
}

struct NearbyCity: Codable, Identifiable {
    let id: Int
    let wikiDataId: String?
    let type: String
    let city: String
    let name: String
    let country: String
    let countryCode: String
    let region: String
    let regionCode: String?
    let regionWdId: String?
    let latitude: Double
    let longitude: Double
    let population: Int?
    let distance: Double?
}

struct NearbyCitiesMetadata: Codable {
    let currentOffset: Int
    let totalCount: Int
}
