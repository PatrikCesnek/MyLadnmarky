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

    var selectedCategory: String = Constants.Categories.other
    var isCustomCategory: Bool {
        selectedCategory == Constants.Categories.custom
    }

    var category: String {
        selectedCategory == Constants.Categories.custom
        ? categoryString.trimmingCharacters(in: .whitespacesAndNewlines)
        : selectedCategory
    }

    var isEdit: Bool {
        landmark != nil
    }

    var selectedImageData: Data?
    var showPhotoSourceSheet = false
    var showCamera = false
    var showPhotoPicker = false
    var error: String?
    var alertText: String?
    var didSave = false
    var visitDate: Date = Date()
    var hasVisitDate: Bool = false
    var isWishlisted: Bool = false
    private(set) var showsWishlistToggle = true

    private var validatedCoordinates: (latitude: Double, longitude: Double)? {
        guard let latitude = HelperFunctions.parseCoordinate(latText, type: .lat),
              let longitude = HelperFunctions.parseCoordinate(lonText, type: .lon) else {
            error = Constants.Strings.invalidCoordinates
            return nil
        }

        return (latitude, longitude)
    }

    private var hasValidCategory: Bool {
        if selectedCategory == Constants.Categories.custom && category.isEmpty {
            alertText = Constants.Strings.invalidCustomCategory
            return false
        }

        return true
    }

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
        guard let landmark else { return }
        title = landmark.name
        if LandmarkCategory.predefinedCategories.map(\.localizedName).contains(landmark.category) {
            selectedCategory = landmark.category
        } else {
            selectedCategory = Constants.Categories.custom
            categoryString = landmark.category
        }
        description = landmark.landmarkDescription ?? ""
        selectedImageData = landmark.image
        isWishlisted = landmark.isWishlisted
        showsWishlistToggle = landmark.isWishlisted
        if let date = landmark.visitDate {
            visitDate = date
            hasVisitDate = true
        }
    }

    @MainActor
    func editLandmark(using context: ModelContext) {
        guard let landmark else { return }
        error = nil
        alertText = nil
        guard hasValidCategory, let coordinates = validatedCoordinates else { return }
        title = title.trimmingCharacters(in: .whitespacesAndNewlines)
        description = description.trimmingCharacters(in: .whitespacesAndNewlines)

        landmark.name = title.isEmpty ? Constants.Strings.unknownPlace : title
        landmark.category = category
        landmark.latitude = coordinates.latitude
        landmark.longitude = coordinates.longitude
        landmark.image = selectedImageData
        landmark.landmarkDescription = description
        landmark.isWishlisted = isWishlisted
        landmark.visitDate = (hasVisitDate && !isWishlisted) ? visitDate : nil

        do {
            try context.save()
            didSave = true
        } catch {
            self.error = error.localizedDescription
        }

        geocodeLandmark(landmark, latitude: coordinates.latitude, longitude: coordinates.longitude, context: context)
    }

    @MainActor
    func addLandmark(using context: ModelContext) {
        error = nil
        alertText = nil
        guard hasValidCategory, let coordinates = validatedCoordinates else { return }

        title = title.trimmingCharacters(in: .whitespacesAndNewlines)
        description = description.trimmingCharacters(in: .whitespacesAndNewlines)

        if title.isEmpty {
            title = Constants.Strings.unknownPlace
        }

        let newLandmark = Landmark(
            name: title,
            category: category,
            latitude: coordinates.latitude,
            longitude: coordinates.longitude,
            image: selectedImageData,
            landmarkDescription: description,
            isWishlisted: isWishlisted,
            visitDate: (hasVisitDate && !isWishlisted) ? visitDate : nil
        )

        context.insert(newLandmark)

        do {
            try context.save()
            didSave = true
        } catch {
            self.error = error.localizedDescription
        }

        geocodeLandmark(newLandmark, latitude: coordinates.latitude, longitude: coordinates.longitude, context: context)
    }

    private func geocodeLandmark(_ landmark: Landmark, latitude: Double, longitude: Double, context: ModelContext) {
        Task { @MainActor in
            if let result = await GeocodingHelper.reverseGeocode(latitude: latitude, longitude: longitude) {
                landmark.country = result.country
                landmark.continent = result.continent
                try? context.save()
            }
        }
    }

    func deleteLandmark(using context: ModelContext, landmark: Landmark?) {
        error = nil

        do {
            try HelperFunctions.deleteLandmark(using: context, landmark: landmark)
            didSave = true
        } catch {
            self.error = error.localizedDescription
        }
    }
}
