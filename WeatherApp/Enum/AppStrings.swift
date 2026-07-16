//
//  AppStrings.swift
//  WeatherApp
//
//  Created by Büşra Mangaoğlu on 13.07.2026.
//

import Foundation

enum AppStrings {

    enum City {
        static let name = "Kastamonu"
    }

    enum Forecast {
        static let hourly = "HOURLY FORECAST"
        static let details = "See details"
        static let condition = "Mostly Sunny"
        static let highPrefix = "H:"
        static let lowPrefix = "L:"
        
        static let currently = "CURRENTLY"
        static let currentCondition = "Mostly Clear"
        static let hourlyTitle = "Hourly Forecast"
    }
    
    enum Search {
        static let matchingCities = "MATCHING CITIES"
        static let searchCity = "Search City"
    }
    
    enum errorMessages {
        static let locationPermissionNotGranted = "Location permission not granted."
        static let unknownPermissionStatus = "Unknown location permission status."
        static let unknownCity = "Unknown city"
    }
    
}
