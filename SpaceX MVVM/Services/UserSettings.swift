//
//  UserSettings.swift
//  SpaceX MVVM
//
//  Created by Vlad Zavada on 12/24/22.
//

import Foundation

enum Lenghts: String, CaseIterable {
    case meters = "m"
    case feets = "ft"
}

enum Weights: String {
    case kilogram = "kg"
    case pound = "lb"
}

enum DimensionsKeys: String, CaseIterable {
    case height, diameter, mass, payload
}

final class UserSettings {

    static let shared = UserSettings()
    private let defaults = UserDefaults.standard

    func getDimensionValue(for key: DimensionsKeys) -> String { // -> m, ft, kg, lb
        let string = defaults.string(forKey: key.rawValue)
        return string ?? ""
    }

    func saveNewDimensionValue(value: String, dimension: DimensionsKeys) {
        defaults.set(value, forKey: dimension.rawValue)
    }
}
