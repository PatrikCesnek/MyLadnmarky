//
//  LandmarkImageView.swift
//  Landmarky
//
//  Created by Patrik Cesnek on 21/04/2025.
//

import SwiftUI

struct LandmarkImageView: View {
    private let imageData: Data?
    private let cornerRadius: CGFloat
    private let isCircular: Bool
    private let isProfile: Bool
    
    init(
        imageData: Data?,
        cornerRadius: CGFloat,
        isCircular: Bool,
        isProfile: Bool = false
    ) {
        self.imageData = imageData
        self.cornerRadius = cornerRadius
        self.isCircular = isCircular
        self.isProfile = isProfile
    }
    
    var body: some View {
        Group {
            if let data = imageData,
               let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .renderingMode(.original)
                    .resizable()
                    .cornerRadius(cornerRadius)
                    .overlay {
                        if isCircular {
                            Circle().stroke(.white, lineWidth: 6)
                        }
                    }
            } else {
                if isProfile {
                    Image(systemName: Constants.SystemImages.personCircle)
                        .resizable()
                        .scaledToFit()
                } else if isCircular {
                    ZStack {
                        Circle()
                            .fill(Color(.systemGray5))

                        Image(systemName: Constants.SystemImages.emptyPhotoCard)
                            .resizable()
                            .scaledToFit()
                            .padding(28)
                            .foregroundStyle(.secondary)
                    }
                    .overlay {
                        Circle().stroke(.white, lineWidth: 6)
                    }
                } else {
                    Image(systemName: Constants.SystemImages.emptyPhotoCard)
                        .renderingMode(.original)
                        .resizable()
                        .cornerRadius(cornerRadius)
                }
            }
        }
        .clipShape(
            isCircular
            ? AnyShape(Circle())
            : AnyShape(RoundedRectangle(cornerRadius: cornerRadius))
        )
    }
}


#Preview {
    LandmarkImageView(
        imageData: nil,
        cornerRadius: 10,
        isCircular: false
    )
}
