//
//  WorldMapView.swift
//  Landmarky
//
//  Created by Patrik Cesnek on 07/10/2026.
//

import SwiftUI

/// Flat world map with visited countries filled. Pure Canvas, so it also renders in
/// `ImageRenderer` for share cards.
struct WorldMapView: View {
    let map: WorldMap
    let visitedCodes: Set<String>
    var visitedColor: Color = .green
    var baseColor: Color = .secondary.opacity(0.25)
    var borderColor: Color = .clear
    var minimumVisibleSize: CGFloat = 5

    var body: some View {
        Canvas { context, size in
            let scale = min(size.width, size.height / map.aspectRatio)
            let offset = CGPoint(
                x: (size.width - scale) / 2,
                y: (size.height - scale * map.aspectRatio) / 2
            )

            var base = Path()
            var visited = Path()

            for country in map.countries {
                let isVisited = visitedCodes.contains(country.code)

                // Micro-states would vanish at map scale; mark visited ones with a dot.
                if isVisited {
                    let bounds = country.bounds
                    if !bounds.isNull, max(bounds.width, bounds.height) * scale < minimumVisibleSize {
                        let center = transform(CGPoint(x: bounds.midX, y: bounds.midY), scale: scale, offset: offset)
                        let radius = minimumVisibleSize / 2
                        visited.addEllipse(in: CGRect(x: center.x - radius, y: center.y - radius, width: radius * 2, height: radius * 2))
                    }
                }

                for ring in country.rings {
                    guard let first = ring.first else { continue }
                    var shape = Path()
                    shape.move(to: transform(first, scale: scale, offset: offset))
                    for point in ring.dropFirst() {
                        shape.addLine(to: transform(point, scale: scale, offset: offset))
                    }
                    shape.closeSubpath()

                    if isVisited {
                        visited.addPath(shape)
                    } else {
                        base.addPath(shape)
                    }
                }
            }

            context.fill(base, with: .color(baseColor))
            context.fill(visited, with: .color(visitedColor))
            if borderColor != .clear {
                context.stroke(base, with: .color(borderColor), lineWidth: 0.5)
                context.stroke(visited, with: .color(borderColor), lineWidth: 0.5)
            }
        }
        .aspectRatio(1 / map.aspectRatio, contentMode: .fit)
        .accessibilityHidden(true)
    }

    private func transform(_ point: CGPoint, scale: CGFloat, offset: CGPoint) -> CGPoint {
        CGPoint(x: offset.x + point.x * scale, y: offset.y + point.y * scale)
    }
}

/// Loads the bundled map off the main thread, then shows it.
struct LoadingWorldMapView: View {
    let visitedCodes: Set<String>
    var visitedColor: Color = .green
    var baseColor: Color = .secondary.opacity(0.25)

    @State private var map: WorldMap?

    var body: some View {
        Group {
            if let map {
                WorldMapView(map: map, visitedCodes: visitedCodes, visitedColor: visitedColor, baseColor: baseColor)
            } else {
                Color.clear
                    .aspectRatio(2, contentMode: .fit)
                    .overlay { ProgressView() }
            }
        }
        .task {
            guard map == nil else { return }
            map = await Task.detached(priority: .userInitiated) { WorldMap.bundled }.value
        }
    }
}

#Preview {
    LoadingWorldMapView(visitedCodes: ["SK", "CZ", "AT", "US", "JP", "BR", "AU", "ZA"])
        .padding()
}
