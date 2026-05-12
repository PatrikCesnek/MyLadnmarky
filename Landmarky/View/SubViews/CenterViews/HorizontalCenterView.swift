//
//  HorizontalCenterView.swift
//  Landmarky
//
//  Created by Patrik Cesnek on 21/04/2025.
//

import SwiftUI

struct HorizontalCenterView<Content: View>: View {
    private let centeredView: () -> Content
    
    init(centeredView: @escaping () -> Content) {
        self.centeredView = centeredView
    }
    
    var body: some View {
        HStack {
            Spacer()
            
            centeredView()
            
            Spacer()
        }
    }
}

#Preview {
    HorizontalCenterView(centeredView: { Color.red })
}
