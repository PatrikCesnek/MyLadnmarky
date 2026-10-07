//
//  YearInReviewView.swift
//  Landmarky
//
//  Created by Patrik Cesnek on 07/10/2026.
//

import SwiftUI

/// Story-style look back at one year, ending with a shareable summary.
struct YearInReviewView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel = YearInReviewViewModel()
    @State private var map: WorldMap?
    @State private var page = 0

    var preferredYear: Int?

    var body: some View {
        ZStack(alignment: .top) {
            ShareCardStyle.background.ignoresSafeArea()

            if let review = viewModel.review, !review.isEmpty {
                TabView(selection: $page) {
                    ForEach(Array(pages(for: review).enumerated()), id: \.offset) { index, page in
                        page.tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .always))
                .id(review.year)
            } else {
                StoryPage(
                    eyebrow: Constants.Strings.yearInReview,
                    headline: Constants.Strings.nothingToReview,
                    detail: Constants.Strings.nothingToReviewSubtitle,
                    symbol: "sparkles"
                )
            }

            header
        }
        .foregroundStyle(.white)
        .environment(\.colorScheme, .dark)
        .onAppear {
            viewModel.load(using: modelContext, preferredYear: preferredYear)
        }
        .task {
            map = await Task.detached(priority: .userInitiated) { WorldMap.bundled }.value
        }
        .onChange(of: viewModel.selectedYear) { _, _ in
            page = 0
        }
    }

    private var header: some View {
        HStack {
            if viewModel.availableYears.count > 1 {
                Menu {
                    Picker(Constants.Strings.year, selection: $viewModel.selectedYear) {
                        ForEach(viewModel.availableYears, id: \.self) { year in
                            Text(verbatim: String(year)).tag(Optional(year))
                        }
                    }
                } label: {
                    Label(viewModel.selectedYear.map(String.init) ?? "", systemImage: "calendar")
                        .font(.headline)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(.white.opacity(0.15), in: Capsule())
                }
            }

            Spacer()

            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark")
                    .font(.headline)
                    .padding(10)
                    .background(.white.opacity(0.15), in: Circle())
            }
            .accessibilityLabel(Text(Constants.Buttons.done))
        }
        .padding(.horizontal)
        .padding(.top, 8)
    }

    // MARK: - Pages

    private func pages(for review: YearInReview) -> [AnyView] {
        var pages: [AnyView] = [
            AnyView(StoryPage(
                eyebrow: Constants.Strings.yearInReview,
                headline: Constants.Strings.yourYear(review.year),
                detail: Constants.Strings.yearInReviewIntro,
                symbol: "sparkles"
            ))
        ]

        if review.placeCount > 0 {
            pages.append(AnyView(StoryPage(
                eyebrow: Constants.Strings.placesYouVisited,
                headline: Constants.Strings.placesCount(review.placeCount),
                detail: Constants.Strings.countriesCount(review.countryCodes.count),
                symbol: "mappin.and.ellipse"
            )))
        }

        if !review.countryCodes.isEmpty {
            pages.append(AnyView(StoryPage(
                eyebrow: Constants.Strings.statsCountries,
                headline: Constants.Strings.countriesCount(review.countryCodes.count),
                detail: review.newCountryCodes.isEmpty ? nil : Constants.Strings.newCountriesCount(review.newCountryCodes.count),
                symbol: nil
            ) {
                VStack(spacing: 16) {
                    if let map {
                        WorldMapView(
                            map: map,
                            visitedCodes: Set(review.countryCodes),
                            visitedColor: ShareCardStyle.accent,
                            baseColor: .white.opacity(0.14)
                        )
                    }
                    Text(review.countryCodes.prefix(30).map(CountryCatalog.flag(for:)).joined(separator: " "))
                        .font(.title2)
                        .multilineTextAlignment(.center)
                }
            }))
        }

        if let top = review.topCategory {
            pages.append(AnyView(StoryPage(
                eyebrow: Constants.Strings.favoriteCategory,
                headline: top.category,
                detail: Constants.Strings.placesCount(top.count),
                symbol: HelperFunctions.getCategoryString(top.category),
                symbolColor: HelperFunctions.changeAnnotationColor(categoryName: top.category)
            )))
        }

        if let month = review.busiestMonth {
            pages.append(AnyView(StoryPage(
                eyebrow: Constants.Strings.busiestMonth,
                headline: Calendar.current.standaloneMonthSymbols[month.month - 1].capitalized,
                detail: Constants.Strings.placesCount(month.count),
                symbol: "calendar"
            )))
        }

        if review.tripCount > 0 {
            pages.append(AnyView(StoryPage(
                eyebrow: Constants.Strings.trips,
                headline: Constants.Strings.tripsCount(review.tripCount),
                detail: review.longestTrip.map {
                    "\(Constants.Strings.longestTrip): \($0.title) · \(Constants.Strings.daysCount($0.days))"
                },
                symbol: Constants.SystemImages.book
            )))
        }

        if !review.badges.isEmpty {
            pages.append(AnyView(StoryPage(
                eyebrow: Constants.Strings.badgesEarned,
                headline: Constants.Strings.badgesCount(review.badges.count),
                detail: nil,
                symbol: nil
            ) {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 64), spacing: 12)], spacing: 12) {
                    ForEach(review.badges) { badge in
                        Image(systemName: badge.icon)
                            .font(.title2)
                            .foregroundStyle(.white)
                            .frame(width: 56, height: 56)
                            .background(badge.tier.color, in: Circle())
                            .accessibilityLabel(Text(badge.displayName))
                    }
                }
            }))
        }

        pages.append(AnyView(summaryPage(review)))
        return pages
    }

    private func summaryPage(_ review: YearInReview) -> some View {
        VStack(spacing: 20) {
            Spacer(minLength: 60)

            YearShareCard(review: review, map: map)
                .clipShape(RoundedRectangle(cornerRadius: 24))
                .shadow(color: .black.opacity(0.4), radius: 20)
                .scaleEffect(0.9)

            ShareCardButton(
                title: Constants.Strings.yourYear(review.year),
                contentID: "\(review.year)-\(map != nil)",
                style: .labeled
            ) { () async -> YearShareCard? in
                guard let map else { return nil }
                return YearShareCard(review: review, map: map)
            }
            .prominentButtonStyle()
            .tint(ShareCardStyle.accent)
            .padding(.horizontal, 32)

            Spacer(minLength: 40)
        }
    }
}

