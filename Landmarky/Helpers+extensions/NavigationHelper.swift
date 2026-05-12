//
//  NavigationHelper.swift
//  Landmarky
//
//  Created by Patrik Cesnek on 04/04/2025.
//

import MapKit

struct NavigationHelper {
    static func startNavigation(to destination: CLLocationCoordinate2D, name: String) {
        let destinationItem = MKMapItem(
            location: CLLocation(
                latitude: destination.latitude,
                longitude: destination.longitude
            ),
            address: .none
        )
        destinationItem.name = name

        let launchOptions = [
            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving
        ]

        destinationItem.openInMaps(launchOptions: launchOptions)
    }
}
