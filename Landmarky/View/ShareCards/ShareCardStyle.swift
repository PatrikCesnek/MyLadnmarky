//
//  ShareCardStyle.swift
//  Landmarky
//
//  Created by Patrik Cesnek on 07/10/2026.
//

import SwiftUI

/// Shared look of all share cards: deep green night gradient, white type, brand footer.
enum ShareCardStyle {
    static let accent = Color(hex: "3DDC84")
    static let background = LinearGradient(
        colors: [Color(hex: "0E3B2E"), Color(hex: "08140F")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

struct ShareCardFooter: View {
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: Constants.SystemImages.globe)
                .foregroundStyle(ShareCardStyle.accent)
            Text(verbatim: "Worldwanderer")
                .fontWeight(.semibold)
            Spacer()
        }
        .font(.system(size: 13, design: .rounded))
        .foregroundStyle(.white.opacity(0.85))
    }
}

/// Fills the card with a photo, or a category-colored placeholder when there is none.
struct ShareCardPhoto: View {
    let image: UIImage?
    var fallbackSymbol: String = Constants.SystemImages.photo
    var fallbackColor: Color = ShareCardStyle.accent

    var body: some View {
        if let image {
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
        } else {
            ZStack {
                LinearGradient(
                    colors: [fallbackColor.opacity(0.9), fallbackColor.opacity(0.4)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                Image(systemName: fallbackSymbol)
                    .font(.system(size: 72, weight: .semibold))
                    .foregroundStyle(.white.opacity(0.9))
            }
        }
    }
}
