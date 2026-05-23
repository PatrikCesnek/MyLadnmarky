import Foundation

struct ContinentMapper {
    static func continent(forCountryCode code: String) -> String {
        let c = code.uppercased()
        if europe.contains(c) { return "Europe" }
        if asia.contains(c) { return "Asia" }
        if africa.contains(c) { return "Africa" }
        if northAmerica.contains(c) { return "North America" }
        if southAmerica.contains(c) { return "South America" }
        if oceania.contains(c) { return "Oceania" }
        return "Unknown"
    }

    private static let europe: Set<String> = [
        "AL", "AD", "AT", "BY", "BE", "BA", "BG", "HR", "CY", "CZ",
        "DK", "EE", "FI", "FR", "DE", "GR", "HU", "IS", "IE", "IT",
        "XK", "LV", "LI", "LT", "LU", "MT", "MD", "MC", "ME", "NL",
        "MK", "NO", "PL", "PT", "RO", "RU", "SM", "RS", "SK", "SI",
        "ES", "SE", "CH", "UA", "GB", "VA"
    ]

    private static let asia: Set<String> = [
        "AF", "AM", "AZ", "BH", "BD", "BT", "BN", "KH", "CN", "GE",
        "IN", "ID", "IR", "IQ", "IL", "JP", "JO", "KZ", "KW", "KG",
        "LA", "LB", "MY", "MV", "MN", "MM", "NP", "KP", "OM", "PK",
        "PS", "PH", "QA", "SA", "SG", "KR", "LK", "SY", "TW", "TJ",
        "TH", "TL", "TR", "TM", "AE", "UZ", "VN", "YE"
    ]

    private static let africa: Set<String> = [
        "DZ", "AO", "BJ", "BW", "BF", "BI", "CV", "CM", "CF", "TD",
        "KM", "CD", "CG", "CI", "DJ", "EG", "GQ", "ER", "SZ", "ET",
        "GA", "GM", "GH", "GN", "GW", "KE", "LS", "LR", "LY", "MG",
        "MW", "ML", "MR", "MU", "MA", "MZ", "NA", "NE", "NG", "RW",
        "ST", "SN", "SC", "SL", "SO", "ZA", "SS", "SD", "TZ", "TG",
        "TN", "UG", "ZM", "ZW"
    ]

    private static let northAmerica: Set<String> = [
        "AG", "BS", "BB", "BZ", "CA", "CR", "CU", "DM", "DO", "SV",
        "GD", "GT", "HT", "HN", "JM", "MX", "NI", "PA", "KN", "LC",
        "VC", "TT", "US"
    ]

    private static let southAmerica: Set<String> = [
        "AR", "BO", "BR", "CL", "CO", "EC", "GY", "PY", "PE", "SR",
        "UY", "VE"
    ]

    private static let oceania: Set<String> = [
        "AU", "FJ", "KI", "MH", "FM", "NR", "NZ", "PW", "PG", "WS",
        "SB", "TO", "TV", "VU"
    ]
}
