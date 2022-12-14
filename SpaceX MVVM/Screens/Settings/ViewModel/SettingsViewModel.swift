//
//  SettingsViewModel.swift
//  SpaceX MVVM
//
//  Created by Vlad Zavada on 12/24/22.
//

import Foundation

protocol SettingsViewModelProtocol {
    var settingsCellItems: [SettingsCellItem] { get }
    func saveNewSettings(segmentIndex: Int, dimension: DimensionsKeys)
}

final class SettingsViewModel: SettingsViewModelProtocol {

    var settingsCellItems = [SettingsCellItem]()

    init() {
        createSettingsStrings()
    }

    private func createSettingsStrings() {
        let settings = UserSettings.shared
        settingsCellItems = DimensionsKeys.allCases.map { dimension in
            let segmentNames: [String]
            if dimension == DimensionsKeys.mass || dimension == DimensionsKeys.payload {
                segmentNames = [Weights.kilogram.rawValue, Weights.pound.rawValue]
            } else {
                segmentNames = [Lenghts.meters.rawValue, Lenghts.feets.rawValue]
            }
            let segmentIndex = segmentNames.firstIndex(of: settings.getDimensionValue(for: dimension)) ?? 0
            let settingString = SettingsCellItem(dimension: dimension,
                                                 segmentLeftTitle: segmentNames[0],
                                                 segmentRightLabel: segmentNames[1],
                                                 segmentIndex: segmentIndex)
            return settingString
        }
    }

    func saveNewSettings(segmentIndex: Int, dimension: DimensionsKeys) {
        var values = [Lenghts.meters.rawValue, Lenghts.feets.rawValue]
        if dimension == DimensionsKeys.mass || dimension == DimensionsKeys.payload {
            values = [Weights.kilogram.rawValue, Weights.pound.rawValue]
        }
        UserSettings.shared.saveNewDimensionValue(value: values[segmentIndex], dimension: dimension)
    }
}
