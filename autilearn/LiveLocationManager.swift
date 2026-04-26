import Foundation
import Combine
import CoreLocation

// MARK: - Live Location Manager
// Separated into its own file to ensure Combine is cleanly imported
// for all @Published properties.

final class LiveLocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()

    @Published var coordinate: CLLocationCoordinate2D? = nil
    @Published var isTracking  = false
    @Published var authStatus: CLAuthorizationStatus = .notDetermined
    @Published var address     = ""

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    }

    func requestPermission() {
        manager.requestWhenInUseAuthorization()
    }

    func toggleTracking() {
        isTracking ? stopTracking() : startTracking()
    }

    func startTracking() {
        guard authStatus == .authorizedWhenInUse
           || authStatus == .authorizedAlways else {
            requestPermission(); return
        }
        isTracking = true
        manager.startUpdatingLocation()
    }

    func stopTracking() {
        isTracking = false
        manager.stopUpdatingLocation()
    }

    // MARK: CLLocationManagerDelegate

    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        guard let loc = locations.last else { return }
        DispatchQueue.main.async {
            self.coordinate = loc.coordinate
            self.reverseGeocode(loc)
        }
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        DispatchQueue.main.async {
            self.authStatus = manager.authorizationStatus
            if manager.authorizationStatus == .authorizedWhenInUse
            || manager.authorizationStatus == .authorizedAlways {
                if self.isTracking { manager.startUpdatingLocation() }
            }
        }
    }

    private func reverseGeocode(_ location: CLLocation) {
        CLGeocoder().reverseGeocodeLocation(location) { [weak self] placemarks, _ in
            guard let self, let p = placemarks?.first else { return }
            let parts = [p.locality, p.administrativeArea, p.country].compactMap { $0 }
            DispatchQueue.main.async { self.address = parts.joined(separator: ", ") }
        }
    }
}
