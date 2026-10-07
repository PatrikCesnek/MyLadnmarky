//
//  LandmarkShareCard.swift
//  Landmarky
//
//  Created by Patrik Cesnek on 07/10/2026.
//

import SwiftUI

/// Photo-led card for one place. Shows the country, never the coordinates.
struct LandmarkShareCard: View {
    let name: String
    let category: String
    let image: UIImage?
    let countryCode: String?
    let visitDate: Date?

    init(landmark: Landmark) {
        self.name = landmark.name
        self.category = landmark.category
        self.image = landmark.landmarkImage
        self.countryCode = landmark.countryCode
        self.visitDate = landmark.visitDate
    }

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            ShareCardPhoto(
                image: image,
                fallbackSymbol: HelperFunctions.getCategoryString(category),
                fallbackColor: HelperFunctions.changeAnnotationColor(categoryName: category)
            )
            .frame(width: ShareCardRenderer.cardSize.width, height: ShareCardRenderer.cardSize.height)
            .clipped()

            LinearGradient(
                colors: [.clear, .black.opacity(0.35), .black.opacity(0.85)],
                startPoint: .center,
                endPoint: .bottom
            )

            VStack(alignment: .leading, spacing: 8) {
                Label(category, systemImage: HelperFunctions.getCategoryString(category))
                    .font(.system(size: 13, weight: .semibold, design: .rounded))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(.black.opacity(0.35), in: Capsule())

                Text(name)
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .lineLimit(2)
                    .minimumScaleFactor(0.6)

                HStack(spacing: 8) {
                    if let countryCode {
                        Text("\(CountryCatalog.flag(for: countryCode)) \(CountryCatalog.localizedName(for: countryCode))")
                    }
                    if countryCode != nil, visitDate != nil {
                        Text(verbatim: "·")
                    }
                    if let visitDate {
                        Text(visitDate, format: .dateTime.day().month(.abbreviated).year())
                    }
                }
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(.white.opacity(0.85))

                ShareCardFooter()
                    .padding(.top, 10)
            }
            .foregroundStyle(.white)
            .padding(22)
        }
        .frame(width: ShareCardRenderer.cardSize.width, height: ShareCardRenderer.cardSize.height)
        .background(.black)
    }
}

#Preview {
    LandmarkShareCard(landmark: Mock.MockLandmarks.data[3])
}
