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
    static func convertToDouble(_ input: String) -> Double {
        guard let convertedText = Double(input) else {
            return 0.0
        }
        
        return convertedText
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
        case Constants.Strings.lakes: return .blue
        case Constants.Strings.castles: return .gray
        case Constants.Strings.restaurants: return .orange
        case Constants.Strings.bars: return .pink
        case Constants.Strings.shops: return .purple
        case Constants.Strings.entertainment: return .yellow
        case Constants.Strings.hills,
            Constants.Strings.lookouts,
            Constants.Strings.custom,
            Constants.Strings.other: return .green
        default: return .green
        }
    }
    
    static func deleteLandmark(using context: ModelContext, landmark: Landmark?) {
        guard let landmark else { return }
        
        context.delete(landmark)
        
        do {
            try context.save()
            // TODO: - show success alert
            print("Landmark deleted successfully!")
        } catch {
            // TODO: - use proper error handling
            print("Failed to delete landmark: \(error)")
        }
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
