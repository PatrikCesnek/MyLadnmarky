//
//  HelperFunctions.swift
//  Landmarky
//
//  Created by Patrik Cesnek on 24/03/2025.
//

struct HelperFunctions {
    static func convertToDouble(_ input: String) -> Double {
        guard let convertedText = Double(input) else {
            return 0.0
        }
        
        return convertedText
    }
}
