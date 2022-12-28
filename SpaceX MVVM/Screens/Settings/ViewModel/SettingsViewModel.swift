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
        for dimension in DimensionsKeys.allCases {
            var titlesLR = [Lenghts.meters.rawValue, Lenghts.feets.rawValue]
            if dimension == DimensionsKeys.mass || dimension == DimensionsKeys.payload {
                titlesLR = [Weights.kilogram.rawValue, Weights.pound.rawValue]
            }
            var segmentIndex = 0
            if settings.getDimensionValue(for: dimension) == titlesLR[1] {
                segmentIndex = 1
            }
            let settingString = SettingsCellItem(dimension: dimension,
                                                 segmentLeftTitle: titlesLR[0],
                                                 segmentRightLabel: titlesLR[1],
                                                 segmentIndex: segmentIndex)
            settingsCellItems.append(settingString)
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
