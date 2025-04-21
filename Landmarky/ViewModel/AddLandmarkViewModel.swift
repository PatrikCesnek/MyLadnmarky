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
    var landmark: Landmark?
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
    
    init(
        landmark: Landmark? = nil,
        latitude: Double,
        longitude: Double
    ) {
        self.landmark = landmark
        self.latitude = latitude
        self.longitude = longitude
        self.latText = String(latitude)
        self.lonText = String(longitude)
    }
    
    @MainActor
    func addLandmark(using context: ModelContext) {
        if categoryString.isEmpty {
            categoryString = category
        }
//        let imageData = image?.jpegData(compressionQuality: 0.8)
        
        let newLandmark = Landmark(
            name: title,
            category: categoryString,
            latitude: HelperFunctions.convertToDouble(latText),
            longitude: HelperFunctions.convertToDouble(lonText),
            landmarkDescription: description
        )
        
        context.insert(newLandmark)
        
        do {
            try context.save()
            //TODO: - show success alert
            print("Landmark saved successfully!")
        } catch {
            //TODO: - use proper error handling
            print("Failed to save landmark: \(error)")
        }
    }
}
