//
//  MainVCViewModel.swift
//  SpaceX MVVM
//
//  Created by Vlad Zavada on 12/6/22.
//

import UIKit

protocol RocketViewModelProtocol: AnyObject {
    var verticalValues: [StringsRocketModel] { get set }
    var horizontalValues: [StringsRocketModel] { get set }
    var titleRocket: String { get }
    var numberOfItemsForHorizontal: Int { get }
    var numberOfItemsForVertical: Int { get }
    var viewController: RocketVCProtocol! { get set }
    init(rocket: RocketModel)
    func updateHorizontalData()
    func rocketName() -> String
}

extension RocketViewModel: RocketViewModelProtocol {

    func rocketName() -> String {
        guard let rocket = rocket else { return "" }
        return rocket.id
    }
}

// MARK: - Start

final class RocketViewModel {
    public weak var viewController: RocketVCProtocol!
    private let settings = UserSettings.shared
    private var rocket: RocketModel? {
        didSet {
            updateRocketTitle()
            updateHorizontalData()
            updateVerticalData()
            viewController.reload()
        }
    }
    public var verticalValues = [StringsRocketModel]()
    public var horizontalValues = [StringsRocketModel]()
    public var titleRocket = "Loading..."
    public var numberOfItemsForHorizontal: Int { horizontalValues.count }
    public var numberOfItemsForVertical: Int { verticalValues.count }

    required init(rocket: RocketModel) {
        self.rocket = rocket
        updateRocketTitle()
        updateHorizontalData()
        updateVerticalData()
    }

    private func updateRocketTitle() {
        guard let rocket = rocket else { return }
        titleRocket = rocket.name
    }

// MARK: - Horizontal Data

    public func updateHorizontalData() {
        horizontalValues.removeAll()
        for dimension in DimensionsKeys.allCases {
            let measure = settings.getDimensionValue(for: dimension)
            let value = getValue(dimension: dimension, measure: measure)
            let tittle =  "\(dimension.rawValue.capitalized), \(measure)"
            let data = StringsRocketModel(tittle: tittle, value: value, measure: measure)
            horizontalValues.append(data)
        }
    }

    private func getValue(dimension: DimensionsKeys, measure: String) -> String {
        guard let rocket = rocket else { return "n/a"}
        switch dimension {
        case .height:
            if measure == Lenghts.feets.rawValue {
                return "\(String(describing: rocket.height.feet!))"
            } else {
                return "\(String(describing: rocket.height.meters!))"
            }
        case .diameter:
            if measure == Lenghts.feets.rawValue {
                return "\(String(describing: rocket.diameter.feet!))"
            } else {
                return "\(String(describing: rocket.diameter.meters!))"
            }
        case .mass:
            if measure == Weights.pound.rawValue {
                return "\(rocket.mass.lb)"
            } else {
                return "\(rocket.mass.kg)"
            }
        case .payload:
            guard let filtered = rocket.payloadWeights.filter({$0.id == "leo"}).first else { return "n/a"}
            if measure == Weights.pound.rawValue {
                return "\(String(describing: filtered.lb))"
            } else {
                return "\(String(describing: filtered.kg))"
            }
        }
    }

// MARK: - Vertical Data

    private func updateVerticalData() {
        for cell in VerticalCells.allCases {
            var data = StringsRocketModel()
            data.tittle = cell.title
            data.value = getValueForVerticalData(cell: cell)
            data.measure = cell.mesure
            verticalValues.append(data)
        }
    }
// SwiftLint complains : Cyclomatic Complexity Violation: Function should have complexity 10 or less: currently complexity equals 12 (cyclomatic_complexity)

