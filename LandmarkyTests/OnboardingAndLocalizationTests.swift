//
//  OnboardingAndLocalizationTests.swift
//  LandmarkyTests
//
//  Created by Patrik Cesnek on 07/10/2026.
//

import Foundation
import SwiftData
import Testing
@testable import Landmarky

@MainActor
struct OnboardingPolicyTests {
    @Test func newInstallSeesOnboardingUntilCompleted() throws {
        let context = try TestSupport.makeContext()
        let policy = OnboardingPolicy(defaults: TestSupport.makeDefaults())

        #expect(policy.shouldShow(in: context))
        #expect(policy.shouldShow(in: context))

        policy.markCompleted()

        #expect(!policy.shouldShow(in: context))
    }

    @Test(arguments: ["landmark", "trip", "profile"])
    func updatingUsersWithDataSkipOnboarding(existing: String) throws {
        let context = try TestSupport.makeContext()
        switch existing {
        case "landmark": context.insert(TestSupport.visitedLandmark("Devín"))
        case "trip": context.insert(Trip(title: "Vienna"))
        default: context.insert(Profile(name: "Patrik"))
        }
        try context.save()
        let defaults = TestSupport.makeDefaults()
        let policy = OnboardingPolicy(defaults: defaults)

        #expect(!policy.shouldShow(in: context))
        #expect(policy.isCompleted)
    }
}

struct LocalizationCoverageTests {
    private static let supportedLanguages = ["sk", "cs"]

    private static func catalog(_ name: String) throws -> [String: [String: Any]] {
        let url = URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .appendingPathComponent("Landmarky/Localization/\(name).xcstrings")
        let data = try Data(contentsOf: url)
        let json = try #require(try JSONSerialization.jsonObject(with: data) as? [String: Any])
        return try #require(json["strings"] as? [String: [String: Any]])
    }

    @Test(arguments: ["Localizable", "InfoPlist"])
    func everyStringIsTranslatedIntoEverySupportedLanguage(catalogName: String) throws {
        var missing: [String] = []

        for (key, entry) in try Self.catalog(catalogName) {
            if key.isEmpty || entry["shouldTranslate"] as? Bool == false { continue }
            let localizations = entry["localizations"] as? [String: Any] ?? [:]
            for language in Self.supportedLanguages where localizations[language] == nil {
                missing.append("\(language): \(key)")
            }
        }

        #expect(missing.isEmpty, "Untranslated: \(missing.sorted())")
    }

    @Test(arguments: ["sk", "cs"])
    func pluralStringsCoverEverySlavicPluralForm(language: String) throws {
        var incomplete: [String] = []

        for (key, entry) in try Self.catalog("Localizable") {
            let localizations = entry["localizations"] as? [String: [String: Any]] ?? [:]
            guard let variations = localizations[language]?["variations"] as? [String: Any],
                  let plural = variations["plural"] as? [String: Any] else { continue }
            if !["one", "few", "other"].allSatisfy({ plural[$0] != nil }) {
                incomplete.append(key)
            }
        }

        #expect(incomplete.isEmpty, "Missing one/few/other in \(language): \(incomplete)")
    }

    @Test(arguments: [("sk", "Váš svet"), ("cs", "Váš svět")])
    func shippedBundleContainsTranslations(language: String, expected: String) throws {
        let path = try #require(Bundle.main.path(forResource: language, ofType: "lproj"))
        let bundle = try #require(Bundle(path: path))

        #expect(bundle.localizedString(forKey: "Your world", value: nil, table: nil) == expected)
        #expect(bundle.localizedString(forKey: "NSPhotoLibraryUsageDescription", value: nil, table: "InfoPlist") != "NSPhotoLibraryUsageDescription")
    }
}
