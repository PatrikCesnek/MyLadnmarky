//
//  Category.swift
//  Landmarky
//
//  Created by Patrik Cesnek on 03/02/2025.
//

enum LandmarkCategory: CaseIterable {
    case all
    case lakes
    case hills
    case castles
    case lookouts
    case restaurants
    case bars
    case shops
    case entertainment
    case custom
    case other
    
    var localizedName: String {
        switch self {
        case .all: return Constants.Strings.allLandmarks
        case .lakes: return Constants.Strings.lakes
        case .hills: return Constants.Strings.hills
        case .castles: return Constants.Strings.castles
        case .lookouts: return Constants.Strings.lookouts
        case .restaurants: return Constants.Strings.restaurants
        case .bars: return Constants.Strings.bars
        case .shops: return Constants.Strings.shops
        case .entertainment: return Constants.Strings.entertainment
        case .custom: return Constants.Strings.custom
        case .other: return Constants.Strings.other
        }
    }
    
    static var predefinedCategories: [LandmarkCategory] {
        return [.all, .lakes, .hills, .castles, .lookouts, .restaurants, .shops, .entertainment, .other]
    }
}
