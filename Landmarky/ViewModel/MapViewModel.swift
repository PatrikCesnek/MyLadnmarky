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
    var cameraPosition: MapCameraPosition = .automatic
    private let locationManager = CLLocationManager()
    
    init() {
        requestLocation()
    }

    func updateUserLocation(_ location: CLLocationCoordinate2D?) {
        guard let location = location else {
            cameraPosition = .region(MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: 50.0755, longitude: 14.4378), // Default to Prague
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            ))
            return
        }
        cameraPosition = .region(MKCoordinateRegion(
            center: location,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        ))
    }

    var validLandmarks: [Landmark] {
        landmarks.compactMap { landmark in
            guard let lat = landmark.latitude, let lon = landmark.longitude else { return nil }
            return CLLocationCoordinate2D(latitude: lat, longitude: lon).isValid ? landmark : nil
        }
    }

    func requestLocation() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        if let userLocation = locationManager.location?.coordinate {
            updateUserLocation(userLocation)
        }
    }
}

extension CLLocationCoordinate2D {
    var isValid: Bool {
        return CLLocationCoordinate2DIsValid(self) && latitude != 0.0 && longitude != 0.0
    }
}
