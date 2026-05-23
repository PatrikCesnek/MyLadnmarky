//
//  Constants.swift
//  Landmarky
//
//  Created by Patrik Cesnek on 31/01/2025.
//

import Foundation
import MapKit

public struct Constants {
    struct Strings {
        static let search = String(localized: "Search")
        static let homeTitle = String(localized: "My landmarks")
        static let achievementsTitle = String(localized: "Achievements")
        static let noLandmarks = String(localized: "So far you have no saved landmarks")
        static let noAchievements = String(localized: "So far you don't have any achievements")
        static let unknownPlace = String(localized: "Unknown place")
        static let landmarkCountString1 = String(localized: "You have: ")
        static let landmarkCountString2 = String(localized: "landmarks")
        static let allLandmarks = String(localized: "All")
        static let title = String(localized: "Title")
        static let description = String(localized: "Description")
        static let location = String(localized: "Location")
        static let latitude = String(localized: "Latitude")
        static let longitude = String(localized: "Longitude")
        static let addLandmarkTitle = String(localized: "Add landmark")
        static let category = String(localized: "Category")
        static let customCategory = Categories.custom + " " + category.lowercased()
        static let choosePhotoSource = String(localized: "Select Photo Source")
        static let createLandmarks = String(localized: "Go into the map tab and create your landmarks")
        static let errorTitle = String(localized: "Ooops, something went wrong...")
        static let locationError = String(localized: "Cannot get your location...")
        static let firstName = String(localized: "First name")
        static let lastName = String(localized: "Last name")
        static let enterName = String(localized: "Please enter your name")
        static let landmarkSaved = String(localized: "Landmark saved!")
        static let invalidCoordinates = String(localized: "Please enter valid coordinates.")
        static let invalidCustomCategory = String(localized: "Please enter a custom category.")
        static let travelDiary = String(localized: "Travel Diary")
        static let newTrip = String(localized: "New Trip")
        static let editTrip = String(localized: "Edit Trip")
        static let noTrips = String(localized: "No trips yet")
        static let startDocumenting = String(localized: "Start documenting your adventures")
        static let multiDayTrip = String(localized: "Multi-day trip")
        static let startDate = String(localized: "Start")
        static let endDate = String(localized: "End")
        static let dates = String(localized: "Dates")
        static let favorites = String(localized: "Favorites")
        static let statsLandmarks = String(localized: "Landmarks")
        static let statsCountries = String(localized: "Countries")
        static let statsBadges = String(localized: "Badges")
        static let visitDateLabel = String(localized: "Visit date")
        static let addVisitDate = String(localized: "Add visit date")
    }

    struct Buttons {
        static let home = String(localized: "Home")
        static let map = String(localized: "Map")
        static let diary = String(localized: "Diary")
        static let profile = String(localized: "Profile")
        static let search = String(localized: "Search")
        static let edit = String(localized: "Edit")
        static let delete = String(localized: "Delete")
        static let navigate = String(localized: "Navigate")
        static let save = String(localized: "Save")
        static let cancel = String(localized: "Cancel")
        static let takePhoto = String(localized: "Take a photo")
        static let chooseFromGallery = String(localized: "Choose from Gallery")
        static let errorRetryButton = String(localized: "Try Again")
    }

    struct Categories {
        static let lakes = String(localized: "Lakes")
        static let hills = String(localized: "Hills")
        static let castles = String(localized: "Castles")
        static let lookouts = String(localized: "Lookouts")
        static let restaurants = String(localized: "Restaurants")
        static let bars = String(localized: "Bars")
        static let shops = String(localized: "Shops")
        static let entertainment = String(localized: "Entertainment")
        static let custom = String(localized: "Custom")
        static let other = String(localized: "Other")
    }

    struct Continents {
        static let europe = "Europe"
        static let asia = "Asia"
        static let africa = "Africa"
        static let northAmerica = "North America"
        static let southAmerica = "South America"
    }

    struct Badges {
        struct Tiers {
            static let bronze = String(localized: "Bronze")
            static let silver = String(localized: "Silver")
            static let gold = String(localized: "Gold")
            static let platinum = String(localized: "Platinum")
            static let diamond = String(localized: "Diamond")
        }

        struct Names {
            static let firstSteps = String(localized: "First Steps")
            static let photographer = String(localized: "Photographer")
            static let storyteller = String(localized: "Storyteller")
            static let diaryKeeper = String(localized: "Diary Keeper")
            static let explorer = String(localized: "Explorer")
            static let snapshot = String(localized: "Snapshot")
            static let curiousMind = String(localized: "Curious Mind")
            static let borderCrosser = String(localized: "Border Crosser")
            static let chronicler = String(localized: "Chronicler")
            static let adventurer = String(localized: "Adventurer")
            static let photoAlbum = String(localized: "Photo Album")
            static let versatile = String(localized: "Versatile")
            static let worldTraveler = String(localized: "World Traveler")
            static let continental = String(localized: "Continental")
            static let europeanExplorer = String(localized: "European Explorer")
            static let pathfinder = String(localized: "Pathfinder")
            static let jetSetter = String(localized: "Jet Setter")
            static let completionist = String(localized: "Completionist")
            static let asianExplorer = String(localized: "Asian Explorer")
            static let americasExplorer = String(localized: "Americas Explorer")
            static let trailblazer = String(localized: "Trailblazer")
            static let legend = String(localized: "Legend")
            static let globeMaster = String(localized: "Globe Master")
            static let worldCitizen = String(localized: "World Citizen")
            static let eliteExplorer = String(localized: "Elite Explorer")
            static let galleryOwner = String(localized: "Gallery Owner")
            static let africanExplorer = String(localized: "African Explorer")
            static let ultimateTraveler = String(localized: "Ultimate Traveler")
        }

