//
//  OnboardingView.swift
//  Landmarky
//
//  Created by Patrik Cesnek on 07/10/2026.
//

import CoreLocation
import SwiftUI

struct OnboardingView: View {
    enum Outcome {
        case explore
        case importPhotos
    }

    let onFinish: (Outcome) -> Void

    @State private var page = 0
    @State private var location = LocationPermissionRequester()
    private let pageCount = 4

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                if page < pageCount - 1 {
                    Button(Constants.Strings.skip) {
                        withAnimation { page = pageCount - 1 }
                    }
                    .foregroundStyle(.secondary)
                }
            }
            .frame(height: 44)
            .padding(.horizontal)

            TabView(selection: $page) {
                welcome.tag(0)
                features.tag(1)
                privacy.tag(2)
                getStarted.tag(3)
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            .indexViewStyle(.page(backgroundDisplayMode: .always))

            if page < pageCount - 1 {
                Button {
                    withAnimation { page += 1 }
                } label: {
                    Text(Constants.Buttons.continueButton)
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 6)
                }
                .prominentButtonStyle()
                .tint(.green)
                .padding(.horizontal, 24)
                .padding(.bottom, 16)
            }
        }
        .background(Color(.systemBackground))
    }

    // MARK: - Pages

    private var welcome: some View {
        OnboardingPage(
            symbol: Constants.SystemImages.globe,
            title: Constants.Strings.onboardingWelcomeTitle,
            message: Constants.Strings.onboardingWelcomeMessage
        )
    }

    private var features: some View {
        OnboardingPage(symbol: "sparkles", title: Constants.Strings.onboardingFeaturesTitle, message: nil) {
            VStack(alignment: .leading, spacing: 20) {
                FeatureRow(symbol: Constants.SystemImages.globe, color: .green, title: Constants.Strings.yourWorld, message: Constants.Strings.onboardingFeatureWorld)
                FeatureRow(symbol: "medal.fill", color: .orange, title: Constants.Strings.statsBadges, message: Constants.Strings.onboardingFeatureBadges(Badge.allCases.count))
                FeatureRow(symbol: Constants.SystemImages.book, color: .blue, title: Constants.Strings.travelDiary, message: Constants.Strings.onboardingFeatureDiary)
                FeatureRow(symbol: Constants.SystemImages.share, color: .purple, title: Constants.Buttons.share, message: Constants.Strings.onboardingFeatureShare)
            }
        }
    }

    private var privacy: some View {
        OnboardingPage(
            symbol: Constants.SystemImages.privacy,
            title: Constants.Strings.onboardingPrivacyTitle,
            message: Constants.Strings.onboardingPrivacyMessage
        )
    }

    private var getStarted: some View {
        OnboardingPage(symbol: "figure.hiking", title: Constants.Strings.onboardingStartTitle, message: Constants.Strings.onboardingStartMessage) {
            VStack(spacing: 12) {
                Button {
                    onFinish(.importPhotos)
                } label: {
                    Label(Constants.Strings.findPlacesInPhotos, systemImage: Constants.SystemImages.photoImport)
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 6)
                }
                .prominentButtonStyle()
                .tint(.green)

                if location.canRequest {
                    Button {
                        location.request()
                    } label: {
                        Label(Constants.Strings.allowLocation, systemImage: "location.fill")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 6)
                    }
                    .buttonStyle(.bordered)
                    .tint(.green)

                    Text(Constants.Strings.allowLocationReason)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }

                Button(Constants.Strings.startExploring) {
                    onFinish(.explore)
                }
                .font(.headline)
                .tint(.green)
                .padding(.top, 8)
            }
        }
    }
}

private struct OnboardingPage<Content: View>: View {
    let symbol: String
    let title: String
    let message: String?
    @ViewBuilder var content: () -> Content

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Image(systemName: symbol)
                    .font(.system(size: 72, weight: .semibold))
                    .foregroundStyle(.green)
                    .padding(.top, 24)
                    .accessibilityHidden(true)

                Text(title)
                    .font(.largeTitle.bold())
                    .multilineTextAlignment(.center)

                if let message {
                    Text(message)
                        .font(.title3)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }

                content()
                    .padding(.top, 8)
            }
            .padding(.horizontal, 28)
            .padding(.bottom, 48)
        }
        .scrollBounceBehavior(.basedOnSize)
    }
}

extension OnboardingPage where Content == SwiftUI.EmptyView {
    init(symbol: String, title: String, message: String?) {
        self.init(symbol: symbol, title: title, message: message) { SwiftUI.EmptyView() }
    }
}

private struct FeatureRow: View {
    let symbol: String
    let color: Color
    let title: String
    let message: String

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Image(systemName: symbol)
                .font(.title2)
                .foregroundStyle(color)
                .frame(width: 36)
                .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.headline)
                Text(message)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .accessibilityElement(children: .combine)
    }
}

/// Asks for when-in-use location and keeps the manager alive until the user answers.
@MainActor
@Observable
final class LocationPermissionRequester: NSObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    private(set) var status: CLAuthorizationStatus

    var canRequest: Bool {
        status == .notDetermined
    }

    override init() {
        status = manager.authorizationStatus
        super.init()
        manager.delegate = self
    }

    func request() {
        manager.requestWhenInUseAuthorization()
    }

    nonisolated func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        Task { @MainActor in
            self.status = status
        }
    }
}

#Preview {
    OnboardingView { _ in }
}
