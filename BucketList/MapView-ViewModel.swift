//
//  MapView-ViewModel.swift
//  BucketList
//
//  Created by Grace couch on 13/11/2024.
//
import CoreLocation
import LocalAuthentication
import MapKit
import SwiftUI


extension MapView {
    @Observable
    class ViewModel {
        private(set) var locations: [Location]
        var selectedPlace: Location?
        var isUnlocked = false
        var authenticationFailed = false

        let savePath = URL.documentsDirectory.appending(path: "SavedPlaces")

        init() {
            do {
                let data = try Data(contentsOf: savePath)

                locations = try JSONDecoder().decode([Location].self, from: data)
            } catch {
                locations = []
            }
        }

        func save() {
            do {
                let data = try JSONEncoder().encode(locations)
                try data.write(to: savePath, options: [.atomic, .completeFileProtection])
            } catch {
                print("Unable to save data.")
            }
        }

        func addNewLocation(at point: CLLocationCoordinate2D) {
            let location = Location(id: UUID(), name: "New Location", description: "", latitude: point.latitude, longitude: point.longitude)
            locations.append(location)
            save()
        }

        func updateLocation(location: Location) {
            guard let selectedPlace else { return }
            if let index = locations.firstIndex(of: selectedPlace) {
                locations[index] = location
                save()
            }
        }

        func authenticate() {
            let context = LAContext()
            var error: NSError?

            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                let reason = "Please autheticate yourself to unlock your places."

                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authError in
                    if success {
                        self.isUnlocked = true
                    } else {
                        self.authenticationFailed = true
                    }
                }
            } else {
                
            }
        }
    }
}
