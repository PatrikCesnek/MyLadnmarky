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
    
    var latitude: Double
    var longitude: Double
    
    var latText: String
    var lonText: String
    
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
        self.latText = String(latitude)
        self.lonText = String(longitude)
    }
    
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
    }
}
