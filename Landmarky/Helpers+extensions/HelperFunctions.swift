//
//  HelperFunctions.swift
//  Landmarky
//
//  Created by Patrik Cesnek on 24/03/2025.
//

import MapKit
import SwiftData
import SwiftUI

enum CoordinateType {
    case lat, lon
}

struct HelperFunctions {
    static func parseCoordinate(_ input: String, type: CoordinateType) -> Double? {
        let normalizedInput = input
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: ",", with: ".")

        guard let value = Double(normalizedInput) else {
            return nil
        }

        switch type {
        case .lat:
            return (-90...90).contains(value) ? value : nil
        case .lon:
            return (-180...180).contains(value) ? value : nil
        }
    }
    
    static func getCategoryString(_ categoryName: String) -> String {
        let category = LandmarkCategory(from: categoryName)
        switch category {
        case .lakes: return Constants.SystemImages.lakeAnnotation
        case .hills: return Constants.SystemImages.hillAnnotation
        case .parks: return Constants.SystemImages.parkAnnotation
        case .castles: return Constants.SystemImages.castleAnnotation
        case .historicalLandmarks: return Constants.SystemImages.historicalLandmarkAnnotation
        case .lookouts: return Constants.SystemImages.lookoutAnnotation
        case .restaurants: return Constants.SystemImages.restaurantAnnotation
        case .bars: return Constants.SystemImages.barAnnotation
        case .shops: return Constants.SystemImages.shopsAnnotation
        case .entertainment: return Constants.SystemImages.entertainmentAnnotation
        case .all, .custom, .other: return Constants.SystemImages.mappin
        }
    }
    
    enum PlaceColors {
        static let lakes = Color(hex: "3399FF")           // Vibrant blue
        static let castles = Color(hex: "8B6F47")         // Warm stone
        static let parks = Color(hex: "66BB33")           // Fresh green
        static let historical = Color(hex: "C0392B")      // Brick red
        static let restaurants = Color(hex: "FF8033")     // Sunset orange
        static let bars = Color(hex: "E63366")            // Vivid pink/magenta
        static let shops = Color(hex: "B366CC")           // Rich purple
        static let entertainment = Color(hex: "FFD700")   // Gold
        static let nature = Color(hex: "33B366")          // Forest green
        static let neutral = Color(hex: "999999")         // Neutral gray
    }

    static func changeAnnotationColor(categoryName: String) -> Color {
        switch categoryName {
        case Constants.Categories.lakes: return PlaceColors.lakes
        case Constants.Categories.castles: return PlaceColors.castles
        case Constants.Categories.parks: return PlaceColors.parks
        case Constants.Categories.historicalLandmarks: return PlaceColors.historical
        case Constants.Categories.restaurants: return PlaceColors.restaurants
        case Constants.Categories.bars: return PlaceColors.bars
        case Constants.Categories.shops: return PlaceColors.shops
        case Constants.Categories.entertainment: return PlaceColors.entertainment
        case Constants.Categories.hills,
            Constants.Categories.lookouts: return PlaceColors.nature
        case Constants.Categories.custom,
            Constants.Categories.other: return PlaceColors.neutral
        default: return PlaceColors.nature
        }
    }

    static var privacyPolicyURL: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "worldwanderer-web.netlify.app"
        components.path = "/privacy"
        components.queryItems = [
            URLQueryItem(name: "lang", value: appLanguageCode)
        ]

        return components.url
    }

    private static var appLanguageCode: String {
        let preferredLanguage = Bundle.main.preferredLocalizations.first
            ?? Locale.current.language.languageCode?.identifier
            ?? "en"
        let code = preferredLanguage.split(separator: "-").first.map(String.init) ?? preferredLanguage

        return code == "Base" ? "en" : code.lowercased()
    }
    
    static func deleteLandmark(using context: ModelContext, landmark: Landmark?) throws {
        guard let landmark else { return }

        context.delete(landmark)
        try context.save()
    }
    
    static func getCoordinate(_ coordinateType: CoordinateType, _ coordinate: Double?) -> Double {
        if let coordinate = coordinate {
            return coordinate
        } else {
            if coordinateType == .lat {
                return Constants.DefaultLandmarkLocation.defaultLat
            } else {
                return Constants.DefaultLandmarkLocation.defaultLon
            }
        }
    }
    
    static func getLocation(landmark: Landmark) -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(
            latitude: getCoordinate(.lat, landmark.latitude),
            longitude: getCoordinate(.lon, landmark.longitude)
        )
    }
}
extension Color {
    init(hex: String) {
        let cleanedHex = hex
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "#", with: "")

        var value: UInt64 = 0
        Scanner(string: cleanedHex).scanHexInt64(&value)

        let alpha: Double
        let red: Double
        let green: Double
        let blue: Double

        switch cleanedHex.count {
        case 3:
            alpha = 1
            red = Double((value >> 8) & 0xF) / 15
            green = Double((value >> 4) & 0xF) / 15
            blue = Double(value & 0xF) / 15
        case 6:
            alpha = 1
            red = Double((value >> 16) & 0xFF) / 255
            green = Double((value >> 8) & 0xFF) / 255
            blue = Double(value & 0xFF) / 255
        case 8:
            alpha = Double((value >> 24) & 0xFF) / 255
            red = Double((value >> 16) & 0xFF) / 255
            green = Double((value >> 8) & 0xFF) / 255
            blue = Double(value & 0xFF) / 255
        default:
            alpha = 1
            red = 0
            green = 0.5
            blue = 0
        }

        self.init(.sRGB, red: red, green: green, blue: blue, opacity: alpha)
    }
}

