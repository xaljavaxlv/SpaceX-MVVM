//
//  UserSettings.swift
//  SpaceX MVVM
//
//  Created by Vlad Zavada on 12/6/22.
//

import Foundation

enum Lenghts: String {
    case meters, feets
}

enum Weights: String {
    case kg, lb
}

enum SettingsKeys: String, CaseIterable {
    case height, diameter, mass, payload
}

class UserSettings {
    static let shared = UserSettings.init()
    var height: Lenghts?
    var diameter: Lenghts?
    var mass: Weights?
    var payload: Weights?
    init() {
        // setInitinalValues()
    }
    func setInitinalValues() {
        setHeight(new: .meters)
        setDiameter(new: .feets)
        setMass(new: .lb)
        setPayoad(new: .lb)
    }
    func getHeight()  -> String { //Lenghts
        let key = SettingsKeys.height.rawValue
        let heightString = UserDefaults.standard.string(forKey: key)
        return heightString ?? ""
    }
    func setHeight(new: Lenghts) {
        let heightKey = SettingsKeys.height.rawValue
        let newValue = new.rawValue
        let defaults = UserDefaults.standard
        defaults.set(newValue, forKey: heightKey)
        // updateHeight()
    }

    func getDiameter() -> String {
        let key = SettingsKeys.diameter.rawValue
        let string = UserDefaults.standard.string(forKey: key)
        return string ?? ""
    }
    func setDiameter(new: Lenghts) {
        let diameter = SettingsKeys.diameter.rawValue
        let defaults = UserDefaults.standard
        defaults.set(new.rawValue, forKey: diameter)
        print("diameter - \(new.rawValue)")
    }

    func getMass() -> String{
        let key = SettingsKeys.mass.rawValue
        let string = UserDefaults.standard.string(forKey: key)
        return string ?? ""
    }
    func setMass(new: Weights) {
        let mass = SettingsKeys.mass.rawValue
        let defaults = UserDefaults.standard
        defaults.set(new.rawValue, forKey: mass)
    }
    func getPayload() -> String{
        let key = SettingsKeys.payload.rawValue
        let string = UserDefaults.standard.string(forKey: key)
        return string ?? ""
    }
    func setPayoad(new: Weights) {
        let payload = SettingsKeys.payload.rawValue
        let defaults = UserDefaults.standard
        defaults.set(new.rawValue, forKey: payload)
    }
}


