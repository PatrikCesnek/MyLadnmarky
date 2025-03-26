//
//  HelperFunctions.swift
//  Landmarky
//
//  Created by Patrik Cesnek on 24/03/2025.
//

struct HelperFunctions {
    static func convertToDouble(_ input: String) -> Double {
        guard let convertedText = Double(input) else {
            return 0.0
        }
        
        return convertedText
    }
    
    static func getCategoryString(categoryName: String) -> String {
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
}
