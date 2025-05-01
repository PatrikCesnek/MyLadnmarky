//
//  EditButton.swift
//  Landmarky
//
//  Created by Patrik Cesnek on 21/04/2025.
//

import SwiftUI

struct EditButtonView<Content: View>: View {
    private let destination: () -> Content
    private let showImage: Bool
    
    init(
        @ViewBuilder destination: @escaping () -> Content,
        showImage: Bool
    ) {
        self.destination = destination
        self.showImage = showImage
    }
    
    var body: some View {
        NavigationLink(
            destination: destination,
            label: {
                if showImage {
                    Image(systemName: Constants.SystemImages.editButtonImage)
                        .resizable()
                        .scaledToFit()
                        .shadow(radius: 5)
                } else {
                    Text(Constants.Buttons.edit)
                        .font(.headline)
                }
            }
        )
        .frame(width: 50, height: 50)
        .foregroundStyle(Color.green)
    }
}

#Preview {
    EditButtonView(destination: { Text("A")}, showImage: true)
}
