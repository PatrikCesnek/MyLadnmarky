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
    private let onTap: () -> Void
    
    init(
        landmark: Landmark,
        ontap: @escaping () -> Void
    ) {
        self.landmark = landmark
        self.onTap = ontap
    }
    
    var body: some MapContent {
        Annotation(
            landmark.name,
            coordinate: CLLocationCoordinate2D(
                latitude: HelperFunctions.getCoordinate(.lat, landmark.latitude),
                longitude: HelperFunctions.getCoordinate(.lon, landmark.longitude)
            )
        ) {
            LandmarkAnnotationImage(categoryName: landmark.category)
                .shadow(radius: 5)
                .onTapGesture {
                    onTap()
                }
        }
    }
}
