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
    private(set) var landmarks: [Landmark] = []
    var categories: [LandmarkCategory] {
        LandmarkCategory.allCases
    }

    func fetchLandmarks(modelContext: ModelContext) {
        let descriptor = FetchDescriptor<Landmark>(sortBy: [SortDescriptor(\.name)])

        do {
            let allLandmarks = try modelContext.fetch(descriptor)
            DispatchQueue.main.async {
                //TODO: - uncomment following line
//                self.landmarks = allLandmarks
                //TODO: - delete the following line after we don't need it
                self.landmarks = Mock.MockLandmarks.data // Let's leave it here for now for tesing purposes
            }
        } catch {
            print("Error fetching landmarks: \(error.localizedDescription)")
        }
    }

    func landmarks(for category: LandmarkCategory) -> [Landmark] {
        let filteredLandmarks = landmarks.filter { landmark in
            (category == .custom || landmark.category == category.localizedName) &&
            (searchText.isEmpty || landmark.name.localizedCaseInsensitiveContains(searchText))
        }
        return filteredLandmarks
    }
}
