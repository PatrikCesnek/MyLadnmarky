//
//  TripShareCard.swift
//  Landmarky
//
//  Created by Patrik Cesnek on 07/10/2026.
//

import SwiftUI

struct TripShareCard: View {
    let title: String
    let dateText: String
    let photos: [UIImage]
    let placeCount: Int
    let countryCodes: [String]

    init(trip: Trip) {
        self.title = trip.title
        self.dateText = trip.dateRangeText
        self.photos = Array(trip.tripImages.prefix(3))
        let places = trip.orderedLandmarks
        self.placeCount = places.count
        var seen = Set<String>()
        self.countryCodes = places.compactMap(\.countryCode).filter { seen.insert($0).inserted }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            collage
                .frame(height: 260)
                .clipped()

            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .lineLimit(2)
                    .minimumScaleFactor(0.6)

                Text(dateText)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(.white.opacity(0.75))

                HStack(spacing: 10) {
                    if placeCount > 0 {
                        Label(Constants.Strings.placesCount(placeCount), systemImage: "mappin.and.ellipse")
                    }
                    if !countryCodes.isEmpty {
                        Text(countryCodes.prefix(8).map(CountryCatalog.flag(for:)).joined(separator: " "))
                    }
                }
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(ShareCardStyle.accent)

                Spacer(minLength: 0)

                ShareCardFooter()
            }
            .foregroundStyle(.white)
            .padding(22)
        }
        .frame(width: ShareCardRenderer.cardSize.width, height: ShareCardRenderer.cardSize.height)
        .background(ShareCardStyle.background)
    }

    @ViewBuilder
    private var collage: some View {
        let width = ShareCardRenderer.cardSize.width
        switch photos.count {
        case 0:
            ShareCardPhoto(image: nil, fallbackSymbol: Constants.SystemImages.book)
                .frame(width: width)
        case 1, 2:
            HStack(spacing: 3) {
                ForEach(Array(photos.enumerated()), id: \.offset) { _, photo in
                    ShareCardPhoto(image: photo)
                        .frame(width: (width - 3 * CGFloat(photos.count - 1)) / CGFloat(photos.count), height: 260)
                        .clipped()
                }
            }
        default:
            HStack(spacing: 3) {
                ShareCardPhoto(image: photos[0])
                    .frame(width: width * 0.62, height: 260)
                    .clipped()
                VStack(spacing: 3) {
                    ShareCardPhoto(image: photos[1])
                        .frame(width: width * 0.38 - 3, height: 128.5)
                        .clipped()
                    ShareCardPhoto(image: photos[2])
                        .frame(width: width * 0.38 - 3, height: 128.5)
                        .clipped()
                }
            }
        }
    }
}

#Preview {
    TripShareCard(trip: Mock.MockTrips.data[0])
}
