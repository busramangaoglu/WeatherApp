import Foundation

final class CityService {

    func fetchNearbyCities(
        latitude: Double,
        longitude: Double
    ) async throws -> [NearbyCity] {

        let location = "\(signedValue(latitude))\(signedValue(longitude))"

        var components = URLComponents(
            string: "https://geodb-free-service.wirefreethought.com/v1/geo/locations/\(location)/nearbyCities"
        )

        components?.queryItems = [
            URLQueryItem(name: "radius", value: "100"),
            URLQueryItem(name: "distanceUnit", value: "KM"),
            URLQueryItem(name: "limit", value: "5"),
            URLQueryItem(name: "types", value: "CITY")
        ]

        guard let url = components?.url else {
            throw NetworkError.invalidURL
        }

        print("City API URL:", url.absoluteString)

        do {
            let (data, response) = try await URLSession.shared.data(from: url)

            guard let httpResponse = response as? HTTPURLResponse,
                  200...299 ~= httpResponse.statusCode else {
                throw NetworkError.invalidResponse
            }

            do {
                let response = try JSONDecoder().decode(
                    NearbyCitiesResponse.self,
                    from: data
                )

                return response.data
            } catch {
                print("Decode hatası:", error)
                throw NetworkError.decodingError
            }

        } catch let error as NetworkError {
            throw error
        } catch {
            throw NetworkError.requestFailed(error)
        }
    }
    
    func searchCities(
        namePrefix: String
    ) async throws -> [NearbyCity] {

        var components = URLComponents(
            string: "https://geodb-free-service.wirefreethought.com/v1/geo/cities"
        )

        components?.queryItems = [
            URLQueryItem(
                name: "namePrefix",
                value: namePrefix
            ),
            URLQueryItem(
                name: "limit",
                value: "10"
            ),
//            URLQueryItem(
//                   name: "types",
//                   value: "ADM2"
//               ),
            URLQueryItem(
                name: "sort",
                value: "-population"
            )
        ]

        guard let url = components?.url else {
            throw NetworkError.invalidURL
        }

        print("Arama URL:", url.absoluteString)

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

        do {
            let decodedResponse = try JSONDecoder().decode(
                NearbyCitiesResponse.self,
                from: data
            )

            return decodedResponse.data
        } catch {
            print("Şehir arama decode hatası:", error)
            throw NetworkError.decodingError
        }
    }

    private func signedValue(_ value: Double) -> String {
        value >= 0 ? "+\(value)" : "\(value)"
    }
}
