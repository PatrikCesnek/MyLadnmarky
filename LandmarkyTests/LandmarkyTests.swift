//
//  LandmarkyTests.swift
//  LandmarkyTests
//
//  Created by Patrik Cesnek on 03/02/2025.
//

import Testing
import SwiftData
@testable import Landmarky

struct LandmarkyTests {
    @Test func coordinateParsingAcceptsLocalizedDecimalSeparators() {
        #expect(HelperFunctions.parseCoordinate("48,1486", type: .lat) == 48.1486)
        #expect(HelperFunctions.parseCoordinate("17.1077", type: .lon) == 17.1077)
    }

    @Test func coordinateParsingRejectsInvalidValues() {
        #expect(HelperFunctions.parseCoordinate("91", type: .lat) == nil)
        #expect(HelperFunctions.parseCoordinate("-181", type: .lon) == nil)
        #expect(HelperFunctions.parseCoordinate("not a number", type: .lat) == nil)
    }

    @MainActor
    @Test func addLandmarkSavesWishlistStateWithoutVisitDate() throws {
        let context = try makeContext()
        let viewModel = AddLandmarkViewModel(
            landmark: nil,
            latitude: Constants.DefaultLandmarkLocation.defaultLat,
            longitude: Constants.DefaultLandmarkLocation.defaultLon
        )

        viewModel.title = "Devín Castle"
        viewModel.selectedCategory = Constants.Categories.castles
        viewModel.latText = "48.174"
        viewModel.lonText = "16.978"
        viewModel.isWishlisted = true
        viewModel.hasVisitDate = true

        viewModel.addLandmark(using: context)

        let landmarks = try context.fetch(FetchDescriptor<Landmark>())
        #expect(landmarks.count == 1)
        #expect(landmarks.first?.isWishlisted == true)
        #expect(landmarks.first?.visitDate == nil)
    }

    @MainActor
    @Test func wishlistToggleHiddenForVisitedLandmarksOnly() {
        let newLandmarkVM = AddLandmarkViewModel(landmark: nil, latitude: 48, longitude: 17)
        #expect(newLandmarkVM.showsWishlistToggle)

        let visited = Landmark(name: "Visited", category: "Parks", latitude: 48, longitude: 17)
        let visitedVM = AddLandmarkViewModel(landmark: visited, latitude: 48, longitude: 17)
        #expect(!visitedVM.showsWishlistToggle)

        let wishlisted = Landmark(name: "Wanted", category: "Parks", latitude: 48, longitude: 17, isWishlisted: true)
        let wishlistedVM = AddLandmarkViewModel(landmark: wishlisted, latitude: 48, longitude: 17)
        #expect(wishlistedVM.showsWishlistToggle)
    }

    @MainActor
    @Test func markVisitedClearsWishlistAndSetsVisitDate() throws {
        let context = try makeContext()
        let landmark = Landmark(
            name: "Sky Bridge",
            category: Constants.Categories.lookouts,
            latitude: 50.2,
            longitude: 16.8,
            isWishlisted: true
        )
        context.insert(landmark)
        try context.save()

        WishlistVisitService.markVisited(landmark, in: context)

        #expect(landmark.isWishlisted == false)
        #expect(landmark.visitDate != nil)
    }

    @Test func autoVisitSelectsOnlyNearbyWishlistedLandmarks() {
        let near = Landmark(name: "Near", category: "Parks", latitude: 48.1495, longitude: 17.1077, isWishlisted: true)
        let far = Landmark(name: "Far", category: "Parks", latitude: 48.25, longitude: 17.1077, isWishlisted: true)
        let nearButVisited = Landmark(name: "Visited", category: "Parks", latitude: 48.1495, longitude: 17.1077)
        let noCoordinates = Landmark(name: "Nowhere", category: "Parks", isWishlisted: true)

        let result = WishlistVisitService.landmarksToAutoVisit(
            currentLatitude: 48.1486,
            currentLongitude: 17.1077,
            wishlisted: [near, far, nearButVisited, noCoordinates],
            radiusMeters: 250
        )

        #expect(result.map(\.name) == ["Near"])
    }

