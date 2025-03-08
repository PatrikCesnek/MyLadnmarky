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
        VStack {
            if let image = landmark.landmarkImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 80)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 80)
                    .foregroundColor(.gray)
            }
            
            Text(landmark.name)
                .font(.subheadline)
                .lineLimit(1)
        }
        .frame(width: 140)
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .shadow(radius: 3)
    }
}

#Preview {
    LandmarkCard(
        landmark: Landmark(
            name: "New place",
            category: "Lakes"
        )
    )
}
