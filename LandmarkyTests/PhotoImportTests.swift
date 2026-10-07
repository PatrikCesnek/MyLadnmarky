//
//  PhotoImportTests.swift
//  LandmarkyTests
//
//  Created by Patrik Cesnek on 07/10/2026.
//

import Foundation
import MapKit
import SwiftData
import Synchronization
import Testing
import UIKit
@testable import Landmarky

struct PhotoPlaceClustererTests {
    private let day: TimeInterval = 86_400
    private let base = Date(timeIntervalSince1970: 1_780_000_000)

    @Test func photosWithinRadiusFormOnePlace() {
        let points = [
            PhotoPoint(id: "a", latitude: 48.1420, longitude: 17.1000, date: base),
            PhotoPoint(id: "b", latitude: 48.1425, longitude: 17.1005, date: base + 60),
            PhotoPoint(id: "c", latitude: 48.1430, longitude: 17.0995, date: base + 120)
        ]

        let clusters = PhotoPlaceClusterer.cluster(points, radiusMeters: 200)

        #expect(clusters.count == 1)
        #expect(clusters.first?.photoCount == 3)
        #expect(clusters.first?.representativePhotoID == "b")
        #expect(clusters.first?.firstDate == base)
        #expect(clusters.first?.lastDate == base + 120)
    }

    @Test func photosFarApartFormSeparatePlaces() {
        let points = [
            PhotoPoint(id: "bratislava", latitude: 48.142, longitude: 17.100, date: base),
            PhotoPoint(id: "devin", latitude: 48.174, longitude: 16.978, date: base),
            PhotoPoint(id: "vienna", latitude: 48.208, longitude: 16.373, date: base)
        ]

        #expect(PhotoPlaceClusterer.cluster(points).count == 3)
    }

    @Test func clusteringWorksAcrossGridCellBoundaries() {
        // ~100 m apart but straddling a cell edge.
        let cell = 200.0 / 111_320
        let edge = (48.0 / cell).rounded(.down) * cell + cell
        let points = [
            PhotoPoint(id: "south", latitude: edge - 0.0004, longitude: 17.1, date: base),
            PhotoPoint(id: "north", latitude: edge + 0.0004, longitude: 17.1, date: base)
        ]

        #expect(PhotoPlaceClusterer.cluster(points, radiusMeters: 200).count == 1)
    }

    @Test func clusteringWorksNearThePoles() {
        let points = [
            PhotoPoint(id: "a", latitude: 78.2232, longitude: 15.6267, date: base),
            PhotoPoint(id: "b", latitude: 78.2236, longitude: 15.6300, date: base)
        ]

        #expect(PhotoPlaceClusterer.cluster(points, radiusMeters: 200).count == 1)
    }

    @Test func invalidAndNullIslandLocationsAreIgnored() {
        let points = [
            PhotoPoint(id: "null-island", latitude: 0, longitude: 0, date: base),
            PhotoPoint(id: "broken", latitude: 123, longitude: 17, date: base),
            PhotoPoint(id: "ok", latitude: 48.1, longitude: 17.1, date: base)
        ]

        #expect(PhotoPlaceClusterer.cluster(points).map(\.representativePhotoID) == ["ok"])
    }

    @Test func suggestionsSkipSavedPlacesAndHome() {
        let saved = candidate(id: "saved", latitude: 48.142, longitude: 17.100, photos: 50, days: 3)
        let home = candidate(id: "home", latitude: 48.300, longitude: 17.300, photos: 900, days: 200)
        let trip = candidate(id: "trip", latitude: 45.000, longitude: 13.000, photos: 12, days: 2)
        let walk = candidate(id: "walk", latitude: 46.000, longitude: 14.000, photos: 30, days: 1)

        let result = PhotoPlaceClusterer.suggestions(
            from: [saved, home, trip, walk],
            existingCoordinates: [(48.1421, 17.1001)]
        )

        #expect(result.map(\.id) == ["walk", "trip"])
    }

    @Test func suggestionsAreCapped() {
        let many = (0..<100).map { candidate(id: "\($0)", latitude: 10 + Double($0), longitude: 10, photos: 1, days: 1) }

        #expect(PhotoPlaceClusterer.suggestions(from: many, existingCoordinates: []).count == PhotoPlaceClusterer.maxSuggestions)
    }

    @Test func largeLibraryClustersQuickly() {
        let points = (0..<30_000).map { index in
            PhotoPoint(
                id: "\(index)",
                latitude: 48 + Double(index % 300) * 0.01,
                longitude: 17 + Double(index / 300) * 0.01,
                date: base + Double(index)
            )
        }

        let start = Date()
        let clusters = PhotoPlaceClusterer.cluster(points)

        // Points are ~1 km apart, so every photo is its own place.
        #expect(clusters.count == 30_000)
        #expect(Date().timeIntervalSince(start) < 5)
    }

