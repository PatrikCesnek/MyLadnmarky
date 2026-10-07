//
//  CountryCatalog.swift
//  Landmarky
//
//  Created by Patrik Cesnek on 07/10/2026.
//

import Foundation

/// Offline country lookups built on the system's region list.
enum CountryCatalog {
    /// UN member and observer states — the denominator for "% of the world".
    static let worldCountryCount = 195

    /// Languages the app ships in, plus the device language. Stored country names come from
    /// the geocoder in whatever language the device used when the place was saved.
    static let lookupLanguages = ["en", "sk", "cs"]

    /// ISO code for a country name in any of the lookup languages, e.g. "Slovensko" → "SK".
    static func code(forCountryName name: String) -> String? {
        nameIndex[normalized(name)]
    }

    static func localizedName(for code: String, locale: Locale = .current) -> String {
        locale.localizedString(forRegionCode: code) ?? code
    }

    static func flag(for code: String) -> String {
        guard code.count == 2, code.allSatisfy(\.isASCII) else { return "🏳️" }
        return code.uppercased().unicodeScalars
            .compactMap { UnicodeScalar(127_397 + $0.value) }
            .map(String.init)
            .joined()
    }

    private static let aliases: [String: String] = [
        "czech republic": "CZ",
        "united states of america": "US",
        "usa": "US",
        "russian federation": "RU",
        "the netherlands": "NL",
        "holland": "NL",
        "turkey": "TR",
        "great britain": "GB",
        "england": "GB",
        "scotland": "GB",
        "wales": "GB",
        "south korea": "KR",
        "north korea": "KP",
        "vatican": "VA",
        "ivory coast": "CI"
    ]

    private static let nameIndex: [String: String] = {
        let regionCodes = Locale.Region.isoRegions
            .map(\.identifier)
            .filter { $0.count == 2 && $0.allSatisfy(\.isLetter) }
        let locales = (lookupLanguages + [Locale.current.identifier]).map(Locale.init(identifier:))

        var index: [String: String] = [:]
        for locale in locales {
            for code in regionCodes {
                guard let name = locale.localizedString(forRegionCode: code) else { continue }
                index[normalized(name)] = index[normalized(name)] ?? code
            }
        }
        for (alias, code) in aliases {
            index[alias] = code
        }
        return index
    }()

    private static func normalized(_ name: String) -> String {
        name.folding(options: [.caseInsensitive, .diacriticInsensitive, .widthInsensitive], locale: nil)
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
