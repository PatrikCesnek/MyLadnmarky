//
//  LocationCarouselView.swift
//  Landmarky
//
//  Created by Patrik Cesnek on 19/07/2026.
//

import SwiftUI

struct LocationCarouselView: View {
    @Binding private var latitude: String
    @Binding private var longitude: String
    @Binding private var title: String

    @State private var searchViewModel: PlaceSearchViewModel
    @State private var selectedPlaceName: String?

    init(
        latitude: Binding<String>,
        longitude: Binding<String>,
        title: Binding<String>
    ) {
        self._latitude = latitude
        self._longitude = longitude
        self._title = title

        let centerLatitude = HelperFunctions.parseCoordinate(latitude.wrappedValue, type: .lat)
            ?? Constants.DefaultLandmarkLocation.defaultLat
        let centerLongitude = HelperFunctions.parseCoordinate(longitude.wrappedValue, type: .lon)
            ?? Constants.DefaultLandmarkLocation.defaultLon

        _searchViewModel = State(
            initialValue: PlaceSearchViewModel(
                centerLatitude: centerLatitude,
                centerLongitude: centerLongitude
            )
        )
    }

    var body: some View {
        TabView {
            PlaceSearchSectionView(
                viewModel: searchViewModel,
                selectedPlaceName: selectedPlaceName
            ) { result in
                latitude = String(result.latitude)
                longitude = String(result.longitude)
                if title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    title = result.name
                }
                selectedPlaceName = result.name
                searchViewModel.select(result)
            }
            .padding(.bottom, 28)

            VStack {
                AddCoordinateSectionView(
                    latitude: $latitude,
                    longitude: $longitude
                )

                Spacer(minLength: 0)
            }
            .padding(.bottom, 28)
        }
        .tabViewStyle(.page)
        .indexViewStyle(.page(backgroundDisplayMode: .always))
        .frame(height: 240)
    }
}

#Preview {
    @Previewable @State var latitude = "\(Constants.DefaultLandmarkLocation.defaultLat)"
    @Previewable @State var longitude = "\(Constants.DefaultLandmarkLocation.defaultLon)"
    @Previewable @State var title = ""

    Form {
        Section {
            LocationCarouselView(
                latitude: $latitude,
                longitude: $longitude,
                title: $title
            )
        }
    }
}
