//
//  WeatherModel.swift
//  WeatherApp
//
//  Created by Büşra Mangaoğlu on 13.07.2026.
//

import Foundation

struct WeatherModel {
    let cityName: String
    let conditionType: WeatherType
    let temperature: Int
    let conditionText: String
    let highTemp: Int
    let lowTemp: Int
}

enum WeatherType {
    case sunny
    case partlyCloudy
    case cloudy
    case moon
    case moonStars

    var icon: String {
        switch self {
        case .sunny:
            return "sun.max.fill"
        case .partlyCloudy:
            return "cloud.sun.fill"
        case .cloudy:
            return "cloud.fill"
        case .moon:
            return "moon.fill"
        case .moonStars:
            return "moon.stars.fill"
        }
    }
}

