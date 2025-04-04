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
                    .frame(width: 140, height: 120)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            } else {
                Image(systemName: Constants.SystemImages.empyPhotoCard)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 140, height: 120)
                    .foregroundColor(.gray)
            }
            
            Text(landmark.name)
                .font(.subheadline)
                .lineLimit(1)
        }
        .frame(width: 140)
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