    @MainActor
    @Test func placeSearchSelectionFillsQueryAndClearsResults() {
        let viewModel = PlaceSearchViewModel()
        let result = PlaceSearchResult(
            name: "Bratislava Castle",
            detail: "Bratislava, Slovakia",
            latitude: 48.142,
            longitude: 17.1
        )

        viewModel.select(result)

        #expect(viewModel.query == "Bratislava Castle")
        #expect(viewModel.results.isEmpty)
        #expect(!viewModel.isSearching)
    }

    @Test func parksAndHistoricalLandmarksAreFullyRegistered() {
        for category in [LandmarkCategory.parks, .historicalLandmarks] {
            #expect(LandmarkCategory.predefinedCategories.contains(category))
            #expect(LandmarkCategory(from: category.localizedName) == category)
            #expect(HelperFunctions.getCategoryString(category.localizedName) != Constants.SystemImages.mappin)
            #expect(HelperFunctions.changeAnnotationColor(categoryName: category.localizedName) != HelperFunctions.PlaceColors.neutral)
        }
    }

    @MainActor
    @Test func addLandmarkTrimsInputAndPersistsValidData() throws {
        let context = try makeContext()
        let viewModel = AddLandmarkViewModel(
            landmark: nil,
            latitude: Constants.DefaultLandmarkLocation.defaultLat,
            longitude: Constants.DefaultLandmarkLocation.defaultLon
        )

        viewModel.title = "  Bratislava Castle  "
        viewModel.description = "  Sunset view  "
        viewModel.selectedCategory = Constants.Categories.custom
        viewModel.categoryString = "  Weekend Trips  "
        viewModel.latText = "48.142"
        viewModel.lonText = "17.1"

        viewModel.addLandmark(using: context)

        let landmarks = try context.fetch(FetchDescriptor<Landmark>())
        #expect(landmarks.count == 1)
        #expect(landmarks.first?.name == "Bratislava Castle")
        #expect(landmarks.first?.category == "Weekend Trips")
        #expect(landmarks.first?.landmarkDescription == "Sunset view")
        #expect(landmarks.first?.latitude == 48.142)
        #expect(landmarks.first?.longitude == 17.1)
        #expect(viewModel.didSave)
        #expect(viewModel.error == nil)
    }

    @MainActor
    @Test func addLandmarkRejectsInvalidCoordinates() throws {
        let context = try makeContext()
        let viewModel = AddLandmarkViewModel(
            landmark: nil,
            latitude: Constants.DefaultLandmarkLocation.defaultLat,
            longitude: Constants.DefaultLandmarkLocation.defaultLon
        )

        viewModel.title = "Invalid place"
        viewModel.latText = "95"
        viewModel.lonText = "17"

        viewModel.addLandmark(using: context)

        #expect(try context.fetch(FetchDescriptor<Landmark>()).isEmpty)
        #expect(viewModel.error == Constants.Strings.invalidCoordinates)
        #expect(!viewModel.didSave)
    }

    @MainActor
    @Test func editLandmarkKeepsCustomCategoryEditable() throws {
        let landmark = Landmark(
            name: "Original",
            category: "Hidden Gems",
            latitude: 48,
            longitude: 17
        )

        let viewModel = AddLandmarkViewModel(
            landmark: landmark,
            latitude: 48,
            longitude: 17
        )

        #expect(viewModel.selectedCategory == Constants.Categories.custom)
        #expect(viewModel.categoryString == "Hidden Gems")
    }

    @MainActor
    @Test func profileValidationKeepsUserInEditMode() throws {
        let context = try makeContext()
        let viewModel = ProfileViewModel()

        viewModel.isEditing = true
        viewModel.firstName = "   "
        viewModel.editProfile(using: context)

        #expect(viewModel.isEditing)
        #expect(viewModel.alertText == Constants.Strings.enterName)
        #expect(try context.fetch(FetchDescriptor<Profile>()).isEmpty)
    }

    @MainActor
    private func makeContext() throws -> ModelContext {
        let schema = Schema([Landmark.self, Profile.self])
        let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: schema, configurations: [configuration])
        return ModelContext(container)
    }
}
