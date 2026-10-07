//
//  WorldMap.swift
//  Landmarky
//
//  Created by Patrik Cesnek on 07/10/2026.
//

import CoreGraphics
import Foundation

/// Country outlines projected once into unit space (x in 0...1, y in 0...aspectRatio).
///
/// Shapes: Natural Earth 1:50m admin-0 countries (public domain), simplified and bundled
/// as `WorldCountries.json` — `{ "SK": [[lon, lat, lon, lat, ...], ...] }`.
struct WorldMap: Sendable {
    struct Country: Sendable {
        let code: String
        let rings: [[CGPoint]]

        /// Bounding box of the whole country in unit space.
        var bounds: CGRect {
            let points = rings.joined()
            guard let minX = points.map(\.x).min(), let maxX = points.map(\.x).max(),
                  let minY = points.map(\.y).min(), let maxY = points.map(\.y).max() else { return .null }
            return CGRect(x: minX, y: minY, width: maxX - minX, height: maxY - minY)
        }
    }

    let countries: [Country]
    /// Height / width of the projected map.
    let aspectRatio: CGFloat

    /// Loaded lazily on first access; ~400 KB, so touch it off the main thread.
    static let bundled: WorldMap? = {
        guard let url = Bundle.main.url(forResource: "WorldCountries", withExtension: "json"),
              let data = try? Data(contentsOf: url) else { return nil }
        return try? WorldMap(geoData: data)
    }()

    init(geoData: Data) throws {
        let raw = try JSONDecoder().decode([String: [[Double]]].self, from: geoData)

        var projected: [(code: String, rings: [[CGPoint]])] = []
        var minX = Double.infinity, maxX = -Double.infinity
        var minY = Double.infinity, maxY = -Double.infinity

        for (code, rings) in raw {
            let projectedRings = rings.map { flat in
                stride(from: 0, to: flat.count - 1, by: 2).map { index in
                    let point = Self.equalEarth(longitude: flat[index], latitude: flat[index + 1])
                    minX = min(minX, point.x); maxX = max(maxX, point.x)
                    minY = min(minY, point.y); maxY = max(maxY, point.y)
                    return CGPoint(x: point.x, y: point.y)
                }
            }
            projected.append((code, projectedRings))
        }

        let width = maxX - minX
        guard width > 0 else {
            countries = []
            aspectRatio = 0.5
            return
        }

        // Normalize: x to 0...1, y flipped (north up) and scaled by the same factor.
        countries = projected
            .sorted { $0.code < $1.code }
            .map { country in
                Country(code: country.code, rings: country.rings.map { ring in
                    ring.map { CGPoint(x: ($0.x - minX) / width, y: (maxY - $0.y) / width) }
                })
            }
        aspectRatio = (maxY - minY) / width
    }

    /// Equal Earth projection (Šavrič, Patterson, Jenny 2018), in radians-ish units.
    static func equalEarth(longitude: Double, latitude: Double) -> (x: Double, y: Double) {
        let a1 = 1.340264, a2 = -0.081106, a3 = 0.000893, a4 = 0.003796
        let m = sqrt(3) / 2
        let lambda = longitude * .pi / 180
        let phi = latitude * .pi / 180

        let theta = asin(m * sin(phi))
        let theta2 = theta * theta
        let theta6 = theta2 * theta2 * theta2

        let x = lambda * cos(theta) / (m * (a1 + 3 * a2 * theta2 + theta6 * (7 * a3 + 9 * a4 * theta2)))
        let y = theta * (a1 + a2 * theta2 + theta6 * (a3 + a4 * theta2))
        return (x, y)
    }
}
