import Foundation
import Combine

@MainActor
final class CitySearchViewModel: ObservableObject {

    @Published var cities: [NearbyCity] = []
    @Published var searchText: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private let cityService = CityService()

//    var filteredCities: [NearbyCity] {
//        if searchText.isEmpty {
//            return cities
//        }
//
//        return cities.filter { city in
//            city.city.localizedCaseInsensitiveContains(searchText) ||
//            city.country.localizedCaseInsensitiveContains(searchText)
//        }
//    }

    func fetchNearbyCities(
        latitude: Double,
        longitude: Double
    ) async {
        isLoading = true
        errorMessage = nil

        defer {
            isLoading = false
        }

        do {
            cities = try await cityService.fetchNearbyCities(
                latitude: latitude,
                longitude: longitude
            )
        } catch {
            errorMessage = error.localizedDescription
            print("Şehir API hatası:", error.localizedDescription)
        }
    }
    func searchCities(
            query: String
        ) async {
            let trimmedQuery = query.trimmingCharacters(
                in: .whitespacesAndNewlines
            )

            guard !trimmedQuery.isEmpty else {
                return
            }

            isLoading = true
            errorMessage = nil

            defer {
                isLoading = false
            }

            do {
                cities = try await cityService.searchCities(
                    namePrefix: trimmedQuery
                )
            } catch is CancellationError {
                return
            } catch let error as URLError
                where error.code == .cancelled {
                return
            } catch {
                errorMessage = error.localizedDescription

                print(
                    "Şehir arama hatası:",
                    error.localizedDescription
                )
            }
        }
    }
    

