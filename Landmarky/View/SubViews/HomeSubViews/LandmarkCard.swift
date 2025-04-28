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
        VStack(spacing: 16) {
            LandmarkImageView(
                imageData: landmark.image,
                cornerRadius: 10,
                isCircular: false
            )
            .foregroundStyle(Color.gray)
            .frame(width: 120, height: 100)
            
            Text(landmark.name)
                .font(.caption)
                .fontWeight(.semibold)
                .lineLimit(1)
        }
        .frame(width: 140, height: 140)
        .padding(16)
        .background{
            RoundedRectangle(cornerRadius: 15)
                .fill(Color(.systemBackground))
                .stroke(.primary.opacity(0.1), lineWidth: 4)
                .shadow(color: .primary.opacity(0.3), radius: 2, x: 1, y: 1)
        }
    }
}

#Preview {
    LandmarkCard(
        landmark: Landmark(
            name: "Kučišdorfská priehrada",
            category: "Lakes"
        )
    )
}
