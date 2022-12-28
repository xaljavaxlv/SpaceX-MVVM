//
//  MainVCViewModel.swift
//  SpaceX MVVM
//
//  Created by Vlad Zavada on 12/23/22.
//

import UIKit

protocol RocketViewModelProtocol: AnyObject {
//    var horizontalValues: [RocketCellItem] { get set }
//    var verticalGeneralValues: [RocketCellItem] { get set }
//    var verticalFirstStageValues: [RocketCellItem] { get set }
//    var verticalSecondStageValues: [RocketCellItem] { get set }
//    var titleRocket: String { get }
    var sections: [RocketSectionModel] { get }
    var viewController: RocketVCProtocol! { get set }
    init(rocket: RocketModel)
 //   func updateHorizontalData() // подумать!!!!!!!!!!!!!!!!!!!!!!!!!
//    func rocketName() -> String
}

extension RocketViewModel: RocketViewModelProtocol {

//    func rocketName() -> String {
//        return rocket.id
//    }
}

final class RocketViewModel {
    weak var viewController: RocketVCProtocol!

    var sections = [RocketSectionModel]()

    private let settings = UserSettings.shared
    private var rocket: RocketModel {
        didSet {
            setSections()
//            updateRocketTitle()
//            updateHorizontalData()
//            updateVerticalGeneralData()
//            updateVerticalFirstStageData()
//            updateVerticalSecondStageData()
            viewController.reload()
        }
    }
//    var horizontalValues = [RocketCellItem]()
//    var verticalGeneralValues = [RocketCellItem]()
//    var verticalFirstStageValues = [RocketCellItem]()
//    var verticalSecondStageValues = [RocketCellItem]()
//    var titleRocket = "Loading..."

//    var numberOfItemsForHorizontal: Int { horizontalValues.count }
//    var numberOfItemsForVertical: Int { verticalValues.count }

    init(rocket: RocketModel) {
        self.rocket = rocket
        setSections()
//        updateRocketTitle()
//        updateHorizontalData()
//        updateVerticalGeneralData()
//        updateVerticalFirstStageData()
//        updateVerticalSecondStageData()
    }
    // MARK: - NEW

    private func setSections() {
        let header = RocketSectionModel(type: .header, title: nil, items: getHeaderItem())
        let horizontal = RocketSectionModel(type: .horizontal, title: nil, items: getHorizontalItems())
        let verticalGeneral = RocketSectionModel(type: .vertical, title: nil, items: getVerticalGeneralItems())
        let verticalStageOne = RocketSectionModel(type: .vertical, title: "Stage One", items: getVerticalFirstStageItems())
        let verticalStageTwo = RocketSectionModel(type: .vertical, title: "Stage Two", items: getVerticalSecondStageItems())
        let button = RocketSectionModel(type: .button, title: nil, items: [.button(rocketId: rocket.id)])
        sections = [
            header,
            horizontal,
            verticalGeneral,
            verticalStageOne,
            verticalStageTwo,
            button
        ]
    }

    // MARK: - Header
// TODO: - допилить картинки
    private func getHeaderItem() -> [RocketItemType] {
        [RocketItemType.header(title: rocket.name, image: URL(string: "https://ssl.gstatic.com/ui/v1/icons/mail/rfr/logo_gmail_lockup_dark_1x_r5.png")!)] // заглушка
    }

    // MARK: - Horizontal items
    private func getHorizontalItems() -> [RocketItemType] {
        var items = [RocketItemType]()
        for dimension in DimensionsKeys.allCases {
            let measure = settings.getDimensionValue(for: dimension)
            let value = getValueForHorizontalItem(dimension: dimension, measure: measure)
            let title =  "\(dimension.rawValue.capitalized), \(measure)"
            let cellItem = RocketCellItem(title: title, value: value, measure: measure)
            let sectionItem = RocketItemType.info(cellItem: cellItem)
            items.append(sectionItem)
        }
        return items
    }

