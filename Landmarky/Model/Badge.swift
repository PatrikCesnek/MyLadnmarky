import SwiftUI

enum BadgeTier: Int, CaseIterable, Comparable, Codable {
    case bronze = 0
    case silver = 1
    case gold = 2
    case platinum = 3
    case diamond = 4

    static func < (lhs: BadgeTier, rhs: BadgeTier) -> Bool {
        lhs.rawValue < rhs.rawValue
    }

    var displayName: String {
        switch self {
        case .bronze: Constants.Badges.Tiers.bronze
        case .silver: Constants.Badges.Tiers.silver
        case .gold: Constants.Badges.Tiers.gold
        case .platinum: Constants.Badges.Tiers.platinum
        case .diamond: Constants.Badges.Tiers.diamond
        }
    }

    var color: Color {
        switch self {
        case .bronze: Color(red: 0.55, green: 0.32, blue: 0.18)
        case .silver: Color(red: 0.70, green: 0.72, blue: 0.74)
        case .gold: Color(red: 0.86, green: 0.63, blue: 0.16)
        case .platinum: .cyan
        case .diamond: .purple
        }
    }
}

struct BadgeStats {
    let landmarkCount: Int
    let photosCount: Int
    let descriptionsCount: Int
    let uniqueCategories: Set<String>
    let uniqueCountries: Set<String>
    let uniqueContinents: Set<String>
    let europeanCountries: Set<String>
    let asianCountries: Set<String>
    let americanCountries: Set<String>
    let africanCountries: Set<String>
    let tripCount: Int

    init(landmarks: [Landmark], tripCount: Int) {
        self.landmarkCount = landmarks.count
        self.photosCount = landmarks.filter { $0.image != nil }.count
        self.descriptionsCount = landmarks.filter {
            guard let desc = $0.landmarkDescription else { return false }
            return !desc.isEmpty
        }.count
        self.uniqueCategories = Set(landmarks.map { $0.category })
        self.uniqueCountries = Set(landmarks.compactMap { $0.country })
        self.uniqueContinents = Set(landmarks.compactMap { $0.continent })
        self.tripCount = tripCount

        var european = Set<String>()
        var asian = Set<String>()
        var american = Set<String>()
        var african = Set<String>()

        for landmark in landmarks {
            guard let country = landmark.country, let continent = landmark.continent else { continue }
            switch continent {
            case Constants.Continents.europe: european.insert(country)
            case Constants.Continents.asia: asian.insert(country)
            case Constants.Continents.northAmerica, Constants.Continents.southAmerica: american.insert(country)
            case Constants.Continents.africa: african.insert(country)
            default: break
            }
        }

        self.europeanCountries = european
        self.asianCountries = asian
        self.americanCountries = american
        self.africanCountries = african
    }
}

struct BadgeItem: Identifiable {
    let badge: Badge
    let isEarned: Bool
    let progress: (current: Int, target: Int)

    var id: String { badge.id }
}

