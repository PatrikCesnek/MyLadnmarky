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
    var categoryString: String = ""
    var description: String = ""
    
    var latitude: Double
    var longitude: Double
    
    var latText: String
    var lonText: String
    
    var category: String = Constants.Strings.other
    var isCustomCategory: Bool {
        category == Constants.Strings.custom
    }
    
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
        self.latText = String(latitude)
        self.lonText = String(longitude)
    }
    
    @MainActor
    func addLandmark() {
        if !categoryString.isEmpty {
            category = categoryString
        }
        
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
