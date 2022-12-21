//
//  SettingsViewModel.swift
//  SpaceX MVVM
//
//  Created by Vlad Zavada on 12/17/22.
//

import Foundation

protocol SettingsViewModelProtocol {
    var settingsStrings: [SettingsStrings] { get }
    func saveNewSettings(segmentIndex: Int, dimension: DimensionsKeys)
}

final class SettingsViewModel: SettingsViewModelProtocol {

    public var settingsStrings = [SettingsStrings]()

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
            let settingString = SettingsStrings(dimension: dimension,
                                                segmentLeftTitle: titlesLR[0],
                                                segmentRightLabel: titlesLR[1],
                                                segmentIndex: segmentIndex)
            settingsStrings.append(settingString)
        }
    }

    public func saveNewSettings(segmentIndex: Int, dimension: DimensionsKeys) {
        var values = [Lenghts.meters.rawValue, Lenghts.feets.rawValue]
        if dimension == DimensionsKeys.mass || dimension == DimensionsKeys.payload {
            values = [Weights.kilogram.rawValue, Weights.pound.rawValue]
        }
        UserSettings.shared.saveNewDimensionValue(value: values[segmentIndex], dimension: dimension)
    }

//    func updateSegmentIndex(segmentIndex: Int, dimension: DimensionsKeys) {
//        guard let index = settingsStrings.firstIndex(where: {$0.dimension == dimension }) else { return }
//        settingsStrings[index].segmentIndex = segmentIndex
//    }

//
//    func updateLeftLabel() {
//        guard let dimension = dimension else { return }
//        switch dimension {
//        case .height: leftLabel.text = "Height"
//        case .diameter:  leftLabel.text = "Diameter"
//        case .mass:  leftLabel.text = "Mass"
//        case .payload:  leftLabel.text = "Payload"
//        }
//    }
//
//    func updateSegmentControlTitles() {
//        if dimension == .height || dimension == .diameter {
//            segmentControl.setTitle(ftM[0], forSegmentAt: 0)
//            segmentControl.setTitle(ftM[1], forSegmentAt: 1)
//        } else {
//            segmentControl.setTitle(lbKg[0], forSegmentAt: 0)
//            segmentControl.setTitle(lbKg[1], forSegmentAt: 1)
//        }
//        updateSegmentControlPosition()
//    }
//
//    func updateSegmentControlPosition() {
//        guard let dimension = dimension else { return }
//        switch dimension {
//        case .height:
//
//            if UserSettings.shared.getHeight() == Lenghts.feets.rawValue {
//                segmentControl.selectedSegmentIndex = 0
//            } else {
//                segmentControl.selectedSegmentIndex = 1
//            }
//        case .diameter:
//            if UserSettings.shared.getDiameter() == Lenghts.feets.rawValue {
//                segmentControl.selectedSegmentIndex = 0
//            } else {
//                segmentControl.selectedSegmentIndex = 1
//            }
//        case .mass:
//            if UserSettings.shared.getMass() == Weights.lb.rawValue {
//                segmentControl.selectedSegmentIndex = 0
//            } else {
//                segmentControl.selectedSegmentIndex = 1
//            }
//        case .payload:
//            if UserSettings.shared.getPayload() == Weights.lb.rawValue {
//                segmentControl.selectedSegmentIndex = 0
//            } else {
//                segmentControl.selectedSegmentIndex = 1
//            }
//        }
//
//
//    }
//
//    func segmentControlAction() {
//        guard let dimension = dimension else { return }
//        let index = segmentControl.selectedSegmentIndex
//        switch dimension {
//        case .height:
//            if index == 0 {
//                UserSettings.shared.setHeight(new: .feets)
//            } else {
//                UserSettings.shared.setHeight(new: .meters)
//            }
//
//        case .diameter:
//            if index == 0 {
//                UserSettings.shared.setDiameter(new: .feets)
//            } else {
//                UserSettings.shared.setDiameter(new: .meters)
//            }
//        case .mass:
//            if index == 0 {
//                UserSettings.shared.setMass(new: .lb)
//            } else {
//                UserSettings.shared.setMass(new: .kg)
//            }
//        case .payload:
//            if index == 0 {
//                UserSettings.shared.setPayoad(new: .lb)
//            } else {
//                UserSettings.shared.setPayoad(new: .kg)
//            }
//        }
//
//        //        viewController.updateSavedSettings()//.reload()
//    }
//
}
