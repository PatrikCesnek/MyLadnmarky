//
//  LandmarkCard.swift
//  Landmarky
//
//  Created by Patrik Cesnek on 08/03/2025.
//

import SwiftUI

struct LandmarkCard: View {
    private var landmark: Landmark

    init(landmark: Landmark) {
        self.landmark = landmark
    }

    var body: some View {
        ZStack {
            LandmarkImageView(
                imageData: landmark.image,
                cornerRadius: 10,
                isCircular: false
            )
            .foregroundStyle(Color.gray)
            .frame(width: 200, height: 155)

            VStack {
                Spacer()

                Text(landmark.name)
                    .fontWeight(.bold)
                    .lineLimit(1)
                    .padding()
                    .foregroundStyle(.white)
                    .shadow(radius: 10)
            }
        }
        .frame(height: 155)
    }
}

#Preview {
    LandmarkCard(
        landmark: Mock.MockLandmarks.data[0]
    )
}