        struct Descriptions {
            static let firstSteps = String(localized: "Save your first landmark")
            static let photographer = String(localized: "Add a photo to a landmark")
            static let storyteller = String(localized: "Write a description for a landmark")
            static let diaryKeeper = String(localized: "Create your first trip")
            static let explorer = String(localized: "Save 5 landmarks")
            static let snapshot = String(localized: "Add photos to 5 landmarks")
            static let curiousMind = String(localized: "Use 3 different categories")
            static let borderCrosser = String(localized: "Visit 2 different countries")
            static let chronicler = String(localized: "Create 5 trips")
            static let adventurer = String(localized: "Save 10 landmarks")
            static let photoAlbum = String(localized: "Add photos to 25 landmarks")
            static let versatile = String(localized: "Use 5 different categories")
            static let worldTraveler = String(localized: "Visit 5 different countries")
            static let continental = String(localized: "Visit 2 different continents")
            static let europeanExplorer = String(localized: "Visit 5 European countries")
            static let pathfinder = String(localized: "Save 25 landmarks")
            static let jetSetter = String(localized: "Visit 10 different countries")
            static let completionist = String(localized: "Use all predefined categories")
            static let asianExplorer = String(localized: "Visit 5 Asian countries")
            static let americasExplorer = String(localized: "Visit 5 countries in the Americas")
            static let trailblazer = String(localized: "Save 50 landmarks")
            static let legend = String(localized: "Save 100 landmarks")
            static let globeMaster = String(localized: "Visit 25 different countries")
            static let worldCitizen = String(localized: "Visit all 6 inhabited continents")
            static let eliteExplorer = String(localized: "Visit 50 different countries")
            static let galleryOwner = String(localized: "Add photos to 50 landmarks")
            static let africanExplorer = String(localized: "Visit 5 African countries")
            static let ultimateTraveler = String(localized: "Visit 100 different countries")
        }

        struct Icons {
            static let firstSteps = "flag.fill"
            static let photographer = "camera.fill"
            static let storyteller = "book.closed.fill"
            static let diaryKeeper = "text.book.closed.fill"
            static let explorer = "map.fill"
            static let snapshot = "photo.stack.fill"
            static let curiousMind = "lightbulb.fill"
            static let borderCrosser = "airplane.departure"
            static let chronicler = "pencil.line"
            static let adventurer = "figure.hiking"
            static let photoAlbum = "photo.on.rectangle.angled"
            static let versatile = "square.grid.3x3.fill"
            static let worldTraveler = "globe"
            static let continental = "globe.americas.fill"
            static let europeanExplorer = "globe.europe.africa.fill"
            static let pathfinder = "binoculars.fill"
            static let jetSetter = "airplane.circle.fill"
            static let completionist = "star.circle.fill"
            static let asianExplorer = "globe.asia.australia.fill"
            static let americasExplorer = "globe.americas.fill"
            static let trailblazer = "flame.fill"
            static let legend = "crown.fill"
            static let globeMaster = "globe.badge.chevron.backward"
            static let worldCitizen = "sparkles"
            static let eliteExplorer = "medal.fill"
            static let galleryOwner = "photo.artframe"
            static let africanExplorer = "sun.max.fill"
            static let ultimateTraveler = "trophy.fill"
        }
    }

    struct SystemImages {
        static let plus = "plus"
        static let house = "house"
        static let map = "map"
        static let person = "person"
        static let personCircle = "person.circle"
        static let mappin = "mappin.circle.fill"
        static let backButton = "chevron.left"
        static let emptyPhoto = "photo.circle.fill"
        static let emptyPhotoCard = "photo"
        static let lakeAnnotation = "water.waves"
        static let hillAnnotation = "mountain.2.fill"
        static let castleAnnotation = "building.columns.fill"
        static let lookoutAnnotation = "binoculars.fill"
        static let restaurantAnnotation = "fork.knife.circle.fill"
        static let barAnnotation = "wineglass.fill"
        static let shopsAnnotation = "bag.fill"
        static let entertainmentAnnotation = "music.note.house.fill"
        static let editButtonImage = "pencil"
        static let editSaveButtonImage = "checkmark"
        static let gearXmark = "gear.badge.xmark"
        static let book = "book.fill"
    }

    struct DefaultLandmarkLocation {
        static let defaultLat = 50.0755
        static let defaultLon = 14.4378
        static let defaultLocation = CLLocationCoordinate2D(latitude: 50.0755, longitude: 14.4378)
    }
}
