//
//  CircleImage.swift
//  Landmarky
//
//  Created by Patrik Cesnek on 14/03/2025.
//

import SwiftUI

struct CircleImage: View {
    private let image: Image
    
    init(image: Image) {
        self.image = image
    }

    var body: some View {
        image
            .resizable()
            .scaledToFit()
            .clipShape(Circle())
            .overlay {
                Circle().stroke(.white, lineWidth: 4)
            }
            .shadow(radius: 7)
    }
}


#Preview {
    CircleImage(image: Image(systemName: "person.circle"))
}
