//
//  MapViewModel.swift
//  Landmarky
//
//  Created by Patrik Cesnek on 08/02/2025.
//

import SwiftUI
import MapKit
import SwiftData

@Observable
class MapViewModel {
    var landmarks: [Landmark] = []
    
    var userRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 50.0755, longitude: 14.4378), // Default to Prague
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )
    
    var userLocation: CLLocationCoordinate2D? {
        return userRegion.center
    }
    
    var validLandmarks: [Landmark] {
        return landmarks.compactMap { landmark in
            guard let lat = landmark.latitude, let lon = landmark.longitude else { return nil }
            return CLLocationCoordinate2D(latitude: lat, longitude: lon).isValid ? landmark : nil
        }
    }
    
    func updateUserLocation(_ location: CLLocationCoordinate2D) {
        userRegion.center = location
    }
}

extension CLLocationCoordinate2D {
    var isValid: Bool {
        return CLLocationCoordinate2DIsValid(self) && latitude != 0.0 && longitude != 0.0
    }
}
