//
//  LandmarksViewModel.swift
//  Landmarky
//
//  Created by Patrik Cesnek on 31/01/2025.
//

import SwiftData
import SwiftUI
import MapKit

@Observable
class LandmarksViewModel {
    var categorizedLandmarks: [LandmarkCategory: [Landmark]] = [:]
    
    func fetchLandmarks(modelContext: ModelContext) {
        let descriptor = FetchDescriptor<Landmark>(sortBy: [SortDescriptor(\.name)])

        do {
            let landmarks = try modelContext.fetch(descriptor)
            
            var groupedLandmarks: [LandmarkCategory: [Landmark]] = [:]
            
            for category in LandmarkCategory.predefinedCategories {
                let filteredLandmarks = landmarks.filter { $0.category == category.localizedName }
                if !filteredLandmarks.isEmpty {
                    groupedLandmarks[category] = filteredLandmarks
                }
            }
            
            DispatchQueue.main.async {
                self.categorizedLandmarks = groupedLandmarks
            }
        } catch {
            print("Error fetching landmarks: \(error.localizedDescription)")
        }
    }
    
    func addLandmark(name: String, category: LandmarkCategory, coordinate: CLLocationCoordinate2D, image: UIImage?, modelContext: ModelContext) {
        let imageData = image?.jpegData(compressionQuality: 0.8)
        
        let newLandmark = Landmark(
            name: name,
            category: category.localizedName,
            latitude: coordinate.latitude,
            longitude: coordinate.longitude,
            image: imageData
        )
        
        modelContext.insert(newLandmark)
    }
}
