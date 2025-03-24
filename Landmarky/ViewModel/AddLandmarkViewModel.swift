//
//  AddLandmarkViewModel.swift
//  Landmarky
//
//  Created by Patrik Cesnek on 24/03/2025.
//

import SwiftUI
import SwiftData

@Observable
class AddLandmarkViewModel {
    var landmarks: Landmark?
    var title: String = ""
    var category: String = ""
    var description: String = ""
    
    var latitude: Double = Constants.DefaultLandmarkLocation.defaultLat
    var longitude: Double = Constants.DefaultLandmarkLocation.defaultLon
    
    var latText: String = ""
    var lonText: String = ""
//
//    TODO: - Find a way to pass latitude and longitude from MapView
//    init(latitude: Double, longitude: Double) {
//        self.latitude = latitude
//        self.longitude = longitude
//    }
    
    @MainActor
    func addLandmark() {
        let newLandmark = Landmark(
            name: title,
            category: category,
            latitude: HelperFunctions.convertToDouble(latText),
            longitude: HelperFunctions.convertToDouble(lonText),
            landmarkDescription: description
        )
        
        print("Added New Landmark: \(newLandmark)")
        print(newLandmark.name)
    }
}