    private func candidate(id: String, latitude: Double, longitude: Double, photos: Int, days: Int) -> PhotoPlaceCandidate {
        PhotoPlaceCandidate(
            latitude: latitude,
            longitude: longitude,
            photoCount: photos,
            firstDate: base,
            lastDate: base + Double(days) * day,
            distinctDays: days,
            representativePhotoID: id
        )
    }
}

@MainActor
struct PhotoImportViewModelTests {
    private let date = Date(timeIntervalSince1970: 1_780_000_000)

    @Test func deniedAccessShowsDeniedStateAndScansNothing() async throws {
        let library = FakePhotoLibrary(access: .denied, points: [point("a", 48.1, 17.1)])
        let viewModel = PhotoImportViewModel(library: library, geocode: { _, _ in nil })

        await viewModel.scan(using: try TestSupport.makeContext())

        #expect(viewModel.phase == .denied)
        #expect(viewModel.suggestions.isEmpty)
        #expect(library.scanCount.withLock { $0 } == 0)
    }

    @Test func undecidedAccessIsRequestedBeforeScanning() async throws {
        let library = FakePhotoLibrary(access: .notDetermined, grantOnRequest: .limited, points: [point("a", 48.1, 17.1)])
        let viewModel = PhotoImportViewModel(library: library, geocode: { _, _ in nil })

        await viewModel.scan(using: try TestSupport.makeContext())

        #expect(viewModel.access == .limited)
        #expect(viewModel.phase == .ready)
        #expect(viewModel.suggestions.count == 1)
    }

    @Test func scanSuggestsNewPlacesWithGeocodedNames() async throws {
        let context = try TestSupport.makeContext()
        context.insert(Landmark(name: "Already saved", category: "Parks", latitude: 48.142, longitude: 17.100))
        try context.save()

        let library = FakePhotoLibrary(points: [
            point("saved-1", 48.1421, 17.1001),
            point("castle-1", 48.1740, 16.9780),
            point("castle-2", 48.1741, 16.9781)
        ])
        let viewModel = PhotoImportViewModel(library: library) { _, _ in
            GeocodedPlace(name: "Devín Castle", country: "Slovakia", countryCode: "SK", continent: "Europe")
        }

        await viewModel.scan(using: context)

        #expect(viewModel.phase == .ready)
        #expect(viewModel.suggestions.count == 1)
        #expect(viewModel.suggestions.first?.name == "Devín Castle")
        #expect(viewModel.suggestions.first?.candidate.photoCount == 2)
        #expect(viewModel.suggestions.first?.isResolvingName == false)
    }

    @Test func nothingIsSavedUntilTheUserConfirms() async throws {
        let context = try TestSupport.makeContext()
        let viewModel = PhotoImportViewModel(library: FakePhotoLibrary(points: [point("a", 48.1, 17.1)]), geocode: { _, _ in nil })

        await viewModel.scan(using: context)

        #expect(try context.fetchCount(FetchDescriptor<Landmark>()) == 0)
    }

    @Test func importSavesOnlySelectedPlacesWithTheirDetails() async throws {
        let context = try TestSupport.makeContext()
        let library = FakePhotoLibrary(points: [
            point("castle", 48.174, 16.978),
            point("lake", 48.326, 17.262),
            point("lake-2", 48.3261, 17.2621)
        ])
        let viewModel = PhotoImportViewModel(library: library) { latitude, _ in
            latitude > 48.3
                ? GeocodedPlace(name: "Kučišdorf Lake", country: "Slovakia", countryCode: "SK", continent: "Europe")
                : GeocodedPlace(name: "Devín Castle", country: "Slovakia", countryCode: "SK", continent: "Europe")
        }
        await viewModel.scan(using: context)

        let lakeIndex = try #require(viewModel.suggestions.firstIndex { $0.name == "Kučišdorf Lake" })
        let castleIndex = try #require(viewModel.suggestions.firstIndex { $0.name == "Devín Castle" })
        viewModel.suggestions[lakeIndex].category = Constants.Categories.lakes
        viewModel.suggestions[lakeIndex].name = "  Our lake  "
        viewModel.suggestions[castleIndex].isSelected = false

        await viewModel.importSelected(using: context)

        #expect(viewModel.phase == .finished(added: 1))
        let saved = try context.fetch(FetchDescriptor<Landmark>())
        #expect(saved.count == 1)
        let lake = try #require(saved.first)
        #expect(lake.name == "Our lake")
        #expect(lake.category == Constants.Categories.lakes)
        #expect(lake.countryCode == "SK")
        #expect(lake.continent == "Europe")
        #expect(lake.visitDate == date)
        #expect(lake.isWishlisted == false)
        #expect(lake.image == FakePhotoLibrary.jpeg)
        #expect(abs((lake.latitude ?? 0) - 48.32605) < 0.001)
    }

