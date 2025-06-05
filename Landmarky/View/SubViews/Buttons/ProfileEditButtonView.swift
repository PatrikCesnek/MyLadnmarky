//
//  ProfileEditButtonView.swift
//  Landmarky
//
//  Created by Patrik Cesnek on 05/06/2025.
//

import SwiftUI

struct ProfileEditButtonView: View {
    private let isEditing: Bool
    private let editAction: () -> Void
    
    init(
        isEditing: Bool = false,
        editAction: @escaping () -> Void
    ) {
        self.isEditing = isEditing
        self.editAction = editAction
    }
    
    var body: some View {
        Button(
            action: {
                withAnimation {
                    editAction()
                }
            },
            label: {
                Image(
                    systemName:
                        isEditing
                        ? Constants.SystemImages.editSaveButtonImage
                        : Constants.SystemImages.editButtonImage
                )
                .resizable()
                .scaledToFit()
                .shadow(radius: 5)
            }
        )
        .frame(width: 50, height: 50)
        .foregroundStyle(Color.green)
    }
}

#Preview {
    ProfileEditButtonView(editAction: {})
}
