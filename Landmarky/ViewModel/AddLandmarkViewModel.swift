//
//  AddLandmarkViewModel.swift
//  Landmarky
//
//  Created by Patrik Cesnek on 24/03/2025.
//

import SwiftUI
import SwiftData
import PhotosUI

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
    
    var selectedImageData: Data?
    var showPhotoSourceSheet = false
    var showCamera = false
    var showPhotoPicker = false
    
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
    
    func handlePickedImage(_ image: UIImage?) {
        guard let image else { return }
        self.selectedImageData = image.jpegData(compressionQuality: 0.8)
    }
    
    @MainActor
    func loadPhoto(from item: PhotosPickerItem?) async {
        guard let item else { return }
        if let data = try? await item.loadTransferable(type: Data.self),
           let image = UIImage(data: data) {
            handlePickedImage(image)
        }
    }
    
    @MainActor
    func addLandmark(using context: ModelContext) {
        if categoryString.isEmpty {
            categoryString = category
        }
        
        let newLandmark = Landmark(
            name: title,
            category: categoryString,
            latitude: HelperFunctions.convertToDouble(latText),
            longitude: HelperFunctions.convertToDouble(lonText),
            image: selectedImageData,
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
