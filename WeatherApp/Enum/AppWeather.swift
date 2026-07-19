//
//  AppWeather.swift
//  WeatherApp
//
//  Created by Büşra Mangaoğlu on 19.07.2026.
//

import Foundation
enum AppWeather {
    
    enum Weather {
        static let clearSky = "Clear Sky"
        static let mostlyClear = "Mostly Clear"
        static let partlyCloudy = "Partly Cloudy"
        static let overcast = "Overcast"
        static let foggy = "Foggy"
        static let drizzle = "Drizzle"
        static let rainy = "Rainy"
        static let snowy = "Snowy"
        static let rainShowers = "Rain Showers"
        static let snowShowers = "Snow Showers"
        static let thunderstorm = "Thunderstorm"
        static let unknown = "Unknown"
        static let sunny = "Sunny"
        static let moon = "Moon"
        static let moonstars = "Moonstars"
        static let clody = "Cloudy"
    }
    
    enum WeatherIcon {
        static let sunny = "sun.max.fill"
        static let partlyCloudy = "cloud.sun.fill"
        static let cloudy = "cloud.fill"
        static let foggy = "cloud.fog.fill"
        static let drizzle = "cloud.drizzle.fill"
        static let rainy = "cloud.rain.fill"
        static let heavyRain = "cloud.heavyrain.fill"
        static let snowy = "cloud.snow.fill"
        static let thunderstorm = "cloud.bolt.rain.fill"
        static let moon = "moon.fill"
        static let moonStars = "moon.stars.fill"
    }
    
}