    private func getValueForVerticalData(cell: VerticalCells) -> String {
        guard let rocket = rocket else { return "n/a" }
        switch cell {
        case .firsLaunch: return rocket.firstFlight
        case .country: return rocket.country
        case .launchCost: return String(rocket.costPerLaunch)
        case .firstStageEngines: return String(rocket.firstStage.engines)
        case .firstStageFuelData: return String(rocket.secondStage.fuelAmountTons)
        case .firstStageBurnData:
            var value = "n/a"
            if rocket.firstStage.burnTimeSec != nil {
                value = "\(String(describing: rocket.firstStage.burnTimeSec!))"
            }
            return value
        case .secondStageEngines: return String(rocket.secondStage.engines)
        case .secondStageFuelData: return String(rocket.secondStage.fuelAmountTons)
        case .secondStageBurnData:
            var value = "n/a"
            if rocket.secondStage.burnTimeSec != nil {
                value = "\(String(describing: rocket.secondStage.burnTimeSec!))"
            }
            return value
        }
    }
    // MARK: - Horizontal List Data
//    func prepareHorizontalValues() {
//        horizontalValues.removeAll()
//        addHeightData()
//        addDiameterData()
//        addMassData()
//        addPayloadData()
//    }

//    func addHeightData() {
//        guard let rocket = rocket else { return }
//        var data = StringsModel()
//        data.measure = UserSettings.shared.getHeight()
//        var value: String?
//        if data.measure == Lenghts.feets.rawValue {
//            value = "\(String(describing: rocket.height.feet!))"
//        } else {
//            value = "\(String(describing: rocket.height.meters!))"
//        }
//        var additionalTitle = "n/a"
//        if data.measure != nil {
//            additionalTitle = "\(String(describing: data.measure!))"
//        }
//        data.value = value
//        data.tittle =  "Height, \(additionalTitle)"
//        horizontalValues.append(data)
//    }
//
//    func addDiameterData() {
//        guard let rocket = rocket else { return }
//        var data = StringsModel()
//        data.measure = UserSettings.shared.getDiameter()
//        var value = ""
//        if data.measure == Lenghts.feets.rawValue {
//            value = "\(String(describing: rocket.diameter.feet!))"
//        } else {
//            value = "\(String(describing: rocket.diameter.meters!))"
//        }
//        var additionalTitle = "n/a"
//        if data.measure != nil {
//            additionalTitle = "\(String(describing: data.measure!))"
//        }
//        data.value = value
//        data.tittle =  "Diameter, \(additionalTitle)"
//        horizontalValues.append(data)
//    }
//    func addMassData() {
//        guard let rocket = rocket else { return }
//        var data = StringsModel()
//        data.measure = UserSettings.shared.getMass()
//        var value = ""
//        if data.measure == Weights.lb.rawValue {
//            value = "\(rocket.mass.lb)"
//        } else {
//            value = "\(rocket.mass.kg)"
//        }
//        var additionalTitle = "n/a"
//        if data.measure != nil {
//            additionalTitle = "\(String(describing: data.measure!))"
//        }
//        data.value = value
//        data.tittle =  "Mass, \(additionalTitle)"
//        horizontalValues.append(data)
//    }
//    func addPayloadData() {
//        guard let rocket = rocket else { return }
//        var data = StringsModel()
//        data.measure = UserSettings.shared.getPayload()
//        var value = ""
//        guard let filtered = rocket.payloadWeights.filter ({$0.id == "leo"}).first else { return }
//        if data.measure == Weights.lb.rawValue {
//            value = "\(String(describing: filtered.lb))"
//        } else {
//            value = "\(String(describing: filtered.kg))"
//        }
//        var additionalTitle = "n/a"
//        if data.measure != nil {
//            additionalTitle = "\(String(describing: data.measure!))"
//        }
//        data.value = value
//        data.tittle =  "Payload, \(additionalTitle)"
//        horizontalValues.append(data)
//    }
//