    private func getValueForHorizontalItem(dimension: DimensionsKeys, measure: String) -> String {
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

    // MARK: - Vertical General items
    private func getVerticalGeneralItems() -> [RocketItemType] {
        var items = [RocketItemType]()
        for cell in VerticalCells.General.allCases {
            let title = cell.title
            let value = getValueForVerticalGeneralItem(cell: cell)
            let cellItem = RocketCellItem(title: title, value: value, measure: nil)
            let sectionItem = RocketItemType.info(cellItem: cellItem)
            items.append(sectionItem)
        }
        return items
    }

    private func getValueForVerticalGeneralItem(cell: VerticalCells.General) -> String {
        switch cell {
        case .firsLaunch: return rocket.firstFlight
        case .country: return rocket.country
        case .launchCost: return "$\(rocket.costPerLaunch / 1000000) mil"
        }
    }

    // MARK: - Vertical Stage One items
    private func getVerticalFirstStageItems() -> [RocketItemType] {
        var items = [RocketItemType]()
        for cell in VerticalCells.FirstStage.allCases {
            let title = cell.title
            let value = getValueForVerticalFirstStageItem(cell: cell)
            let measure = cell.measure
            let cellItem = RocketCellItem(title: title, value: value, measure: measure)
            let sectionItem = RocketItemType.info(cellItem: cellItem)
            items.append(sectionItem)
        }
        return items
    }

    private func getValueForVerticalFirstStageItem(cell: VerticalCells.FirstStage) -> String {
        switch cell {
        case .engines: return String(rocket.firstStage.engines)
        case .fuelData: return String(rocket.firstStage.fuelAmountTons)
        case .burnData:
            var value = "n/a"
            if rocket.firstStage.burnTimeSec != nil {
                value = "\(String(describing: rocket.firstStage.burnTimeSec!))"
            }
            return value
        }
    }

    // MARK: - Vertical Stage Two items
    private func getVerticalSecondStageItems() -> [RocketItemType] {
        var items = [RocketItemType]()
        for cell in VerticalCells.SecondStage.allCases {
            let title = cell.title
            let value = getValueForVerticalSecondStageItem(cell: cell)
            let measure = cell.measure
            let cellItem = RocketCellItem(title: title, value: value, measure: measure)
            let sectionItem = RocketItemType.info(cellItem: cellItem)
            items.append(sectionItem)
        }
        return items
    }

    private func getValueForVerticalSecondStageItem(cell: VerticalCells.SecondStage) -> String {
        switch cell {
        case .engines: return String(rocket.secondStage.engines)
        case .fuelData: return String(rocket.secondStage.fuelAmountTons)
        case .burnData:
            var value = "n/a"
            if rocket.secondStage.burnTimeSec != nil {
                value = "\(String(describing: rocket.secondStage.burnTimeSec!))"
            }
            return value
        }
    }

//    // MARK: - OLD
//
//    private func updateRocketTitle() {
//        guard let rocket = rocket else { return }
//        titleRocket = rocket.name
//    }
//
//    // MARK: - Horizontal Data
//
//    func updateHorizontalData() { // старая версия. удалить после новой
//        horizontalValues.removeAll()
//        for dimension in DimensionsKeys.allCases {
//            let measure = settings.getDimensionValue(for: dimension)
//            let value = getValue(dimension: dimension, measure: measure)
//            let tittle =  "\(dimension.rawValue.capitalized), \(measure)"
//            let data = RocketCellItem(tittle: tittle, value: value, measure: measure)
//            horizontalValues.append(data)
//        }
//    }
//
//    private func getValue(dimension: DimensionsKeys, measure: String) -> String {
//        guard let rocket = rocket else { return "n/a"}
//        switch dimension {
//        case .height:
//            if measure == Lenghts.feets.rawValue {
//                return "\(String(describing: rocket.height.feet!))"
//            } else {
//                return "\(String(describing: rocket.height.meters!))"
//            }
//        case .diameter:
//            if measure == Lenghts.feets.rawValue {
//                return "\(String(describing: rocket.diameter.feet!))"
//            } else {
//                return "\(String(describing: rocket.diameter.meters!))"
//            }
//        case .mass:
//            if measure == Weights.pound.rawValue {
//                return "\(rocket.mass.lb)"
//            } else {
//                return "\(rocket.mass.kg)"
//            }
//        case .payload:
//            guard let filtered = rocket.payloadWeights.filter({$0.id == "leo"}).first else { return "n/a"}
//            if measure == Weights.pound.rawValue {
//                return "\(String(describing: filtered.lb))"
//            } else {
//                return "\(String(describing: filtered.kg))"
//            }
//        }
//    }
//
//    // MARK: - Vertical Data
//    // TODO: - переделать логику добавления в массив
////    private func updateVerticalData() {
////        for cell in VerticalCells.allCases {
////            var data = RocketCellItem()
////            data.tittle = cell.title
////            data.value = getValueForVerticalData(cell: cell)
////            data.measure = cell.mesure
////            verticalValues.append(data)
////        }
////    }
//
//    private func updateVerticalGeneralData() {
//
//        for cell in VerticalCells.General.allCases {
//            var data = RocketCellItem()
//            data.tittle = cell.title
//            data.value = getValueForVerticalGeneralData(cell: cell)
//            verticalGeneralValues.append(data)
//        }
//    }
//
//    private func updateVerticalFirstStageData() {
//        for cell in VerticalCells.FirstStage.allCases {
//            var data = RocketCellItem()
//            data.tittle = cell.title
//            data.value = getValueForVerticalFirstStageData(cell: cell)
//            data.measure = cell.mesure
//            verticalFirstStageValues.append(data)
//        }
//    }
//
//    private func updateVerticalSecondStageData() {
//        for cell in VerticalCells.SecondStage.allCases {
//            var data = RocketCellItem()
//            data.tittle = cell.title
//            data.value = getValueForVerticalSecondStageData(cell: cell)
//            data.measure = cell.mesure
//            verticalSecondStageValues.append(data)
//        }
//    }
//
//    private func getValueForVerticalGeneralData(cell: VerticalCells.General) -> String {
//        guard let rocket = rocket else { return "n/a" }
//        switch cell {
//        case .firsLaunch: return rocket.firstFlight
//        case .country: return rocket.country
//        case .launchCost: return "$\(rocket.costPerLaunch / 1000000) mil"
//        }
//    }
//
//    private func getValueForVerticalFirstStageData(cell: VerticalCells.FirstStage) -> String {
//        guard let rocket = rocket else { return "n/a" }
//        switch cell {
//        case .engines: return String(rocket.firstStage.engines)
//        case .fuelData: return String(rocket.firstStage.fuelAmountTons)
//        case .burnData:
//            var value = "n/a"
//            if rocket.firstStage.burnTimeSec != nil {
//                value = "\(String(describing: rocket.firstStage.burnTimeSec!))"
//            }
//            return value
//        }
//    }
//
//    private func getValueForVerticalSecondStageData(cell: VerticalCells.SecondStage) -> String {
//        guard let rocket = rocket else { return "n/a" }
//        switch cell {
//        case .engines: return String(rocket.secondStage.engines)
//        case .fuelData: return String(rocket.secondStage.fuelAmountTons)
//        case .burnData:
//            var value = "n/a"
//            if rocket.secondStage.burnTimeSec != nil {
//                value = "\(String(describing: rocket.secondStage.burnTimeSec!))"
//            }
//            return value
//        }
//    }

//    private func getValueForVerticalGeneralData(cell: VerticalCells.SecondStage) -> String {
//        guard let rocket = rocket else { return "n/a" }
//        switch cell {
//        case .firsLaunch: return rocket.firstFlight
//        case .country: return rocket.country
//        case .launchCost: return String(rocket.costPerLaunch)
//        case .firstStageEngines: return String(rocket.firstStage.engines)
//        case .firstStageFuelData: return String(rocket.secondStage.fuelAmountTons)
//        case .firstStageBurnData:
//            var value = "n/a"
//            if rocket.firstStage.burnTimeSec != nil {
//                value = "\(String(describing: rocket.firstStage.burnTimeSec!))"
//            }
//            return value
//        case .secondStageEngines: return String(rocket.secondStage.engines)
//        case .secondStageFuelData: return String(rocket.secondStage.fuelAmountTons)
//        case .secondStageBurnData:
//            var value = "n/a"
//            if rocket.secondStage.burnTimeSec != nil {
//                value = "\(String(describing: rocket.secondStage.burnTimeSec!))"
//            }
//            return value
//        }
//    }
}

