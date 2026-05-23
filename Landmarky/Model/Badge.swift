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
        case .bronze: String(localized: "Bronze")
        case .silver: String(localized: "Silver")
        case .gold: String(localized: "Gold")
        case .platinum: String(localized: "Platinum")
        case .diamond: String(localized: "Diamond")
        }
    }

    var color: Color {
        switch self {
        case .bronze: .orange
        case .silver: .gray
        case .gold: .yellow
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
            case "Europe": european.insert(country)
            case "Asia": asian.insert(country)
            case "North America", "South America": american.insert(country)
            case "Africa": african.insert(country)
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
        case .firstSteps: String(localized: "First Steps")
        case .photographer: String(localized: "Photographer")
        case .storyteller: String(localized: "Storyteller")
        case .diaryKeeper: String(localized: "Diary Keeper")
        case .explorer: String(localized: "Explorer")
        case .snapshot: String(localized: "Snapshot")
        case .curiousMind: String(localized: "Curious Mind")
        case .borderCrosser: String(localized: "Border Crosser")
        case .chronicler: String(localized: "Chronicler")
        case .adventurer: String(localized: "Adventurer")
        case .photoAlbum: String(localized: "Photo Album")
        case .versatile: String(localized: "Versatile")
        case .worldTraveler: String(localized: "World Traveler")
        case .continental: String(localized: "Continental")
        case .europeanExplorer: String(localized: "European Explorer")
        case .pathfinder: String(localized: "Pathfinder")
        case .jetSetter: String(localized: "Jet Setter")
        case .completionist: String(localized: "Completionist")
        case .asianExplorer: String(localized: "Asian Explorer")
        case .americasExplorer: String(localized: "Americas Explorer")
        case .trailblazer: String(localized: "Trailblazer")
        case .legend: String(localized: "Legend")
        case .globeMaster: String(localized: "Globe Master")
        case .worldCitizen: String(localized: "World Citizen")
        case .eliteExplorer: String(localized: "Elite Explorer")
        case .galleryOwner: String(localized: "Gallery Owner")
        case .africanExplorer: String(localized: "African Explorer")
        case .ultimateTraveler: String(localized: "Ultimate Traveler")
        }
    }

    var badgeDescription: String {
        switch self {
        case .firstSteps: String(localized: "Save your first landmark")
        case .photographer: String(localized: "Add a photo to a landmark")
        case .storyteller: String(localized: "Write a description for a landmark")
        case .diaryKeeper: String(localized: "Create your first trip")
        case .explorer: String(localized: "Save 5 landmarks")
        case .snapshot: String(localized: "Add photos to 5 landmarks")
        case .curiousMind: String(localized: "Use 3 different categories")
        case .borderCrosser: String(localized: "Visit 2 different countries")
        case .chronicler: String(localized: "Create 5 trips")
        case .adventurer: String(localized: "Save 10 landmarks")
        case .photoAlbum: String(localized: "Add photos to 25 landmarks")
        case .versatile: String(localized: "Use 5 different categories")
        case .worldTraveler: String(localized: "Visit 5 different countries")
        case .continental: String(localized: "Visit 2 different continents")
        case .europeanExplorer: String(localized: "Visit 5 European countries")
        case .pathfinder: String(localized: "Save 25 landmarks")
        case .jetSetter: String(localized: "Visit 10 different countries")
        case .completionist: String(localized: "Use all predefined categories")
        case .asianExplorer: String(localized: "Visit 5 Asian countries")
        case .americasExplorer: String(localized: "Visit 5 countries in the Americas")
        case .trailblazer: String(localized: "Save 50 landmarks")
        case .legend: String(localized: "Save 100 landmarks")
        case .globeMaster: String(localized: "Visit 25 different countries")
        case .worldCitizen: String(localized: "Visit all 6 inhabited continents")
        case .eliteExplorer: String(localized: "Visit 50 different countries")
        case .galleryOwner: String(localized: "Add photos to 50 landmarks")
        case .africanExplorer: String(localized: "Visit 5 African countries")
        case .ultimateTraveler: String(localized: "Visit 100 different countries")
        }
    }

    var icon: String {
        switch self {
        case .firstSteps: "flag.fill"
        case .photographer: "camera.fill"
        case .storyteller: "book.closed.fill"
        case .diaryKeeper: "text.book.closed.fill"
        case .explorer: "map.fill"
        case .snapshot: "photo.stack.fill"
        case .curiousMind: "lightbulb.fill"
        case .borderCrosser: "airplane.departure"
        case .chronicler: "pencil.line"
        case .adventurer: "figure.hiking"
        case .photoAlbum: "photo.on.rectangle.angled"
        case .versatile: "square.grid.3x3.fill"
        case .worldTraveler: "globe"
        case .continental: "globe.americas.fill"
        case .europeanExplorer: "globe.europe.africa.fill"
        case .pathfinder: "binoculars.fill"
        case .jetSetter: "airplane.circle.fill"
        case .completionist: "star.circle.fill"
        case .asianExplorer: "globe.asia.australia.fill"
        case .americasExplorer: "globe.americas.fill"
        case .trailblazer: "flame.fill"
        case .legend: "crown.fill"
        case .globeMaster: "globe.badge.chevron.backward"
        case .worldCitizen: "sparkles"
        case .eliteExplorer: "medal.fill"
        case .galleryOwner: "photo.artframe"
        case .africanExplorer: "sun.max.fill"
        case .ultimateTraveler: "trophy.fill"
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
