//
//  ProfileEditContextView.swift
//  Landmarky
//
//  Created by Patrik Cesnek on 15/06/2025.
//

import SwiftUI

struct ProfileEditContextView: View {
    @Binding var firstName: String
    @Binding var lastName: String?

    var body: some View {
        VStack(alignment: .leading) {
            ProfileCellEditView(
                text: $firstName,
                prompt: Constants.Strings.firstName
            )
            ProfileCellEditView(
                text: Binding(
                    get: { lastName ?? "" },
                    set: { lastName = $0.isEmpty ? nil : $0 }
                ),
                prompt: Constants.Strings.lastName,
                showDivider: false
            )
        }
    }
}

#Preview {
    @Previewable @State var firstName = "John"
    @Previewable @State var lastName: String? = "Doe"
    ProfileEditContextView(firstName: $firstName, lastName: $lastName)
}
