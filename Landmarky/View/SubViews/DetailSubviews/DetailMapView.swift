//
//  DetailMapView.swift
//  Landmarky
//
//  Created by Patrik Cesnek on 14/03/2025.
//

import MapKit
import SwiftUI

struct DetailMapView: View {
    private let latitude: Double
    private let longitude: Double
    private let name: String
    private let category: String?
    
    init(
        latitude: Double,
        longitude: Double,
        name: String,
        category: String?
    ) {
        self.latitude = latitude
        self.longitude = longitude
        self.name = name
        self.category = category
    }
    
    var body: some View {
        Map(
            initialPosition: MapCameraPosition.region(
                MKCoordinateRegion(
                    center: CLLocationCoordinate2D(
                        latitude: latitude,
                        longitude: longitude
                    ),
                    span: MKCoordinateSpan(
                        latitudeDelta: 0.01,
                        longitudeDelta: 0.01
                    )
                )
            )
        ) {
            LandmarkAnnotation(
                landmark: Landmark(
                    name: name,
                    category: category ?? LandmarkCategory.all.localizedName,
                    latitude: latitude,
                    longitude: longitude
                ),
                ontap: {}
            )
        }
    }
}

#Preview {
    DetailMapView(latitude: 50.0755, longitude: 14.4378, name: "Lorem", category: LandmarkCategory.lakes.localizedName)
}
