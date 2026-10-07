//
//  CountryBackfillService.swift
//  Landmarky
//
//  Created by Patrik Cesnek on 07/10/2026.
//

import Foundation
import SwiftData

/// Fills `countryCode` for places saved before codes existed, and country data for places
/// whose reverse geocoding failed (e.g. saved offline). Never overwrites existing values.
@MainActor
struct CountryBackfillService {
    typealias Geocoder = @Sendable (_ latitude: Double, _ longitude: Double) async -> GeocodedPlace?

    private let context: ModelContext
    private let geocode: Geocoder

    init(context: ModelContext, geocode: @escaping Geocoder = GeocodingHelper.reverseGeocode) {
        self.context = context
        self.geocode = geocode
    }

    /// Offline pass: derives codes from the stored (localized) country names.
    @discardableResult
    func backfillFromNames() throws -> Int {
        let descriptor = FetchDescriptor<Landmark>(
            predicate: #Predicate { $0.countryCode == nil && $0.country != nil }
        )
        var updated = 0

        for landmark in try context.fetch(descriptor) {
            guard let name = landmark.country, let code = CountryCatalog.code(forCountryName: name) else { continue }
            landmark.countryCode = code
            if landmark.continent == nil {
                landmark.continent = ContinentMapper.continent(forCountryCode: code)
            }
            updated += 1
        }

        if updated > 0 {
            try context.save()
        }
        return updated
    }

    /// Online pass: geocodes up to `limit` places that still have no country code. Apple
    /// throttles geocoding, so this runs a small batch per launch; failures retry later.
    @discardableResult
    func backfillByGeocoding(limit: Int = 10) async throws -> Int {
        let descriptor = FetchDescriptor<Landmark>(
            predicate: #Predicate { $0.countryCode == nil && $0.latitude != nil && $0.longitude != nil }
        )
        // Random batch: places that can never be geocoded (open sea) don't starve the rest.
        let batch = try context.fetch(descriptor).shuffled().prefix(limit)
        var updated = 0

        for landmark in batch {
            guard let latitude = landmark.latitude, let longitude = landmark.longitude,
                  let place = await geocode(latitude, longitude) else { continue }
            // The place may have been deleted or edited while we were waiting.
            guard !landmark.isDeleted, landmark.modelContext != nil, landmark.countryCode == nil else { continue }

            landmark.countryCode = place.countryCode
            if landmark.country == nil {
                landmark.country = place.country
            }
            if landmark.continent == nil {
                landmark.continent = place.continent
            }
            updated += 1
        }

        if updated > 0 {
            try context.save()
        }
        return updated
    }
}
