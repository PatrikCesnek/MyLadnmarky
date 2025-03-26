//
//  LandmarkAnnotation.swift
//  Landmarky
//
//  Created by Patrik Cesnek on 26/03/2025.
//

import MapKit
import SwiftUI

struct LandmarkAnnotation: MapContent {
    private let landmark: Landmark
    
    init(landmark: Landmark) {
        self.landmark = landmark
    }
    
    var body: some MapContent {
        Annotation(
            landmark.name,
            coordinate: CLLocationCoordinate2D(
                latitude: landmark.latitude ?? Constants.DefaultLandmarkLocation.defaultLat,
                longitude: landmark.longitude ?? Constants.DefaultLandmarkLocation.defaultLon
            )
        ) {
            LandmarkAnnotationImage(categoryName: landmark.category)
                .shadow(radius: 5)
        }
    }
}
