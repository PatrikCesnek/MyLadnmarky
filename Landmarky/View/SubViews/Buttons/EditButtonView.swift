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
                Image(systemName: Constants.SystemImages.editButtonImage)
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(Color.green)
                    .shadow(radius: 5)
            }
        )
        .frame(width: 50, height: 50)
    }
}

#Preview {
    EditButtonView(
        editAction: {},
        showImage: true
    )
}
