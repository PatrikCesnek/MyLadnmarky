//
//  Mock.swift
//  Landmarky
//
//  Created by Patrik Cesnek on 09/03/2025.
//

import Foundation
import SwiftUI

struct Mock {
    struct MockLandmarks {
        static let data: [Landmark] = [
            Landmark(name: "Crystal Lake", category: LandmarkCategory.lakes.localizedName, latitude: 49.2, longitude: 16.6, landmarkDescription: mockDescription),
            Landmark(name: "Eagle Peak", category: LandmarkCategory.hills.localizedName, latitude: 50.1, longitude: 14.4),
            Landmark(name: "King's Castle", category: LandmarkCategory.castles.localizedName, latitude: 48.7, longitude: 17.2, landmarkDescription: mockDescription),
            Landmark(name: "Sky Tower", category: LandmarkCategory.lookouts.localizedName, latitude: 49.5, longitude: 15.9),
            Landmark(name: "Gourmet Bistro", category: LandmarkCategory.restaurants.localizedName, latitude: 50.3, longitude: 14.2),
            Landmark(name: "Sunset Bar", category: LandmarkCategory.bars.localizedName, latitude: 49.8, longitude: 15.0, landmarkDescription: mockDescription),
            Landmark(name: "Central Mall", category: LandmarkCategory.shops.localizedName, latitude: 48.9, longitude: 16.5),
            Landmark(name: "Dreamland Park", category: LandmarkCategory.entertainment.localizedName, latitude: 50.0, longitude: 17.1),
            Landmark(name: "Mystic Point", category: LandmarkCategory.custom.localizedName, latitude: 49.6, longitude: 15.7),
            Landmark(name: "Hidden Gem", category: LandmarkCategory.other.localizedName, latitude: 48.5, longitude: 16.3, landmarkDescription: mockDescription),
            Landmark(name: "Veľká Homola", category: LandmarkCategory.lookouts.localizedName, latitude: 48.3446, longitude: 17.2495),
            Landmark(
                name: "Kučišdorfská priehrada",
                category: LandmarkCategory.lakes.localizedName,
                latitude: 48.326527,
                longitude: 17.262833,
                landmarkDescription: mockDescription
            )
        ]
        
        static let mockImage = Image(systemName: Constants.SystemImages.emptyPhoto)
        
        static let mockDescription = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
        
        static let mockCategories = [
            LandmarkCategory.all.localizedName,
            LandmarkCategory.castles.localizedName,
            LandmarkCategory.lookouts.localizedName,
            LandmarkCategory.lakes.localizedName
        ]
        
        static let mockError = "Lorem ipsum dolor sit amet, consectetur adipiscing elit"
    }
}