/// One full-screen story page: big headline, optional detail, symbol or custom content.
private struct StoryPage<Content: View>: View {
    let eyebrow: String
    let headline: String
    let detail: String?
    let symbol: String?
    var symbolColor: Color = ShareCardStyle.accent
    @ViewBuilder var content: () -> Content

    var body: some View {
        VStack(spacing: 18) {
            Spacer()

            if let symbol {
                Image(systemName: symbol)
                    .font(.system(size: 64, weight: .semibold))
                    .foregroundStyle(symbolColor)
                    .accessibilityHidden(true)
            }

            Text(eyebrow)
                .font(.headline)
                .textCase(.uppercase)
                .tracking(1.5)
                .foregroundStyle(ShareCardStyle.accent)

            Text(headline)
                .font(.system(size: 48, weight: .heavy, design: .rounded))
                .multilineTextAlignment(.center)
                .minimumScaleFactor(0.5)
                .lineLimit(2)

            if let detail {
                Text(detail)
                    .font(.title3)
                    .foregroundStyle(.white.opacity(0.75))
                    .multilineTextAlignment(.center)
            }

            content()
                .padding(.top, 8)

            Spacer()
            Spacer()
        }
        .padding(.horizontal, 28)
        .accessibilityElement(children: .combine)
    }
}

extension StoryPage where Content == SwiftUI.EmptyView {
    init(eyebrow: String, headline: String, detail: String?, symbol: String?, symbolColor: Color = ShareCardStyle.accent) {
        self.init(eyebrow: eyebrow, headline: headline, detail: detail, symbol: symbol, symbolColor: symbolColor) {
            SwiftUI.EmptyView()
        }
    }
}

#Preview {
    YearInReviewView()
        .modelContainer(Mock.previewContainer())
}