    extension RocketViewModel {

        private enum VerticalCells {

            enum General: CaseIterable {
                case firsLaunch
                case country
                case launchCost

                var title: String {
                    switch self {
                    case .firsLaunch: return "First Flight"
                    case .country: return "Country"
                    case .launchCost: return "Cost per launch"
                    }
                }
            }

            enum FirstStage: CaseIterable {
                case engines
                case fuelData
                case burnData

                var title: String {
                    switch self {
                    case .engines: return "Engines"
                    case .fuelData: return "Fuel Amount"
                    case .burnData: return "Burn time"
                    }
                }

                var measure: String {
                    switch self {
                    case .fuelData: return "ton"
                    case .burnData: return "sec"
                    default: return ""
                    }
                }
            }

            enum SecondStage: CaseIterable {

                case engines
                case fuelData
                case burnData

                var title: String {
                    switch self {
                    case .engines: return "Engines"
                    case .fuelData: return "Fuel Amount"
                    case .burnData: return "Burn time"
                    }
                }

                var measure: String {
                    switch self {
                    case .fuelData: return "ton"
                    case .burnData: return "sec"
                    default: return ""
                    }
                }
            }
            //                            var title: String {
            //                                switch self {
            //                                case .firsLaunch: return "First Flight"
            //                                case .country: return "Country"
            //                                case .launchCost: return "Cost per launch"
            //                                case .firstStageEngines: return "Engines"
            //                                case .firstStageFuelData: return "Fuel Amount"
            //                                case .firstStageBurnData: return "Burn time"
            //                                case .secondStageEngines: return "Engines"
            //                                case .secondStageFuelData: return "Fuel Amount"
            //                                case .secondStageBurnData: return "Burn time"
            //                                }
            //                            }

        }
    }
