//
//  LandmarkCard.swift
//  Landmarky
//
//  Created by Patrik Cesnek on 08/03/2025.
//

import SwiftUI

struct LandmarkCard: View {
    var landmark: Landmark
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            LandmarkImageView(
                imageData: landmark.image,
                cornerRadius: 10,
                isCircular: false
            )
            .foregroundStyle(Color.gray)
            .frame(width: 155, height: 155)
            
            Text(landmark.name)
                .font(.caption)
                .fontWeight(.semibold)
                .lineLimit(1)
        }
        .frame(height: 185)
    }
}

#Preview {
    LandmarkCard(
        landmark: Mock.MockLandmarks.data[0]
    )
}
