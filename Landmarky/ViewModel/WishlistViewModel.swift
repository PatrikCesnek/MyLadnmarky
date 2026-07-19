//
//  WishlistViewModel.swift
//  Landmarky
//
//  Created by Patrik Cesnek on 19/07/2026.
//

import SwiftData
import SwiftUI

@Observable
class WishlistViewModel {
    private(set) var landmarks: [Landmark] = []
    var error: String?

    @MainActor
    func fetchWishlist(modelContext: ModelContext) {
        error = nil

        if Constants.showsMockData {
            landmarks = Mock.MockLandmarks.data
                .filter { $0.isWishlisted }
                .sorted { $0.name < $1.name }
            return
        }

        let descriptor = FetchDescriptor<Landmark>(
            predicate: #Predicate { $0.isWishlisted == true },
            sortBy: [SortDescriptor(\.name)]
        )
        do {
            landmarks = try modelContext.fetch(descriptor)
        } catch {
            self.error = error.localizedDescription
        }
    }

    @MainActor
    func markVisited(_ landmark: Landmark, using context: ModelContext) {
        WishlistVisitService.markVisited(landmark, in: context)
        landmarks.removeAll { $0.id == landmark.id }
    }
}
