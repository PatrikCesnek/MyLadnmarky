//
//  ProfileCellEditView.swift
//  Landmarky
//
//  Created by Patrik Cesnek on 15/06/2025.
//

import SwiftUI

struct ProfileCellEditView: View {
    @Binding private var text: String
    private let showDivider: Bool

    init(
        text: Binding<String>,
        showDivider: Bool = true
    ) {
        self._text = text
        self.showDivider = showDivider
    }

    var body: some View {
        VStack(alignment: .leading) {
            TextField(Constants.Strings.enterName, text: $text)
            if showDivider {
                Divider()
            }
        }
    }
}

#Preview {
    @Previewable @State var name = "John"
    return ProfileCellEditView(text: $name, showDivider: true)
}
