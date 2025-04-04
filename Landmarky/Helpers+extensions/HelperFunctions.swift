//
//  HelperFunctions.swift
//  Landmarky
//
//  Created by Patrik Cesnek on 24/03/2025.
//

import SwiftUI

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
        case Constants.Strings.hills: return .green
        case Constants.Strings.castles: return .gray
        case Constants.Strings.lookouts: return .green
        case Constants.Strings.restaurants: return .orange
        case Constants.Strings.bars: return .red
        case Constants.Strings.shops: return .purple
        case Constants.Strings.entertainment: return .red
        case Constants.Strings.custom: return .green
        case Constants.Strings.other: return .green
        default: return .green
        }
    }
}
