//
//  TripPlacesSection.swift
//  Landmarky
//
//  Created by Patrik Cesnek on 07/10/2026.
//

import MapKit
import SwiftUI

/// Map of a trip's places joined in visit order, followed by the list of places.
struct TripPlacesSection: View {
    let landmarks: [Landmark]

    private var mappable: [Landmark] {
        landmarks.filter { $0.latitude != nil && $0.longitude != nil }
    }

    private var routeCoordinates: [CLLocationCoordinate2D] {
        TripPlaces.route(landmarks).map {
            CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude)
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label(Constants.Strings.places, systemImage: "mappin.and.ellipse")
                .font(.headline)

            if !mappable.isEmpty {
                Map(initialPosition: .automatic, interactionModes: [.pan, .zoom]) {
                    if routeCoordinates.count > 1 {
                        MapPolyline(coordinates: routeCoordinates)
                            .stroke(.green, style: StrokeStyle(lineWidth: 3, lineCap: .round, dash: [6, 6]))
                    }

                    ForEach(Array(mappable.enumerated()), id: \.element.id) { index, landmark in
                        Marker(
                            landmark.name,
                            monogram: Text("\(index + 1)"),
                            coordinate: HelperFunctions.getLocation(landmark: landmark)
                        )
                        .tint(HelperFunctions.changeAnnotationColor(categoryName: landmark.category))
                    }
                }
                .frame(height: 220)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .accessibilityHidden(true)
            }

            VStack(spacing: 0) {
                ForEach(landmarks) { landmark in
                    NavigationLink {
                        LandmarkDetailView(landmark: landmark)
                    } label: {
                        row(for: landmark)
                    }
                    .buttonStyle(.plain)

                    if landmark.id != landmarks.last?.id {
                        Divider().padding(.leading, 44)
                    }
                }
            }
        }
    }

    private func row(for landmark: Landmark) -> some View {
        HStack(spacing: 12) {
            Image(systemName: HelperFunctions.getCategoryString(landmark.category))
                .foregroundStyle(HelperFunctions.changeAnnotationColor(categoryName: landmark.category))
                .frame(width: 32)

            VStack(alignment: .leading, spacing: 2) {
                Text(landmark.name)
                    .font(.body)
                if let visitDate = landmark.visitDate {
                    Text(visitDate, style: .date)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(.tertiary)
        }
        .padding(.vertical, 10)
        .contentShape(Rectangle())
    }
}

#Preview {
    NavigationStack {
        ScrollView {
            TripPlacesSection(landmarks: Array(Mock.MockLandmarks.data.prefix(4)))
                .padding()
        }
    }
}
