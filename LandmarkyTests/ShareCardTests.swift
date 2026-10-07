//
//  ShareCardTests.swift
//  LandmarkyTests
//
//  Created by Patrik Cesnek on 07/10/2026.
//

import Foundation
import ImageIO
import SwiftUI
import Testing
import UIKit
import UniformTypeIdentifiers
@testable import Landmarky

@MainActor
struct ShareCardTests {
    @Test func landmarkCardRendersAtShareSize() throws {
        let landmark = Landmark(name: "Devín Castle", category: Constants.Categories.castles, visitDate: .now, countryCode: "SK")

        let result = try #require(ShareCardRenderer.render(LandmarkShareCard(landmark: landmark), fileName: "test"))

        #expect(result.image.size.width * result.image.scale == 1080)
        #expect(result.image.size.height * result.image.scale == 1350)
        #expect(result.card.fileName == "test.jpg")
        #expect(!result.card.jpegData.isEmpty)
    }

    @Test func everyCardTypeRenders() throws {
        let trip = Trip(title: "Vienna", startDate: .now)
        let map = try #require(WorldMap.bundled)
        let summary = VisitedCountriesSummary(landmarks: [
            Landmark(name: "Devín", category: "Castles", countryCode: "SK")
        ])

        #expect(ShareCardRenderer.render(BadgeShareCard(badge: .legend), fileName: "badge") != nil)
        #expect(ShareCardRenderer.render(TripShareCard(trip: trip), fileName: "trip") != nil)
        #expect(ShareCardRenderer.render(WorldShareCard(map: map, summary: summary), fileName: "world") != nil)
    }

    @Test func sharedImageCarriesNoLocationMetadataFromThePhoto() throws {
        let photo = try makeJPEGWithGPS(latitude: 48.174, longitude: 16.978)
        #expect(gpsMetadata(in: photo) != nil, "Fixture must contain GPS to make this test meaningful")

        let landmark = Landmark(name: "Secret spot", category: "Lakes", latitude: 48.174, longitude: 16.978, image: photo)
        let result = try #require(ShareCardRenderer.render(LandmarkShareCard(landmark: landmark), fileName: "secret"))

        #expect(gpsMetadata(in: result.card.jpegData) == nil)
    }

    @Test func tripCardShowsEachCountryOnce() {
        let trip = Trip(title: "Danube", startDate: .now)
        trip.landmarks = [
            Landmark(name: "Bratislava", category: "Parks", countryCode: "SK"),
            Landmark(name: "Devín", category: "Castles", countryCode: "SK"),
            Landmark(name: "Vienna", category: "Parks", countryCode: "AT")
        ]

        let card = TripShareCard(trip: trip)

        #expect(card.placeCount == 3)
        #expect(Set(card.countryCodes) == ["SK", "AT"])
        #expect(card.countryCodes.count == 2)
    }

    @Test(arguments: [
        ("Devín Castle!", "Worldwanderer-Devin-Castle"),
        ("Jet Setter", "Worldwanderer-Jet-Setter"),
        ("???", "Worldwanderer")
    ])
    func shareFileNamesAreSafe(title: String, expected: String) {
        #expect(ShareCardRenderer.fileName(for: title) == expected)
    }

    // MARK: - Helpers

    private func makeJPEGWithGPS(latitude: Double, longitude: Double) throws -> Data {
        let image = UIGraphicsImageRenderer(size: CGSize(width: 40, height: 40)).image { context in
            UIColor.systemTeal.setFill()
            context.fill(CGRect(x: 0, y: 0, width: 40, height: 40))
        }
        let cgImage = try #require(image.cgImage)
        let data = NSMutableData()
        let destination = try #require(CGImageDestinationCreateWithData(data, UTType.jpeg.identifier as CFString, 1, nil))
        let gps: [CFString: Any] = [
            kCGImagePropertyGPSLatitude: latitude,
            kCGImagePropertyGPSLatitudeRef: "N",
            kCGImagePropertyGPSLongitude: longitude,
            kCGImagePropertyGPSLongitudeRef: "E"
        ]
        CGImageDestinationAddImage(destination, cgImage, [kCGImagePropertyGPSDictionary: gps] as CFDictionary)
        #expect(CGImageDestinationFinalize(destination))
        return data as Data
    }

    private func gpsMetadata(in data: Data) -> Any? {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil),
              let properties = CGImageSourceCopyPropertiesAtIndex(source, 0, nil) as? [CFString: Any] else {
            return nil
        }
        return properties[kCGImagePropertyGPSDictionary]
    }
}
