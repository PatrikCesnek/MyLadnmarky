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
        VStack {
            Spacer()
            
            HStack {
                Spacer()
                
                centeredView()
                
                Spacer()
            }
            
            Spacer()
        }
    }
}

#Preview {
    CenterView(centeredView: { Text("Hello") })
}
