//
//  HourlyWeatherModel.swift
//  WeatherApp
//
//  Created by Büşra Mangaoğlu on 13.07.2026.
//

import Foundation

struct HourlyWeatherModel: Identifiable {
    let id = UUID()
    let time: String
    let type: WeatherType
    let temperature: Int
    let precipitation: Double?
}
