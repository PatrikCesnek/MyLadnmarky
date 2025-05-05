//
//  ErrorView.swift
//  Landmarky
//
//  Created by Patrik Cesnek on 05/05/2025.
//

import SwiftUI

struct ErrorView: View {
    private let errorString: String
    private let retryAction: () -> Void
    
    init(
        errorString: String,
        retryAction: @escaping () -> Void
    ) {
        self.errorString = errorString
        self.retryAction = retryAction
    }
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: Constants.SystemImages.gearXmark)
                .resizable()
                .frame(width: 80,height: 80)
                .foregroundColor(.red)
                .bold(true)
                .symbolEffect(.rotate)
            
            Text(Constants.Strings.errorTitle)
                .font(.title)
                .multilineTextAlignment(.center)
            
            Text(errorString)
            
            Spacer()
            
            PrimaryButton(
                action: retryAction,
                text: Constants.Buttons.errorRetryButton,
                isError: true
            )
            .tint(.red)
        }
    }
}

#Preview {
    ErrorView(
        errorString: Mock.MockLandmarks.mockError,
        retryAction: {}
    )
}
