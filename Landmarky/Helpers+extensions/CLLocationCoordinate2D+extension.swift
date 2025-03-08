//
//  CLLocationCoordinate2D+extension.swift
//  Landmarky
//
//  Created by Patrik Cesnek on 08/03/2025.
//

import MapKit

extension CLLocationCoordinate2D {
    var isValid: Bool {
        return CLLocationCoordinate2DIsValid(self) && latitude != 0.0 && longitude != 0.0
    }
}
