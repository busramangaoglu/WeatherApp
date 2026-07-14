//
//  CityModel.swift
//  WeatherApp
//
//  Created by Büşra Mangaoğlu on 14.07.2026.
//

import Foundation

struct CityModel: Identifiable {
    let id = UUID()
    let city: String
    let country: String
}
