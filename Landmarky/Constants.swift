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
    }

    struct Buttons {
        static let home = String(localized: "Home")
        static let map = String(localized: "Map")
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
    }

    struct DefaultLandmarkLocation {
        static let defaultLat = 50.0755
        static let defaultLon = 14.4378
        static let defaultLocation = CLLocationCoordinate2D(latitude: 50.0755, longitude: 14.4378)
    }
}
