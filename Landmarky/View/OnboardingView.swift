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

    @Environment(\.modelContext) private var modelContext
    @State private var page = 0
    @State private var location = LocationPermissionRequester()
    @State private var firstName = ""
    @State private var lastName = ""
    @FocusState private var focusedField: NameField?
    private let pageCount = 5
    private let namePage = 1

    private enum NameField {
        case first
        case last
    }

    private var hasFirstName: Bool {
        !firstName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                if page < pageCount - 1, page != namePage {
                    Button(Constants.Strings.skip) {
                        // Skipping the intro pages still stops at the (required) name.
                        withAnimation { page = hasFirstName || page > namePage ? pageCount - 1 : namePage }
                    }
                    .foregroundStyle(.secondary)
                }
            }
            .frame(height: 44)
            .padding(.horizontal)

            TabView(selection: $page) {
                welcome.tag(0)
                name.tag(namePage)
                features.tag(2)
                privacy.tag(3)
                getStarted.tag(4)
            }
            // Dots would sit on top of the name fields while the keyboard is up.
            .tabViewStyle(.page(indexDisplayMode: focusedField == nil ? .always : .never))
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
                .disabled(page == namePage && !hasFirstName)
                .padding(.horizontal, 24)
                .padding(.bottom, 16)
            }
        }
        .background(Color(.systemBackground))
        .onChange(of: page) { oldPage, newPage in
            // The name is required: swiping forward without one snaps back.
            if oldPage <= namePage, newPage > namePage, !hasFirstName {
                withAnimation { page = namePage }
                focusedField = .first
                return
            }
            if oldPage == namePage {
                focusedField = nil
                saveName()
            } else if newPage == namePage, !hasFirstName {
                focusedField = .first
            }
        }
    }

    /// Saved as soon as the user leaves the name page, so it sticks even if they quit early.
    private func saveName() {
        _ = try? ProfileNameService.save(firstName: firstName, lastName: lastName, in: modelContext)
    }

    // MARK: - Pages

    private var welcome: some View {
        OnboardingPage(
            symbol: Constants.SystemImages.globe,
            title: Constants.Strings.onboardingWelcomeTitle,
            message: Constants.Strings.onboardingWelcomeMessage
        )
    }

    private var name: some View {
        OnboardingPage(
            symbol: focusedField == nil ? Constants.SystemImages.personCircle : nil,
            title: Constants.Strings.onboardingNameTitle,
            message: Constants.Strings.onboardingNameMessage
        ) {
            VStack(spacing: 12) {
                nameField(Constants.Strings.firstName, text: $firstName, field: .first, contentType: .givenName)
                    .submitLabel(.next)
                    .onSubmit { focusedField = .last }

                nameField(Constants.Strings.lastName, text: $lastName, field: .last, contentType: .familyName)
                    .submitLabel(.continue)
                    .onSubmit {
                        guard hasFirstName else { return }
                        withAnimation { page = namePage + 1 }
                    }
            }
        }
    }

    /// Names aren't dictionary words: no autocorrect, no spell check, just capitalized words.
    private func nameField(
        _ prompt: String,
        text: Binding<String>,
        field: NameField,
        contentType: UITextContentType
    ) -> some View {
        TextField(prompt, text: text)
            .textContentType(contentType)
            .autocorrectionDisabled()
            .textInputAutocapitalization(.words)
            .focused($focusedField, equals: field)
            .font(.title3)
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 14))
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
                    saveName()
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
                    saveName()
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
    /// Optional so a page can drop its icon to make room for the keyboard.
    let symbol: String?
    let title: String
    let message: String?
    @ViewBuilder var content: () -> Content

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                if let symbol {
                    Image(systemName: symbol)
                        .font(.system(size: 72, weight: .semibold))
                        .foregroundStyle(.green)
                        .padding(.top, 24)
                        .accessibilityHidden(true)
                }

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
    init(symbol: String?, title: String, message: String?) {
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
        .modelContainer(for: AppSchema.models, inMemory: true)
}
