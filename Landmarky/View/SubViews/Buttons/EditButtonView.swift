//
//  EditButton.swift
//  Landmarky
//
//  Created by Patrik Cesnek on 21/04/2025.
//

import SwiftUI

struct EditButtonView: View {
    private let editAction: () -> Void
    private let showImage: Bool
    
    init(
        editAction: @escaping () -> Void,
        showImage: Bool
    ) {
        self.editAction = editAction
        self.showImage = showImage
    }
    
    var body: some View {
        Button(
            action: { editAction () },
            label: {
                if showImage {
                    Image(systemName: Constants.SystemImages.editButtonImage)
                        .resizable()
                        .scaledToFit()
                        .shadow(radius: 5)
                } else {
                    Text(Constants.Strings.edit)
                        .font(.headline)
                }
            }
        )
        .frame(width: 50, height: 50)
        .foregroundStyle(Color.green)
    }
}

#Preview {
    EditButtonView(
        editAction: {},
        showImage: true
    )
}
