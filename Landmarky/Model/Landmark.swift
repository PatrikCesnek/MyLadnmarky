//
//  Landmark.swift
//  Landmarky
//
//  Created by Patrik Cesnek on 03/02/2025.
//

import Foundation
import SwiftData
import UIKit

@Model
final class Landmark {
    var id = UUID()
    var name: String
    var category: String
    var latitude: Double?
    var longitude: Double?
    var image: Data?
    var landmarkDescription: String?
    var isFavorite: Bool = false
    var isWishlisted: Bool = false
    var visitDate: Date?
    var country: String?
    var continent: String?
    /// ISO 3166-1 alpha-2, e.g. "SK". Language independent, unlike `country`.
    var countryCode: String?
    /// Trips this place belongs to. Inverse of `Trip.landmarks`; removing a trip only unlinks it.
    var trips: [Trip]? = []

    init(
        id: UUID = UUID(),
        name: String,
        category: String,
        latitude: Double? = nil,
        longitude: Double? = nil,
        image: Data? = nil,
        landmarkDescription: String? = nil,
        isFavorite: Bool = false,
        isWishlisted: Bool = false,
        visitDate: Date? = nil,
        country: String? = nil,
        continent: String? = nil,
        countryCode: String? = nil
    ) {
        self.id = id
        self.name = name
        self.category = category
        self.latitude = latitude
        self.longitude = longitude
        self.image = image
        self.landmarkDescription = landmarkDescription
        self.isFavorite = isFavorite
        self.isWishlisted = isWishlisted
        self.visitDate = visitDate
        self.country = country
        self.continent = continent
        self.countryCode = countryCode
    }

    /// Identity used when counting countries: the ISO code, or the stored name for places
    /// saved before codes existed and not yet backfilled.
    var countryKey: String? {
        countryCode ?? country
    }
    
    var linkedTrips: [Trip] {
        (trips ?? []).sorted { $0.startDate > $1.startDate }
    }

    var landmarkImage: UIImage? {
        guard let imageData = image else { return nil }
        return UIImage(data: imageData)
    }
}

extension Landmark: Identifiable, Equatable {
    static func == (lhs: Landmark, rhs: Landmark) -> Bool {
        lhs.id == rhs.id
    }
}
