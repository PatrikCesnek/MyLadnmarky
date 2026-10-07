//
//  PhotoPlaceClusterer.swift
//  Landmarky
//
//  Created by Patrik Cesnek on 07/10/2026.
//

import Foundation

/// Where and when a photo was taken. `id` is the photo library's local identifier.
struct PhotoPoint: Sendable, Equatable {
    let id: String
    let latitude: Double
    let longitude: Double
    let date: Date?
}

/// A spot where one or more photos were taken.
struct PhotoPlaceCandidate: Identifiable, Sendable, Equatable {
    let latitude: Double
    let longitude: Double
    let photoCount: Int
    let firstDate: Date?
    let lastDate: Date?
    let distinctDays: Int
    /// Photo used as the suggestion's thumbnail and imported image.
    let representativePhotoID: String

    var id: String { representativePhotoID }
}

/// Groups photos taken within `radiusMeters` of each other into place candidates and picks
/// which ones are worth suggesting. Pure logic: no PhotoKit, fully unit tested.
enum PhotoPlaceClusterer {
    static let defaultRadiusMeters = 200.0
    /// Existing landmarks within this distance count as "already saved".
    static let existingPlaceRadiusMeters = 300.0
    /// Places photographed on more days than this are almost always home or work.
    static let maxDistinctDays = 30
    static let maxSuggestions = 40

    static func cluster(
        _ points: [PhotoPoint],
        radiusMeters: Double = defaultRadiusMeters,
        calendar: Calendar = .current
    ) -> [PhotoPlaceCandidate] {
        let cellDegrees = radiusMeters / 111_320
        var clusters: [Cluster] = []
        var grid: [GridKey: [Int]] = [:]

        for point in points where isValid(point) {
            let key = GridKey(latitude: point.latitude, longitude: point.longitude, cellDegrees: cellDegrees)

            let nearest = key.neighborhood(cellDegrees: cellDegrees)
                .flatMap { grid[$0] ?? [] }
                .map { (index: $0, distance: distanceMeters(clusters[$0].latitude, clusters[$0].longitude, point.latitude, point.longitude)) }
                .filter { $0.distance <= radiusMeters }
                .min { $0.distance < $1.distance }

            if let nearest {
                clusters[nearest.index].add(point)
            } else {
                grid[key, default: []].append(clusters.count)
                clusters.append(Cluster(seed: point))
            }
        }

        return clusters.map { $0.candidate(calendar: calendar) }
    }

    /// Candidates worth showing: not already saved, not home/work, most photographed first.
    static func suggestions(
        from candidates: [PhotoPlaceCandidate],
        existingCoordinates: [(latitude: Double, longitude: Double)],
        limit: Int = maxSuggestions
    ) -> [PhotoPlaceCandidate] {
        let fresh = candidates.filter { candidate in
            guard candidate.distinctDays <= maxDistinctDays else { return false }
            return !existingCoordinates.contains { existing in
                distanceMeters(existing.latitude, existing.longitude, candidate.latitude, candidate.longitude)
                    <= existingPlaceRadiusMeters
            }
        }

        return Array(
            fresh.sorted { lhs, rhs in
                if lhs.photoCount != rhs.photoCount { return lhs.photoCount > rhs.photoCount }
                return (lhs.lastDate ?? .distantPast) > (rhs.lastDate ?? .distantPast)
            }
            .prefix(limit)
        )
    }

    /// Haversine distance in meters.
    static func distanceMeters(_ lat1: Double, _ lon1: Double, _ lat2: Double, _ lon2: Double) -> Double {
        let earthRadius = 6_371_000.0
        let dLat = (lat2 - lat1) * .pi / 180
        let dLon = (lon2 - lon1) * .pi / 180
        let a = sin(dLat / 2) * sin(dLat / 2)
            + cos(lat1 * .pi / 180) * cos(lat2 * .pi / 180) * sin(dLon / 2) * sin(dLon / 2)
        return 2 * earthRadius * asin(min(1, sqrt(a)))
    }

    private static func isValid(_ point: PhotoPoint) -> Bool {
        (-90...90).contains(point.latitude) && (-180...180).contains(point.longitude)
            && !(point.latitude == 0 && point.longitude == 0)
    }
}

// MARK: - Internals

private struct Cluster {
    /// The first photo anchors the cluster, so membership never drifts across a city.
    let latitude: Double
    let longitude: Double
    private(set) var points: [PhotoPoint]

    init(seed: PhotoPoint) {
        latitude = seed.latitude
        longitude = seed.longitude
        points = [seed]
    }

    mutating func add(_ point: PhotoPoint) {
        points.append(point)
    }

    func candidate(calendar: Calendar) -> PhotoPlaceCandidate {
        let dates = points.compactMap(\.date).sorted()
        let days = Set(dates.map { calendar.startOfDay(for: $0) })
        // Middle photo by time: less likely to be a blurry first or last shot.
        let byDate = points.sorted { ($0.date ?? .distantPast) < ($1.date ?? .distantPast) }

        return PhotoPlaceCandidate(
            latitude: points.map(\.latitude).reduce(0, +) / Double(points.count),
            longitude: points.map(\.longitude).reduce(0, +) / Double(points.count),
            photoCount: points.count,
            firstDate: dates.first,
            lastDate: dates.last,
            distinctDays: days.count,
            representativePhotoID: byDate[byDate.count / 2].id
        )
    }
}

/// Grid cell roughly `radius` wide. Longitude cells widen towards the poles so a cell
/// always spans about the same distance.
private struct GridKey: Hashable {
    let row: Int
    let column: Int

    init(latitude: Double, longitude: Double, cellDegrees: Double) {
        row = Int((latitude / cellDegrees).rounded(.down))
        column = Int((longitude / Self.longitudeCell(row: row, cellDegrees: cellDegrees)).rounded(.down))
    }

    private init(row: Int, column: Int) {
        self.row = row
        self.column = column
    }

    func neighborhood(cellDegrees: Double) -> [GridKey] {
        let ownCell = Self.longitudeCell(row: row, cellDegrees: cellDegrees)
        let ownWest = Double(column) * ownCell

        return (-1...1).flatMap { rowOffset -> [GridKey] in
            let neighborRow = row + rowOffset
            let cell = Self.longitudeCell(row: neighborRow, cellDegrees: cellDegrees)
            // Columns of the neighbor row that overlap this cell, widened by one cell each side.
            let first = Int((ownWest / cell).rounded(.down)) - 1
            let last = Int(((ownWest + ownCell) / cell).rounded(.down)) + 1
            return (first...last).map { GridKey(row: neighborRow, column: $0) }
        }
    }

    private static func longitudeCell(row: Int, cellDegrees: Double) -> Double {
        let latitude = (Double(row) + 0.5) * cellDegrees
        return cellDegrees / max(cos(latitude * .pi / 180), 0.01)
    }
}
