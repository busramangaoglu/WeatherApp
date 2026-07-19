import Foundation

final class CityService {

    // MARK: - Constants

    private let nearbyCitiesBaseURL =
        "https://geodb-free-service.wirefreethought.com/v1/geo/locations"

    private let citiesBaseURL =
        "https://geodb-free-service.wirefreethought.com/v1/geo/cities"

    private let radius = "100"
    private let distanceUnit = "KM"
    private let nearbyCitiesLimit = "5"
    private let cityType = "CITY"

    private let searchCitiesLimit = "10"
    private let populationSort = "-population"

    // MARK: - Fetch Nearby Cities

    func fetchNearbyCities(
        latitude: Double,
        longitude: Double
    ) async throws -> [NearbyCity] {

        let location =
            "\(signedValue(latitude))\(signedValue(longitude))"

        var components = URLComponents(
            string:
                "\(nearbyCitiesBaseURL)/\(location)/nearbyCities"
        )

        components?.queryItems = [
            URLQueryItem(
                name: "radius",
                value: radius
            ),
            URLQueryItem(
                name: "distanceUnit",
                value: distanceUnit
            ),
            URLQueryItem(
                name: "limit",
                value: nearbyCitiesLimit
            ),
            URLQueryItem(
                name: "types",
                value: cityType
            )
        ]

        guard let url = components?.url else {
            throw NetworkError.invalidURL
        }

        print("City API URL:", url.absoluteString)

        do {
            let (data, response) = try await URLSession.shared.data(
                from: url
            )

            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }

            guard 200...299 ~= httpResponse.statusCode else {
                throw NetworkError.invalidStatusCode(
                    httpResponse.statusCode
                )
            }

            let decodedResponse = try JSONDecoder().decode(
                NearbyCitiesResponse.self,
                from: data
            )

            return decodedResponse.data

        } catch let error as NetworkError {
            throw error
        } catch is DecodingError {
            throw NetworkError.decodingError
        } catch {
            throw NetworkError.requestFailed(error)
        }
    }

    // MARK: - Search Cities

    func searchCities(
        namePrefix: String
    ) async throws -> [NearbyCity] {

        var components = URLComponents(
            string: citiesBaseURL
        )

        components?.queryItems = [
            URLQueryItem(
                name: "namePrefix",
                value: namePrefix
            ),
            URLQueryItem(
                name: "limit",
                value: searchCitiesLimit
            ),
            URLQueryItem(
                name: "sort",
                value: populationSort
            )
        ]

        guard let url = components?.url else {
            throw NetworkError.invalidURL
        }

        print("Arama URL:", url.absoluteString)

        do {
            let (data, response) = try await URLSession.shared.data(
                from: url
            )

            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }

            guard 200...299 ~= httpResponse.statusCode else {
                throw NetworkError.invalidStatusCode(
                    httpResponse.statusCode
                )
            }

            let decodedResponse = try JSONDecoder().decode(
                NearbyCitiesResponse.self,
                from: data
            )

            return decodedResponse.data

        } catch let error as NetworkError {
            throw error
        } catch is DecodingError {
            throw NetworkError.decodingError
        } catch {
            throw NetworkError.requestFailed(error)
        }
    }

    // MARK: - Signed Coordinate

    private func signedValue(
        _ value: Double
    ) -> String {
        value >= 0 ? "+\(value)" : "\(value)"
    }
}
