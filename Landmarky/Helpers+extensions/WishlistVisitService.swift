//
//  WishlistVisitService.swift
//  Landmarky
//
//  Created by Patrik Cesnek on 19/07/2026.
//

import CoreLocation
import SwiftData

struct WishlistVisitService {
    static func landmarksToAutoVisit(
        currentLatitude: Double,
        currentLongitude: Double,
        wishlisted: [Landmark],
        radiusMeters: Double = Constants.Wishlist.autoVisitRadiusMeters
    ) -> [Landmark] {
        let current = CLLocation(latitude: currentLatitude, longitude: currentLongitude)

        return wishlisted.filter { landmark in
            guard landmark.isWishlisted,
                  let latitude = landmark.latitude,
                  let longitude = landmark.longitude else { return false }

            let location = CLLocation(latitude: latitude, longitude: longitude)
            return location.distance(from: current) <= radiusMeters
        }
    }

    @MainActor
    static func markVisited(_ landmark: Landmark, in context: ModelContext) {
        landmark.isWishlisted = false
        if landmark.visitDate == nil {
            landmark.visitDate = Date()
        }
        try? context.save()
    }

    @MainActor
    static func autoVisitNearby(using context: ModelContext) {
        let manager = CLLocationManager()
        guard manager.authorizationStatus == .authorizedWhenInUse
                || manager.authorizationStatus == .authorizedAlways,
              let location = manager.location else { return }

        let descriptor = FetchDescriptor<Landmark>(
            predicate: #Predicate { $0.isWishlisted == true }
        )
        guard let wishlisted = try? context.fetch(descriptor), !wishlisted.isEmpty else { return }

        let nearby = landmarksToAutoVisit(
            currentLatitude: location.coordinate.latitude,
            currentLongitude: location.coordinate.longitude,
            wishlisted: wishlisted
        )

        for landmark in nearby {
            markVisited(landmark, in: context)
        }
    }
}