    // MARK: - Vertical List Data
//    func prepareVerticalValues() {
//        verticalValues.removeAll()
//        addFirstLaunchData()
//        addCountryData()
//        addLaunchCostData()
//        addFirstStageEnginesData()
//        addFirstStageFuelData()
//        addFirstStageBurnData()
//        addSecondStageEnginesData()
//        addSecondStageFuelData()
//        addSecondStageBurnData()
//    }
    // MARK: - First Group
//    func addFirstLaunchData() {
//        guard let rocket = rocket else { return }
//        var data = StringsModel()
//        data.tittle = "First Flight"
//        data.value = rocket.firstFlight
//        verticalValues.append(data)
//    }
//    func addCountryData() {
//        guard let rocket = rocket else { return }
//        var data = StringsModel()
//        data.tittle = "Country"
//        data.value = rocket.country
//        verticalValues.append(data)
//    }
//    func addLaunchCostData() {
//        guard let rocket = rocket else { return }
//        var data = StringsModel()
//        data.tittle = "Cost per launch"
//        data.value = String(rocket.costPerLaunch)
//        verticalValues.append(data)
//    }
//
    // MARK: - Second Group
//
//    func addFirstStageEnginesData() {
//        guard let rocket = rocket else { return }
//        var data = StringsModel()
//        data.tittle = "Engines"
//        data.value = String(rocket.firstStage.engines)
//        verticalValues.append(data)
//    }
//    func addFirstStageFuelData() {
//        guard let rocket = rocket else { return }
//        var data = StringsModel()
//        data.tittle = "Fuel Amount"
//        data.value = String(rocket.firstStage.fuelAmountTons)
//        data.measure = "ton"
//        verticalValues.append(data)
//    }
//    func addFirstStageBurnData() {
//        guard let rocket = rocket else { return }
//        var data = StringsModel()
//        data.tittle = "Burn time"
//        var value = "n/a"
//        if (rocket.firstStage.burnTimeSEC != nil) {
//            value = "\(String(describing: rocket.firstStage.burnTimeSEC!))"
//        }
//        data.value = value
//        data.measure = "sec"
//        verticalValues.append(data)
//    }
//
    // MARK: - Third Group
//
//    func addSecondStageEnginesData() {
//        guard let rocket = rocket else { return }
//        var data = StringsModel()
//        data.tittle = "Engines"
//        data.value = String(rocket.secondStage.engines)
//        verticalValues.append(data)
//    }
//    func addSecondStageFuelData() {
//        guard let rocket = rocket else { return }
//        var data = StringsModel()
//        data.tittle = "Fuel Amount"
//        data.value = String(rocket.secondStage.fuelAmountTons)
//        data.measure = "ton"
//        verticalValues.append(data)
//    }
//    func addSecondStageBurnData() {
//        guard let rocket = rocket else { return }
//        var data = StringsModel()
//        data.tittle = "Burn time"
//        var value = "n/a"
//        if (rocket.secondStage.burnTimeSEC != nil) {
//            value = "\(String(describing: rocket.secondStage.burnTimeSEC!))"
//        }
//        data.value = value
//        data.measure = "sec"
//        verticalValues.append(data)
//    }
}

extension RocketViewModel {
    private enum VerticalCells: CaseIterable {
        case firsLaunch
        case country
        case launchCost
        case firstStageEngines
        case firstStageFuelData
        case firstStageBurnData
        case secondStageEngines
        case secondStageFuelData
        case secondStageBurnData

        var title: String {
            switch self {
            case .firsLaunch: return "First Flight"
            case .country: return "Country"
            case .launchCost: return "Cost per launch"
            case .firstStageEngines: return "Engines"
            case .firstStageFuelData: return "Fuel Amount"
            case .firstStageBurnData: return "Burn time"
            case .secondStageEngines: return "Engines"
            case .secondStageFuelData: return "Fuel Amount"
            case .secondStageBurnData: return "Burn time"
            }
        }

        var mesure: String {
            switch self {
            case .firstStageFuelData: return "ton"
            case .firstStageBurnData: return "sec"
            case .secondStageFuelData: return "ton"
            case .secondStageBurnData: return "sec"
            default: return ""
            }
        }
    }
}