enum Badge: String, CaseIterable, Identifiable {
    case firstSteps
    case photographer
    case storyteller
    case diaryKeeper
    case explorer
    case snapshot
    case curiousMind
    case borderCrosser
    case chronicler
    case adventurer
    case photoAlbum
    case versatile
    case worldTraveler
    case continental
    case europeanExplorer
    case pathfinder
    case jetSetter
    case completionist
    case asianExplorer
    case americasExplorer
    case trailblazer
    case legend
    case globeMaster
    case worldCitizen
    case eliteExplorer
    case galleryOwner
    case africanExplorer
    case ultimateTraveler

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .firstSteps: Constants.Badges.Names.firstSteps
        case .photographer: Constants.Badges.Names.photographer
        case .storyteller: Constants.Badges.Names.storyteller
        case .diaryKeeper: Constants.Badges.Names.diaryKeeper
        case .explorer: Constants.Badges.Names.explorer
        case .snapshot: Constants.Badges.Names.snapshot
        case .curiousMind: Constants.Badges.Names.curiousMind
        case .borderCrosser: Constants.Badges.Names.borderCrosser
        case .chronicler: Constants.Badges.Names.chronicler
        case .adventurer: Constants.Badges.Names.adventurer
        case .photoAlbum: Constants.Badges.Names.photoAlbum
        case .versatile: Constants.Badges.Names.versatile
        case .worldTraveler: Constants.Badges.Names.worldTraveler
        case .continental: Constants.Badges.Names.continental
        case .europeanExplorer: Constants.Badges.Names.europeanExplorer
        case .pathfinder: Constants.Badges.Names.pathfinder
        case .jetSetter: Constants.Badges.Names.jetSetter
        case .completionist: Constants.Badges.Names.completionist
        case .asianExplorer: Constants.Badges.Names.asianExplorer
        case .americasExplorer: Constants.Badges.Names.americasExplorer
        case .trailblazer: Constants.Badges.Names.trailblazer
        case .legend: Constants.Badges.Names.legend
        case .globeMaster: Constants.Badges.Names.globeMaster
        case .worldCitizen: Constants.Badges.Names.worldCitizen
        case .eliteExplorer: Constants.Badges.Names.eliteExplorer
        case .galleryOwner: Constants.Badges.Names.galleryOwner
        case .africanExplorer: Constants.Badges.Names.africanExplorer
        case .ultimateTraveler: Constants.Badges.Names.ultimateTraveler
        }
    }

    var badgeDescription: String {
        switch self {
        case .firstSteps: Constants.Badges.Descriptions.firstSteps
        case .photographer: Constants.Badges.Descriptions.photographer
        case .storyteller: Constants.Badges.Descriptions.storyteller
        case .diaryKeeper: Constants.Badges.Descriptions.diaryKeeper
        case .explorer: Constants.Badges.Descriptions.explorer
        case .snapshot: Constants.Badges.Descriptions.snapshot
        case .curiousMind: Constants.Badges.Descriptions.curiousMind
        case .borderCrosser: Constants.Badges.Descriptions.borderCrosser
        case .chronicler: Constants.Badges.Descriptions.chronicler
        case .adventurer: Constants.Badges.Descriptions.adventurer
        case .photoAlbum: Constants.Badges.Descriptions.photoAlbum
        case .versatile: Constants.Badges.Descriptions.versatile
        case .worldTraveler: Constants.Badges.Descriptions.worldTraveler
        case .continental: Constants.Badges.Descriptions.continental
        case .europeanExplorer: Constants.Badges.Descriptions.europeanExplorer
        case .pathfinder: Constants.Badges.Descriptions.pathfinder
        case .jetSetter: Constants.Badges.Descriptions.jetSetter
        case .completionist: Constants.Badges.Descriptions.completionist
        case .asianExplorer: Constants.Badges.Descriptions.asianExplorer
        case .americasExplorer: Constants.Badges.Descriptions.americasExplorer
        case .trailblazer: Constants.Badges.Descriptions.trailblazer
        case .legend: Constants.Badges.Descriptions.legend
        case .globeMaster: Constants.Badges.Descriptions.globeMaster
        case .worldCitizen: Constants.Badges.Descriptions.worldCitizen
        case .eliteExplorer: Constants.Badges.Descriptions.eliteExplorer
        case .galleryOwner: Constants.Badges.Descriptions.galleryOwner
        case .africanExplorer: Constants.Badges.Descriptions.africanExplorer
        case .ultimateTraveler: Constants.Badges.Descriptions.ultimateTraveler
        }
    }

    var icon: String {
        switch self {
        case .firstSteps: Constants.Badges.Icons.firstSteps
        case .photographer: Constants.Badges.Icons.photographer
        case .storyteller: Constants.Badges.Icons.storyteller
        case .diaryKeeper: Constants.Badges.Icons.diaryKeeper
        case .explorer: Constants.Badges.Icons.explorer
        case .snapshot: Constants.Badges.Icons.snapshot
        case .curiousMind: Constants.Badges.Icons.curiousMind
        case .borderCrosser: Constants.Badges.Icons.borderCrosser
        case .chronicler: Constants.Badges.Icons.chronicler
        case .adventurer: Constants.Badges.Icons.adventurer
        case .photoAlbum: Constants.Badges.Icons.photoAlbum
        case .versatile: Constants.Badges.Icons.versatile
        case .worldTraveler: Constants.Badges.Icons.worldTraveler
        case .continental: Constants.Badges.Icons.continental
        case .europeanExplorer: Constants.Badges.Icons.europeanExplorer
        case .pathfinder: Constants.Badges.Icons.pathfinder
        case .jetSetter: Constants.Badges.Icons.jetSetter
        case .completionist: Constants.Badges.Icons.completionist
        case .asianExplorer: Constants.Badges.Icons.asianExplorer
        case .americasExplorer: Constants.Badges.Icons.americasExplorer
        case .trailblazer: Constants.Badges.Icons.trailblazer
        case .legend: Constants.Badges.Icons.legend
        case .globeMaster: Constants.Badges.Icons.globeMaster
        case .worldCitizen: Constants.Badges.Icons.worldCitizen
        case .eliteExplorer: Constants.Badges.Icons.eliteExplorer
        case .galleryOwner: Constants.Badges.Icons.galleryOwner
        case .africanExplorer: Constants.Badges.Icons.africanExplorer
        case .ultimateTraveler: Constants.Badges.Icons.ultimateTraveler
        }
    }

    var tier: BadgeTier {
        switch self {
        case .firstSteps, .photographer, .storyteller, .diaryKeeper:
            .bronze
        case .explorer, .snapshot, .curiousMind, .borderCrosser, .chronicler:
            .silver
        case .adventurer, .photoAlbum, .versatile, .worldTraveler, .continental, .europeanExplorer:
            .gold
        case .pathfinder, .jetSetter, .completionist, .asianExplorer, .americasExplorer:
            .platinum
        case .trailblazer, .legend, .globeMaster, .worldCitizen, .eliteExplorer, .galleryOwner, .africanExplorer, .ultimateTraveler:
            .diamond
        }
    }

    func isEarned(stats: BadgeStats) -> Bool {
        switch self {
        case .firstSteps: stats.landmarkCount >= 1
        case .photographer: stats.photosCount >= 1
        case .storyteller: stats.descriptionsCount >= 1
        case .diaryKeeper: stats.tripCount >= 1
        case .explorer: stats.landmarkCount >= 5
        case .snapshot: stats.photosCount >= 5
        case .curiousMind: stats.uniqueCategories.count >= 3
        case .borderCrosser: stats.uniqueCountries.count >= 2
        case .chronicler: stats.tripCount >= 5
        case .adventurer: stats.landmarkCount >= 10
        case .photoAlbum: stats.photosCount >= 25
        case .versatile: stats.uniqueCategories.count >= 5
        case .worldTraveler: stats.uniqueCountries.count >= 5
        case .continental: stats.uniqueContinents.count >= 2
        case .europeanExplorer: stats.europeanCountries.count >= 5
        case .pathfinder: stats.landmarkCount >= 25
        case .jetSetter: stats.uniqueCountries.count >= 10
        case .completionist:
            Set(LandmarkCategory.predefinedCategories.map { $0.localizedName }).isSubset(of: stats.uniqueCategories)
        case .asianExplorer: stats.asianCountries.count >= 5
        case .americasExplorer: stats.americanCountries.count >= 5
        case .trailblazer: stats.landmarkCount >= 50
        case .legend: stats.landmarkCount >= 100
        case .globeMaster: stats.uniqueCountries.count >= 25
        case .worldCitizen: stats.uniqueContinents.count >= 6
        case .eliteExplorer: stats.uniqueCountries.count >= 50
        case .galleryOwner: stats.photosCount >= 50
        case .africanExplorer: stats.africanCountries.count >= 5
        case .ultimateTraveler: stats.uniqueCountries.count >= 100
        }
    }

    func progress(stats: BadgeStats) -> (current: Int, target: Int) {
        let predefined = LandmarkCategory.predefinedCategories.map { $0.localizedName }
        switch self {
        case .firstSteps: return (min(stats.landmarkCount, 1), 1)
        case .photographer: return (min(stats.photosCount, 1), 1)
        case .storyteller: return (min(stats.descriptionsCount, 1), 1)
        case .diaryKeeper: return (min(stats.tripCount, 1), 1)
        case .explorer: return (min(stats.landmarkCount, 5), 5)
        case .snapshot: return (min(stats.photosCount, 5), 5)
        case .curiousMind: return (min(stats.uniqueCategories.count, 3), 3)
        case .borderCrosser: return (min(stats.uniqueCountries.count, 2), 2)
        case .chronicler: return (min(stats.tripCount, 5), 5)
        case .adventurer: return (min(stats.landmarkCount, 10), 10)
        case .photoAlbum: return (min(stats.photosCount, 25), 25)
        case .versatile: return (min(stats.uniqueCategories.count, 5), 5)
        case .worldTraveler: return (min(stats.uniqueCountries.count, 5), 5)
        case .continental: return (min(stats.uniqueContinents.count, 2), 2)
        case .europeanExplorer: return (min(stats.europeanCountries.count, 5), 5)
        case .pathfinder: return (min(stats.landmarkCount, 25), 25)
        case .jetSetter: return (min(stats.uniqueCountries.count, 10), 10)
        case .completionist: return (stats.uniqueCategories.intersection(Set(predefined)).count, predefined.count)
        case .asianExplorer: return (min(stats.asianCountries.count, 5), 5)
        case .americasExplorer: return (min(stats.americanCountries.count, 5), 5)
        case .trailblazer: return (min(stats.landmarkCount, 50), 50)
        case .legend: return (min(stats.landmarkCount, 100), 100)
        case .globeMaster: return (min(stats.uniqueCountries.count, 25), 25)
        case .worldCitizen: return (min(stats.uniqueContinents.count, 6), 6)
        case .eliteExplorer: return (min(stats.uniqueCountries.count, 50), 50)
        case .galleryOwner: return (min(stats.photosCount, 50), 50)
        case .africanExplorer: return (min(stats.africanCountries.count, 5), 5)
        case .ultimateTraveler: return (min(stats.uniqueCountries.count, 100), 100)
        }
    }

    static func evaluateAll(stats: BadgeStats) -> [BadgeItem] {
        Badge.allCases.map { badge in
            BadgeItem(
                badge: badge,
                isEarned: badge.isEarned(stats: stats),
                progress: badge.progress(stats: stats)
            )
        }
    }
}
