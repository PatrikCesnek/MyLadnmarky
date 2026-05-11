//
//  CLLocationCoordinate2D+extension.swift
//  Landmarky
//
//  Created by Patrik Cesnek on 08/03/2025.
//

import MapKit

extension CLLocationCoordinate2D {
    var isValid: Bool {
        CLLocationCoordinate2DIsValid(self)
    }
}