    @Test func userEditedNameIsNotOverwrittenByGeocoding() async throws {
        let library = FakePhotoLibrary(points: [point("a", 48.1, 17.1)])
        let viewModel = PhotoImportViewModel(library: library) { _, _ in
            GeocodedPlace(name: "Geocoded", country: "Slovakia", countryCode: "SK", continent: "Europe")
        }
        await viewModel.scan(using: try TestSupport.makeContext())
        #expect(viewModel.suggestions.first?.name == "Geocoded")

        viewModel.suggestions[0].name = "Mine"

        #expect(viewModel.suggestions.first?.name == "Mine")
    }

    @Test func rescanAfterImportSuggestsNothingNew() async throws {
        let context = try TestSupport.makeContext()
        let library = FakePhotoLibrary(points: [point("a", 48.1, 17.1)])
        let first = PhotoImportViewModel(library: library, geocode: { _, _ in nil })
        await first.scan(using: context)
        await first.importSelected(using: context)

        let second = PhotoImportViewModel(library: library, geocode: { _, _ in nil })
        await second.scan(using: context)

        #expect(second.phase == .ready)
        #expect(second.suggestions.isEmpty)
        #expect(try context.fetchCount(FetchDescriptor<Landmark>()) == 1)
    }

    @Test func geocodedPointOfInterestSuggestsCategoryUnlessUserPickedOne() async throws {
        let library = FakePhotoLibrary(points: [point("castle", 48.174, 16.978)])
        let viewModel = PhotoImportViewModel(library: library) { _, _ in
            GeocodedPlace(name: "Devín Castle", country: "Slovakia", countryCode: "SK", continent: "Europe", category: .castles)
        }

        await viewModel.scan(using: try TestSupport.makeContext())

        #expect(viewModel.suggestions.first?.category == Constants.Categories.castles)
    }

    @Test(arguments: [
        (MKPointOfInterestCategory.castle, LandmarkCategory.castles),
        (.park, .parks),
        (.beach, .lakes),
        (.restaurant, .restaurants),
        (.nightlife, .bars),
        (.amusementPark, .entertainment),
        (.museum, .historicalLandmarks)
    ])
    func pointOfInterestKindsMapToCategories(kind: MKPointOfInterestCategory, expected: LandmarkCategory) {
        #expect(LandmarkCategory(pointOfInterest: kind) == expected)
    }

    @Test func unrelatedPointOfInterestHasNoCategory() {
        #expect(LandmarkCategory(pointOfInterest: .gasStation) == nil)
    }

    @Test func importWithNothingSelectedDoesNothing() async throws {
        let context = try TestSupport.makeContext()
        let viewModel = PhotoImportViewModel(library: FakePhotoLibrary(points: [point("a", 48.1, 17.1)]), geocode: { _, _ in nil })
        await viewModel.scan(using: context)
        viewModel.setAllSelected(false)

        await viewModel.importSelected(using: context)

        #expect(viewModel.phase == .ready)
        #expect(try context.fetchCount(FetchDescriptor<Landmark>()) == 0)
    }

    private func point(_ id: String, _ latitude: Double, _ longitude: Double) -> PhotoPoint {
        PhotoPoint(id: id, latitude: latitude, longitude: longitude, date: date)
    }
}

private final class FakePhotoLibrary: PhotoLibraryProviding {
    static let jpeg = Data([0xFF, 0xD8, 0xFF, 0xD9])

    let access: Mutex<PhotoLibraryAccess>
    let grantOnRequest: PhotoLibraryAccess
    let points: [PhotoPoint]
    let scanCount = Mutex(0)

    init(access: PhotoLibraryAccess = .full, grantOnRequest: PhotoLibraryAccess = .full, points: [PhotoPoint]) {
        self.access = Mutex(access)
        self.grantOnRequest = grantOnRequest
        self.points = points
    }

    func currentAccess() -> PhotoLibraryAccess {
        access.withLock { $0 }
    }

    func requestAccess() async -> PhotoLibraryAccess {
        access.withLock { $0 = grantOnRequest }
        return grantOnRequest
    }

    func geotaggedPhotos() async -> [PhotoPoint] {
        scanCount.withLock { $0 += 1 }
        return points
    }

    func thumbnail(for photoID: String, pixelSide: CGFloat) async -> UIImage? {
        nil
    }

    func importableJPEG(for photoID: String) async -> Data? {
        Self.jpeg
    }
}
