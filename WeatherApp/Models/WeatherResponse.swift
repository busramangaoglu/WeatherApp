//
//  WeatherResponse.swift
//  WeatherApp
//
//  Created by Büşra Mangaoğlu on 14.07.2026.
//
import Foundation

struct WeatherResponse: Decodable {
    let latitude: Double
    let longitude: Double
    let timezone: String
    let current: CurrentWeather
    let hourly: HourlyWeatherResponse
    let daily: DailyWeather
}

struct CurrentWeather: Decodable {
    let time: String
    let interval: Int
    let temperature: Double
    let weatherCode: Int

    enum CodingKeys: String, CodingKey {
        case time
        case interval
        case temperature = "temperature_2m"
        case weatherCode = "weather_code"
    }
}

struct DailyWeather: Decodable {
    let time: [String]
    let maximumTemperatures: [Double]
    let minimumTemperatures: [Double]

    enum CodingKeys: String, CodingKey {
        case time
        case maximumTemperatures = "temperature_2m_max"
        case minimumTemperatures = "temperature_2m_min"
    }
}

struct HourlyWeatherResponse: Decodable {
    let time: [String]
    let temperatures: [Double]
    let weatherCodes: [Int]

    enum CodingKeys: String, CodingKey {
        case time
        case temperatures = "temperature_2m"
        case weatherCodes = "weather_code"
    }
}
