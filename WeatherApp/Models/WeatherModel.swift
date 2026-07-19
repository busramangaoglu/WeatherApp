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
            return AppWeather.WeatherIcon.sunny
        case .partlyCloudy:
            return AppWeather.WeatherIcon.partlyCloudy
        case .cloudy:
            return AppWeather.WeatherIcon.cloudy
        case .moon:
            return AppWeather.WeatherIcon.moon
        case .moonStars:
            return AppWeather.WeatherIcon.moonStars
        }
    }
    
    var name: String {
        switch self {
        case .sunny:
            return AppWeather.Weather.sunny
        case .partlyCloudy:
            return AppWeather.Weather.partlyCloudy
        case .cloudy:
            return AppWeather.Weather.clody
        case .moon:
            return AppWeather.Weather.moon
        case .moonStars:
            return AppWeather.Weather.moonstars
        }
    }
}
