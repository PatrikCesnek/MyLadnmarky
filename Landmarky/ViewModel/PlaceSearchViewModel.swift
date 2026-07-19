//
//  PlaceSearchViewModel.swift
//  Landmarky
//
//  Created by Patrik Cesnek on 19/07/2026.
//

import MapKit

struct PlaceSearchResult: Identifiable, Equatable, Sendable {
    let id = UUID()
    let name: String
    let detail: String
    let latitude: Double
    let longitude: Double
}

@MainActor
@Observable
class PlaceSearchViewModel {
    var query: String = ""
    private(set) var results: [PlaceSearchResult] = []
    private(set) var isSearching = false
    private(set) var hasSearched = false

    private var searchTask: Task<Void, Never>?
    private var suppressNextQueryChange = false

    private let centerLatitude: Double
    private let centerLongitude: Double

    init(
        centerLatitude: Double = Constants.DefaultLandmarkLocation.defaultLat,
        centerLongitude: Double = Constants.DefaultLandmarkLocation.defaultLon
    ) {
        self.centerLatitude = centerLatitude
        self.centerLongitude = centerLongitude
    }

    func queryChanged() {
        if suppressNextQueryChange {
            suppressNextQueryChange = false
            return
        }

        searchTask?.cancel()
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)

        guard trimmed.count >= 3 else {
            results = []
            isSearching = false
            hasSearched = false
            return
        }

        searchTask = Task { [weak self] in
            try? await Task.sleep(for: .milliseconds(400))
            guard !Task.isCancelled, let self else { return }
            await self.performSearch(for: trimmed)
        }
    }

    func select(_ result: PlaceSearchResult) {
        searchTask?.cancel()
        suppressNextQueryChange = true
        query = result.name
        results = []
        hasSearched = false
        isSearching = false
    }

    private func performSearch(for text: String) async {
        isSearching = true
        defer {
            isSearching = false
            hasSearched = true
        }

        do {
            results = try await Self.search(
                for: text,
                nearLatitude: centerLatitude,
                nearLongitude: centerLongitude
            )
        } catch {
            results = []
        }
    }

    nonisolated private static func search(
        for text: String,
        nearLatitude: Double,
        nearLongitude: Double
    ) async throws -> [PlaceSearchResult] {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = text
        request.region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: nearLatitude, longitude: nearLongitude),
            latitudinalMeters: 100_000,
            longitudinalMeters: 100_000
        )

        let response = try await MKLocalSearch(request: request).start()

        return response.mapItems.prefix(5).map { item in
            PlaceSearchResult(
                name: item.name ?? "",
                detail: item.address?.fullAddress ?? "",
                latitude: item.location.coordinate.latitude,
                longitude: item.location.coordinate.longitude
            )
        }
    }
}
