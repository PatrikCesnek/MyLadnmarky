//
//  ShareCardButton.swift
//  Landmarky
//
//  Created by Patrik Cesnek on 07/10/2026.
//

import SwiftUI

/// Renders a share card in the background and turns into a system share button once ready.
/// Re-renders whenever `contentID` changes (e.g. the place was edited).
struct ShareCardButton<Card: View, ContentID: Hashable>: View {
    let title: String
    let contentID: ContentID
    var style: Style = .icon
    let makeCard: @MainActor () async -> Card?

    enum Style {
        case icon
        case labeled
    }

    @State private var rendered: RenderedCard?

    var body: some View {
        Group {
            if let rendered {
                ShareLink(
                    item: rendered.card,
                    preview: SharePreview(title, image: Image(uiImage: rendered.image))
                ) {
                    label
                }
            } else {
                Button {} label: { label }
                    .disabled(true)
            }
        }
        .task(id: contentID) {
            rendered = nil
            guard let card = await makeCard(),
                  let result = ShareCardRenderer.render(card, fileName: ShareCardRenderer.fileName(for: title)) else {
                return
            }
            rendered = RenderedCard(image: result.image, card: result.card)
        }
    }

    @ViewBuilder
    private var label: some View {
        switch style {
        case .icon:
            Image(systemName: Constants.SystemImages.share)
                .accessibilityLabel(Text(Constants.Buttons.share))
        case .labeled:
            Label(Constants.Buttons.share, systemImage: Constants.SystemImages.share)
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 6)
        }
    }
}

private struct RenderedCard {
    let image: UIImage
    let card: ShareCardImage
}

#Preview {
    NavigationStack {
        Text(verbatim: "Preview")
            .toolbar {
                ShareCardButton(title: "Jet Setter", contentID: Badge.jetSetter) {
                    BadgeShareCard(badge: .jetSetter)
                }
            }
    }
}
