import Foundation
import CoreLocation
import Combine

final class LocationManager: NSObject, ObservableObject {

    @Published var location: CLLocation?
    @Published var authorizationStatus: CLAuthorizationStatus
    @Published var errorMessage: String?
    @Published var cityName: String = ""

    private let locationManager = CLLocationManager()

    override init() {
        authorizationStatus = locationManager.authorizationStatus

        super.init()

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
    }

    func requestLocation() {
        switch locationManager.authorizationStatus {

        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()

        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.requestLocation()

        case .denied, .restricted:
            errorMessage = "Konum izni verilmedi."

        @unknown default:
            errorMessage = "Bilinmeyen konum izni durumu."
        }
    }
}

extension LocationManager: CLLocationManagerDelegate {

    func locationManagerDidChangeAuthorization(
        _ manager: CLLocationManager
    ) {
        authorizationStatus = manager.authorizationStatus

        switch manager.authorizationStatus {

        case .authorizedWhenInUse, .authorizedAlways:
            manager.requestLocation()

        case .denied, .restricted:
            errorMessage = "Konum izni verilmedi."

        case .notDetermined:
            break

        @unknown default:
            errorMessage = "Bilinmeyen konum izni durumu."
        }
    }

    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {

        guard let location = locations.last else {
            return
        }

        self.location = location

        let geocoder = CLGeocoder()

        geocoder.reverseGeocodeLocation(location) { placemarks, error in

            if let error = error {
                print("Geocoder hatası:", error)
                return
            }

            guard let placemark = placemarks?.first else {
                return
            }

            self.cityName = placemark.locality ?? "Bilinmeyen Şehir"

            print("Şehir:", self.cityName)
        }
    }

    func locationManager(
        _ manager: CLLocationManager,
        didFailWithError error: Error
    ) {

        if let locationError = error as? CLError,
           locationError.code == .locationUnknown {
            return
        }

        errorMessage = error.localizedDescription
        print("Konum hatası:", error)
    }
}
