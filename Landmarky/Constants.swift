//
//  Constants.swift
//  Landmarky
//
//  Created by Patrik Cesnek on 31/01/2025.
//

import Foundation

public struct Constants {
    static let strings = Strings()
    struct Strings {
        let home = "Home".localizedCapitalized
        let map = "Map".localizedCapitalized
        let profile = "Profile".localizedCapitalized
        let search = "Search".localizedCapitalized
        let homeTitle = "My landmarks".localizedCapitalized
        let achievementsTitle = "Achievements".localizedCapitalized
        let noLandmarks = "So far you have no saved landmarks".localizedCapitalized
        let noAchievements = "So far you don't have any achievements".localizedCapitalized
        let lakes = "Lakes".localizedCapitalized
        let hills = "Hills".localizedCapitalized
        let castles = "Castles".localizedCapitalized
        let lookouts = "Lookouts".localizedCapitalized
        let restaurants = "Restaurants".localizedCapitalized
        let bars = "Bars".localizedCapitalized
        let shops = "Shops".localizedCapitalized
        let entertainment = "Entertainment".localizedCapitalized
        let custom = "Custom".localizedCapitalized
        let other = "Other".localizedCapitalized
        let landmarkCountString1 = "You have:".localizedCapitalized
        let landmarkCountString2 = "landmarks".localizedCapitalized
    }
    
    struct SystemImages {
        static let plus = "plus"
        static let house = "house"
        static let map = "map"
        static let person = "person"
        static let mappin = "mappin.circle.fill"
    }
    
    struct DefaultLandmarkLocation {
        static let defaultLat = 50.0755
        static let defaultLon = 14.4378

    }
}
