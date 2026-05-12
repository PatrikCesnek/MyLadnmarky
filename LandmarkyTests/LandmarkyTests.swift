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
