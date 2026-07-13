//
//  WeatherData.swift
//  WeatherApp
//
//  Created by Büşra Mangaoğlu on 13.07.2026.
//

import Foundation

enum WeatherData {
    static let hourlyWeatherList: [HourlyWeatherModel] = [
        HourlyWeatherModel(
            time: "Now",
            type: .sunny,
            temperature: 24,
            precipitation: 12
        ),
        HourlyWeatherModel(
            time: "1PM",
            type: .sunny,
            temperature: 25,
            precipitation: 14
        ),
        HourlyWeatherModel(
            time: "2PM",
            type: .sunny,
            temperature: 26,
            precipitation: 16
        ),
        HourlyWeatherModel(
            time: "3PM",
            type: .partlyCloudy,
            temperature: 26,
            precipitation: 18
        ),
        HourlyWeatherModel(
            time: "4PM",
            type: .partlyCloudy,
            temperature: 25,
            precipitation: 20
        ),
        HourlyWeatherModel(
            time: "5PM",
            type: .cloudy,
            temperature: 24,
            precipitation: 22
        ),
        HourlyWeatherModel(
            time: "6PM",
            type: .cloudy,
            temperature: 23,
            precipitation: 24
        ),
        HourlyWeatherModel(
            time: "7PM",
            type: .partlyCloudy,
            temperature: 22,
            precipitation: 26
        ),
        HourlyWeatherModel(
            time: "8PM",
            type: .moonStars,
            temperature: 21,
            precipitation: 28
        ),
        HourlyWeatherModel(
            time: "9PM",
            type: .moon,
            temperature: 20,
            precipitation: 30
        )
    ]
}
