//
//  Constants.swift
//  Landmarky
//
//  Created by Patrik Cesnek on 31/01/2025.
//

import Foundation

public struct Constants {
    struct Strings {
        static let home = "Home".localizedCapitalized
        static let map = "Map".localizedCapitalized
        static let profile = "Profile".localizedCapitalized
        static let search = "Search".localizedCapitalized
        static let homeTitle = "My landmarks".localizedCapitalized
        static let achievementsTitle = "Achievements".localizedCapitalized
        static let noLandmarks = "So far you have no saved landmarks".localizedCapitalized
        static let noAchievements = "So far you don't have any achievements".localizedCapitalized
        static let lakes = "Lakes".localizedCapitalized
        static let hills = "Hills".localizedCapitalized
        static let castles = "Castles".localizedCapitalized
        static let lookouts = "Lookouts".localizedCapitalized
        static let restaurants = "Restaurants".localizedCapitalized
        static let bars = "Bars".localizedCapitalized
        static let shops = "Shops".localizedCapitalized
        static let entertainment = "Entertainment".localizedCapitalized
        static let custom = "Custom".localizedCapitalized
        static let other = "Other".localizedCapitalized
        static let landmarkCountString1 = "You have:".localizedCapitalized
        static let landmarkCountString2 = "landmarks".localizedCapitalized
        static let allLandmarks = "All".localizedCapitalized
        static let edit = "Edit".localizedCapitalized
        static let navigate = "Navigate".localizedCapitalized
        static let title = "Title".localizedCapitalized
        static let description = "Description".localizedCapitalized
        static let location = "Location".localizedCapitalized
        static let latitude = "Latitude".localizedCapitalized
        static let longitude = "Longitude".localizedCapitalized
        static let save = "Save".localizedCapitalized
        static let addLandmarkTitle = "Add landmark".localizedCapitalized
        static let category = "Category".localizedCapitalized
        static let customCategory = custom + " " + category.lowercased()
    }
    
    struct SystemImages {
        static let plus = "plus"
        static let house = "house"
        static let map = "map"
        static let person = "person"
        static let mappin = "mappin.circle.fill"
        static let backButton = "chevron.left"
        static let emptyPhoto = "photo.circle.fill"
    }
    
    struct DefaultLandmarkLocation {
        static let defaultLat = 50.0755
        static let defaultLon = 14.4378

    }
}
