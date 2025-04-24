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
                    .resizable()
                    .scaledToFill()
            } else {
                if isProfile {
                    Image(systemName: Constants.SystemImages.personCircle)
                        .resizable()
                        .scaledToFit()
                } else {
                    Image(
                        systemName:
                        isCircular
                        ? Constants.SystemImages.emptyPhoto
                        : Constants.SystemImages.empyPhotoCard
                    )
                    .resizable()
                    .scaledToFit()
                    .overlay {
                        if isCircular {
                            Circle().stroke(.white, lineWidth: 4)
                        }
                    }
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
