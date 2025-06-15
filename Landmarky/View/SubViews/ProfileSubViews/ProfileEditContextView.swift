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
            ProfileCellEditView(text: $firstName)
            ProfileCellEditView(
                text: Binding(
                    get: { lastName ?? "" },
                    set: { lastName = $0.isEmpty ? nil : $0 }
                ),
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
