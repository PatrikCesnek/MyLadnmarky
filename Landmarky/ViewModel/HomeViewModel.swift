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
    private(set) var nextBadge: BadgeItem?

    /// The closing year, during December and January, if it has visited places.
    var featuredReviewYear: Int? {
        guard let year = YearInReview.featuredYear(today: Date()) else { return nil }
        let hasPlaces = landmarks.contains { landmark in
            landmark.visitDate.map { Calendar.current.component(.year, from: $0) == year } ?? false
        }
        return hasPlaces ? year : nil
    }

    var favoriteLandmarks: [Landmark] {
        landmarks.filter { $0.isFavorite }
    }
    var categories: [String] {
        let predefined = LandmarkCategory.allCases.map { $0.localizedName }
        let custom = Set(landmarks.map { $0.category }).subtracting(predefined)
        return predefined + custom.sorted()
    }

    @MainActor
    func fetchLandmarks(modelContext: ModelContext) {
        error = nil
        isLoading = true

        if Constants.showsMockData {
            landmarks = Mock.MockLandmarks.data
                .filter { !$0.isWishlisted }
                .sorted { $0.name < $1.name }
            nextBadge = Badge.nextUp(stats: BadgeStats(landmarks: landmarks, tripCount: Mock.MockTrips.data.count))
            isLoading = false
            return
        }

        let descriptor = FetchDescriptor<Landmark>(
            predicate: #Predicate { $0.isWishlisted == false },
            sortBy: [SortDescriptor(\.name)]
        )
        do {
            self.landmarks = try modelContext.fetch(descriptor)
            let tripCount = try modelContext.fetchCount(FetchDescriptor<Trip>())
            nextBadge = Badge.nextUp(stats: BadgeStats(landmarks: landmarks, tripCount: tripCount))
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
