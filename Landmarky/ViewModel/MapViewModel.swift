//
//  MapViewModel.swift
//  Landmarky
//
//  Created by Patrik Cesnek on 08/02/2025.
//

import SwiftUI
import MapKit
import SwiftData

@MainActor
@Observable
class MapViewModel {
    var landmarks: [Landmark] = []
    var cameraPosition: MapCameraPosition = .automatic
    private let locationManager = CLLocationManager()
    var mapStyle: MapStyle = .imagery(elevation: .realistic)
    
    init() {
        requestLocation()
        displayLandmarks()
    }

    func updateUserLocation(_ location: CLLocationCoordinate2D?) {
        guard let location = location else {
            cameraPosition = .region(MKCoordinateRegion(
                center: Constants.DefaultLandmarkLocation.defaultLocation,
                latitudinalMeters: 1000,
                longitudinalMeters: 1000
            ))
            return
        }
        cameraPosition = .region(MKCoordinateRegion(
            center: location,
            latitudinalMeters: 1000,
            longitudinalMeters: 1000
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
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.activityType = .fitness
        
        if let userLocation = locationManager.location?.coordinate {
            updateUserLocation(userLocation)
        }
    }
    
    func changeMapStyle(_ style: MapStyle) -> MapStyle {
        mapStyle = style
        return mapStyle
    }
    
    func getLandmarkLocation() -> CLLocationCoordinate2D {
        guard let landmarkLocation = locationManager.location?.coordinate else {
            print("❌ User location unavailable")
            return CLLocationCoordinate2D(
                latitude: Constants.DefaultLandmarkLocation.defaultLat,
                longitude: Constants.DefaultLandmarkLocation.defaultLon
            )
        }
        return landmarkLocation
    }
    
    func displayLandmarks() {
        landmarks = Mock.MockLandmarks.data
    }
}
