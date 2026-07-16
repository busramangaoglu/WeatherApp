//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Büşra Mangaoğlu on 14.07.2026.
//

import Foundation
import Combine

@MainActor
final class WeatherViewModel: ObservableObject {

    @Published var weatherResponse: WeatherResponse?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var hourlyWeatherList: [HourlyWeatherModel] = []

    private let weatherService = WeatherService()

    func fetchWeather(
        latitude: Double,
        longitude: Double
    ) async {
        isLoading = true
        errorMessage = nil

        do {
            let response = try await weatherService.fetchWeather(
                latitude: latitude,
                longitude: longitude
            )

            weatherResponse = response
            hourlyWeatherList = createHourlyWeatherList(from: response)

        } catch {
            errorMessage = error.localizedDescription
            print("API hatası:", error)
        }

        isLoading = false
    }
}
private func createHourlyWeatherList(
    from response: WeatherResponse
) -> [HourlyWeatherModel] {

    let times = response.hourly.time
    let temperatures = response.hourly.temperatures
    let weatherCodes = response.hourly.weatherCodes

    guard
        times.count == temperatures.count,
        times.count == weatherCodes.count
    else {
        return []
    }

    let currentHour = Calendar.current.component(
        .hour,
        from: Date()
    )

    let endIndex = min(currentHour + Constants.minEndIndex, times.count)

    guard currentHour < endIndex else {
        return []
    }

    return (currentHour..<endIndex).map { index in
        HourlyWeatherModel(
            time: formatHour(
                times[index],
                isFirst: index == currentHour
            ),
            type: weatherType(
                from: weatherCodes[index]
            ),
            temperature: Int(
                temperatures[index].rounded()
            ),
            precipitation: nil
        )
    }
}

private func formatHour(
    _ dateString: String,
    isFirst: Bool
) -> String {

    if isFirst {
        return "Now"
    }

    let inputFormatter = DateFormatter()
    inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
    inputFormatter.locale = Locale(identifier: "en_US_POSIX")

    guard let date = inputFormatter.date(from: dateString) else {
        return dateString
    }

    let outputFormatter = DateFormatter()
    outputFormatter.dateFormat = "ha"
    outputFormatter.locale = Locale(identifier: "en_US")

    return outputFormatter.string(from: date)
}

private func weatherType(
    from code: Int
) -> WeatherType {

    switch code {
    case 0, 1:
        return .sunny

    case 2:
        return .partlyCloudy

    case 3, 45, 48:
        return .cloudy

    default:
        return .cloudy
    }
}

private enum Constants {
    static let minEndIndex = 10
}
