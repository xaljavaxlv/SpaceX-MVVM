//
//  UserSettings.swift
//  SpaceX MVVM
//
//  Created by Vlad Zavada on 12/6/22.
//

import Foundation

public enum Lenghts: String, CaseIterable {
    case meters = "m"
    case feets = "ft"
}

public enum Weights: String {
    case kilogram = "kg"
    case pound = "lb"
}

public enum DimensionsKeys: String, CaseIterable {
    case height, diameter, mass, payload
}

final class UserSettings {

    static let shared = UserSettings()
    private let defaults = UserDefaults.standard
    init() {
        // setInitinalValues()
    }
    private func setInitinalValues() {
        for dimension in DimensionsKeys.allCases {
            var value = Lenghts.meters.rawValue
            if dimension == DimensionsKeys.mass || dimension == DimensionsKeys.payload {
                value = Weights.kilogram.rawValue
            }
            saveNewDimensionValue(value: value, dimension: dimension)
        }
    }

    public func getDimensionValue(for key: DimensionsKeys) -> String { // -> m, ft, kg, lb
        let string = defaults.string(forKey: key.rawValue)
        return string ?? ""
    }

    public func saveNewDimensionValue(value: String, dimension: DimensionsKeys) {
        defaults.set(value, forKey: dimension.rawValue)
    }
    //    func getHeight()  -> String { //Lenghts
    //        let key = DimensionsKeys.height.rawValue
    //        let heightString = UserDefaults.standard.string(forKey: key)
    //        return heightString ?? ""
    //    }
    //    func setHeight(new: Lenghts) {
    //        let heightKey = DimensionsKeys.height.rawValue
    //        let newValue = new.rawValue
    //        let defaults = UserDefaults.standard
    //        defaults.set(newValue, forKey: heightKey)
    //        // updateHeight()
    //    }
    //
    //    func getDiameter() -> String {
    //        let key = DimensionsKeys.diameter.rawValue
    //        let string = UserDefaults.standard.string(forKey: key)
    //        return string ?? ""
    //    }
    //    func setDiameter(new: Lenghts) {
    //        let diameter = DimensionsKeys.diameter.rawValue
    //        let defaults = UserDefaults.standard
    //        defaults.set(new.rawValue, forKey: diameter)
    //        print("diameter - \(new.rawValue)")
    //    }
    //
    //    func getMass() -> String{
    //        let key = DimensionsKeys.mass.rawValue
    //        let string = UserDefaults.standard.string(forKey: key)
    //        return string ?? ""
    //    }
    //    func setMass(new: Weights) {
    //        let mass = DimensionsKeys.mass.rawValue
    //        let defaults = UserDefaults.standard
    //        defaults.set(new.rawValue, forKey: mass)
    //    }
    //    func getPayload() -> String{
    //        let key = DimensionsKeys.payload.rawValue
    //        let string = UserDefaults.standard.string(forKey: key)
    //        return string ?? ""
    //    }
    //    func setPayoad(new: Weights) {
    //        let payload = DimensionsKeys.payload.rawValue
    //        let defaults = UserDefaults.standard
    //        defaults.set(new.rawValue, forKey: payload)
    //    }
}
