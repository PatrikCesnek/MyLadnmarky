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
class AddLandmarkViewModel: ObservableObject {
    var landmark: Landmark?
    var title: String = ""
    var categoryString: String = ""
    var description: String = ""
    
    var latitude: Double
    var longitude: Double
    
    var latText: String
    var lonText: String
    
    var selectedCategory: String = Constants.Categories.other
    var isCustomCategory: Bool {
        selectedCategory == Constants.Categories.custom
    }
    
    var category: String {
        selectedCategory == Constants.Categories.custom ? categoryString : selectedCategory
    }
    
    var isEdit: Bool {
        landmark != nil
    }
    
    var selectedImageData: Data?
    var showPhotoSourceSheet = false
    var showCamera = false
    var showPhotoPicker = false
    
    init(
        landmark: Landmark?,
        latitude: Double,
        longitude: Double
    ) {
        self.landmark = landmark
        self.latitude = latitude
        self.longitude = longitude
        self.latText = String(latitude)
        self.lonText = String(longitude)
        
        handleEdit(landmark: landmark)
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
    
    func handleEdit(landmark: Landmark?) {
        guard let landmark = landmark else { return }
        title = landmark.name
        selectedCategory = landmark.category
        description = landmark.landmarkDescription ?? ""
        selectedCategory = landmark.category
        selectedImageData = landmark.image
    }
    
    @MainActor
    func editLandmark(using context: ModelContext) {
        guard let landmark else { return }
        
        landmark.name = title
        landmark.category = category
        landmark.latitude = HelperFunctions.convertToDouble(latText)
        landmark.longitude = HelperFunctions.convertToDouble(lonText)
        landmark.image = selectedImageData
        landmark.landmarkDescription = description
                
        do {
            try context.save()
            //TODO: - show success alert
            print("Landmark saved successfully!")
        } catch {
            //TODO: - use proper error handling
            print("Failed to save landmark: \(error)")
        }
    }
    
    @MainActor
    func addLandmark(using context: ModelContext) {
        
        checkHasTitle()
        
        let newLandmark = Landmark(
            name: title,
            category: category,
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
    
    func deleteLandmark(using context: ModelContext, landmark: Landmark?) {
        HelperFunctions.deleteLandmark(using: context, landmark: landmark)
    }
    
    private func checkHasTitle() {
        if title.isEmpty {
            //TODO: - error handling empty title
            title = Constants.Strings.unknownPlace
        }
    }
}
