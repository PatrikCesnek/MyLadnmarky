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
        case .castles: return Constants.SystemImages.castleAnnotation
        case .lookouts: return Constants.SystemImages.lookoutAnnotation
        case .restaurants: return Constants.SystemImages.restaurantAnnotation
        case .bars: return Constants.SystemImages.barAnnotation
        case .shops: return Constants.SystemImages.shopsAnnotation
        case .entertainment: return Constants.SystemImages.entertainmentAnnotation
        case .all, .custom, .other: return Constants.SystemImages.mappin
        }
    }
    
    static func changeAnnotationColor(categoryName: String) -> Color {
        switch categoryName {
        case Constants.Categories.lakes: return .blue
        case Constants.Categories.castles: return .gray
        case Constants.Categories.restaurants: return .orange
        case Constants.Categories.bars: return .pink
        case Constants.Categories.shops: return .purple
        case Constants.Categories.entertainment: return .yellow
        case Constants.Categories.hills,
            Constants.Categories.lookouts,
            Constants.Categories.custom,
            Constants.Categories.other: return .green
        default: return .green
        }
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
