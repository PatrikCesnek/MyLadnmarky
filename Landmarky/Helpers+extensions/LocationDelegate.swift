//
//  LocationDelegate.swift
//  Landmarky
//
//  Created by Patrik Cesnek on 26/03/2025.
//


import CoreLocation

extension CLLocationManager {
    static var liveLocationStream: AsyncStream<CLLocationCoordinate2D> {
        AsyncStream { continuation in
            let manager = CLLocationManager()
            manager.requestWhenInUseAuthorization()
            manager.startUpdatingLocation()
            
            let delegate = LocationDelegate { location in
                continuation.yield(location)
            }
            
            manager.delegate = delegate
            continuation.onTermination = { _ in manager.stopUpdatingLocation() }
        }
    }
}

private class LocationDelegate: NSObject, CLLocationManagerDelegate {
    let callback: (CLLocationCoordinate2D) -> Void
    
    init(callback: @escaping (CLLocationCoordinate2D) -> Void) {
        self.callback = callback
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last?.coordinate else { return }
        callback(location)
    }
}
