//
//  NavigationHelper.swift
//  Landmarky
//
//  Created by Patrik Cesnek on 04/04/2025.
//

import MapKit

struct NavigationHelper {
    static func startNavigation(to destination: CLLocationCoordinate2D, name: String) {
        let destinationPlacemark = MKPlacemark(coordinate: destination)
        let destinationItem = MKMapItem(placemark: destinationPlacemark)
        destinationItem.name = name

        let launchOptions = [
            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving
        ]

        destinationItem.openInMaps(launchOptions: launchOptions)
    }
}
