//
//  NavigationHelper.swift
//  Landmarky
//
//  Created by Patrik Cesnek on 04/04/2025.
//

import MapKit

struct NavigationHelper {
    static func startNavigation(to destination: CLLocationCoordinate2D, name: String) {
        let destinationItem = mapItem(for: destination)
        destinationItem.name = name

        let launchOptions = [
            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving
        ]

        destinationItem.openInMaps(launchOptions: launchOptions)
    }

    private static func mapItem(for coordinate: CLLocationCoordinate2D) -> MKMapItem {
        if #available(iOS 26.0, *) {
            return MKMapItem(
                location: CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude),
                address: .none
            )
        } else {
            return MKMapItem(placemark: MKPlacemark(coordinate: coordinate))
        }
    }
}
