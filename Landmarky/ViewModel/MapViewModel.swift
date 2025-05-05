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
    var mapStyle: MapStyle = .imagery
    var selectedLandmark: Landmark?
    var isDeleted = false
    var error: String?
    
    init() {
        if locationManager.authorizationStatus == .authorizedWhenInUse || locationManager.authorizationStatus == .authorizedAlways {
            updateUserLocation(locationManager.location?.coordinate)
        } else {
            requestLocation()
        }
//        displayLandmarks()
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
            //TODO: - Use proper error handling
            print("❌ User location unavailable")
            return CLLocationCoordinate2D(
                latitude: Constants.DefaultLandmarkLocation.defaultLat,
                longitude: Constants.DefaultLandmarkLocation.defaultLon
            )
        }
        return landmarkLocation
    }
    
    @MainActor
    func displayLandmarks(modelContext: ModelContext) {
        let descriptor = FetchDescriptor<Landmark>(sortBy: [SortDescriptor(\.name)])
        error = nil
        do {
            let allLandmarks = try modelContext.fetch(descriptor)
            self.landmarks = allLandmarks
        } catch {
            //TODO: - Use proper error handling
            print("Error fetching landmarks: \(error.localizedDescription)")
            self.error = error.localizedDescription
        }
    }
}
