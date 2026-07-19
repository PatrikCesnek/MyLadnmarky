//
//  Category.swift
//  Landmarky
//
//  Created by Patrik Cesnek on 03/02/2025.
//

enum LandmarkCategory: CaseIterable, Codable {
    case all
    case lakes
    case hills
    case parks
    case castles
    case historicalLandmarks
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
        case .lakes: return Constants.Categories.lakes
        case .hills: return Constants.Categories.hills
        case .parks: return Constants.Categories.parks
        case .castles: return Constants.Categories.castles
        case .historicalLandmarks: return Constants.Categories.historicalLandmarks
        case .lookouts: return Constants.Categories.lookouts
        case .restaurants: return Constants.Categories.restaurants
        case .bars: return Constants.Categories.bars
        case .shops: return Constants.Categories.shops
        case .entertainment: return Constants.Categories.entertainment
        case .custom: return Constants.Categories.custom
        case .other: return Constants.Categories.other
        }
    }

    static var predefinedCategories: [LandmarkCategory] {
        return [.lakes, .hills, .parks, .castles, .historicalLandmarks, .lookouts, .restaurants, .bars, .shops, .entertainment, .other]
    }
    
    init(from string: String) {
        self = LandmarkCategory.allCases.first { $0.localizedName == string } ?? .other
    }
}
