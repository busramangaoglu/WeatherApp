import Foundation

final class WeatherService {

    func fetchWeather(
        latitude: Double,
        longitude: Double
    ) async throws -> WeatherResponse {

        var components = URLComponents(
            string: "https://api.open-meteo.com/v1/forecast"
        )

        components?.queryItems = [
            URLQueryItem(
                name: "latitude",
                value: String(latitude)
            ),
            URLQueryItem(
                name: "longitude",
                value: String(longitude)
            ),
            URLQueryItem(
                name: "current",
                value: "temperature_2m,weather_code"
            ),
            URLQueryItem(
                name: "hourly",
                value: "temperature_2m,weather_code"
            ),
            URLQueryItem(
                name: "daily",
                value: "temperature_2m_max,temperature_2m_min"
            ),
            URLQueryItem(
                name: "timezone",
                value: "auto"
            )
        ]

        guard let url = components?.url else {
            throw NetworkError.invalidURL
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

        guard 200...299 ~= httpResponse.statusCode else {
            throw NetworkError.invalidStatusCode(
                httpResponse.statusCode
            )
        }

        do {
            return try JSONDecoder().decode(
                WeatherResponse.self,
                from: data
            )
        } catch {
            print("JSON decode hatası:", error)
            throw NetworkError.decodingError
        }
    }
}
