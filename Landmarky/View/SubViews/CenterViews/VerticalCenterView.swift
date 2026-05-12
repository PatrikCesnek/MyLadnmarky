//
//  VerticalCenterView.swift
//  Landmarky
//
//  Created by Patrik Cesnek on 21/04/2025.
//

import SwiftUI

struct VerticalCenterView<Content: View>: View {
    private let centeredView: () -> Content
    
    init(centeredView: @escaping () -> Content) {
        self.centeredView = centeredView
    }
    
    var body: some View {
        VStack {
            Spacer()
            
            centeredView()
            
            Spacer()
        }
    }
}

#Preview {
    VerticalCenterView(centeredView: { Color.red })
}
