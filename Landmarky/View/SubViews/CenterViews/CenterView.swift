//
//  CenterView.swift
//  Landmarky
//
//  Created by Patrik Cesnek on 18/03/2025.
//

import SwiftUI

struct CenterView<Content: View>: View {
    private let centeredView: () -> Content
    
    init(centeredView: @escaping () -> Content) {
        self.centeredView = centeredView
    }
    
    var body: some View {
        VerticalCenterView {
            HorizontalCenterView {
                centeredView()
            }
        }
    }
}

#Preview {
    CenterView(centeredView: { Text(Constants.Buttons.home) })
}
