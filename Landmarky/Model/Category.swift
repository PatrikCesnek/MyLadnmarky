//
//  Category.swift
//  Landmarky
//
//  Created by Patrik Cesnek on 03/02/2025.
//

enum LandmarkCategory: CaseIterable {
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
        case .lakes: return Constants.strings.lakes
        case .hills: return Constants.strings.hills
        case .castles: return Constants.strings.castles
        case .lookouts: return Constants.strings.lookouts
        case .restaurants: return Constants.strings.restaurants
        case .bars: return Constants.strings.bars
        case .shops: return Constants.strings.shops
        case .entertainment: return Constants.strings.entertainment
        case .custom: return Constants.strings.custom
        case .other: return Constants.strings.other
        }
    }
    
    static var predefinedCategories: [LandmarkCategory] {
        return [.lakes, .hills, .castles, .lookouts, .restaurants, .shops, .entertainment, .other]
    }
}
