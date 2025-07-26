//
//  HomeViewModel.swift
//  Landmarky
//
//  Created by Patrik Cesnek on 08/03/2025.
//


import SwiftData
import SwiftUI

@Observable
class HomeViewModel {
    var searchText: String = ""
    var isLoading: Bool = false
    var error: String?
    
    private(set) var landmarks: [Landmark] = []
    var categories: [String] {
        let predefined = LandmarkCategory.allCases.map { $0.localizedName }
        let custom = Set(landmarks.map { $0.category }).subtracting(predefined)
        return predefined + custom.sorted()
    }

    @MainActor
    func fetchLandmarks(modelContext: ModelContext) {
        let descriptor = FetchDescriptor<Landmark>(sortBy: [SortDescriptor(\.name)])
        error = nil
        isLoading = true
        do {
            let allLandmarks = try modelContext.fetch(descriptor)
            #warning("Use all landmarks instead of mock data")
            self.landmarks = Mock.MockLandmarks.data/*allLandmarks*/
            isLoading = false
        } catch {
            self.error = error.localizedDescription
            isLoading = false
        }
    }

    func landmarks(for category: LandmarkCategory) -> [Landmark] {
        let filteredLandmarks = landmarks.filter { landmark in
            (category == .custom || landmark.category == category.localizedName) &&
            (searchText.isEmpty || landmark.name.localizedCaseInsensitiveContains(searchText))
        }
        return filteredLandmarks
    }
    
    func filteredLandmarks() -> [Landmark] {
        landmarks.filter { landmark in
            searchText.isEmpty ||
            landmark.name.localizedCaseInsensitiveContains(searchText) ||
            landmark.category.localizedCaseInsensitiveContains(searchText)
        }
    }
}
