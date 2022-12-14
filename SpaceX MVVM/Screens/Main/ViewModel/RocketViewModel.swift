//
//  MainVCViewModel.swift
//  SpaceX MVVM
//
//  Created by Vlad Zavada on 12/23/22.
//

import UIKit

protocol RocketViewModelProtocol: AnyObject {
    var currentRocket: (rocketId: String, rocketName: String) { get }
    var sections: [RocketSectionModel] { get }
    var viewController: RocketVCProtocol! { get set }
    func updateCollectionView()
}

extension RocketViewModel: RocketViewModelProtocol {
    func updateCollectionView() {
        setSections()
    }
}

final class RocketViewModel {
    weak var viewController: RocketVCProtocol!
    var sections = [RocketSectionModel]()
    private let settings = UserSettings.shared
    private var rocket: RocketModel
    var currentRocket: (rocketId: String, rocketName: String)

    init(rocket: RocketModel) {
        self.rocket = rocket
        self.currentRocket = (rocketId: rocket.id, rocketName: rocket.name)
        setSections()
    }
    // MARK: - NEW

    private func setSections() {
        let header = RocketSectionModel(type: .header, title: nil, items: getHeaderItem())
        let horizontal = RocketSectionModel(type: .horizontal, title: nil, items: getHorizontalItems())
        let verticalGeneral = RocketSectionModel(type: .vertical, title: nil, items: getVerticalGeneralItems())
        let verticalStageOne = RocketSectionModel(type: .vertical,
                                                  title: "Stage One", items: getVerticalFirstStageItems())
        let verticalStageTwo = RocketSectionModel(type: .vertical,
                                                  title: "Stage Two", items: getVerticalSecondStageItems())
        let button = RocketSectionModel(type: .button, title: nil, items: [.button])
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
    private func getHeaderItem() -> [RocketItemType] {
        [RocketItemType.header(title: rocket.name, image: URL(
            string: "https://ssl.gstatic.com/ui/v1/icons/mail/rfr/logo_gmail_lockup_dark_1x_r5.png")!)] // fix later
    }

    // MARK: - Horizontal items
    private func getHorizontalItems() -> [RocketItemType] {
        DimensionsKeys.allCases.map { dimension in
            let measure = settings.getDimensionValue(for: dimension)
            let value = getValueForHorizontalItem(dimension: dimension, measure: measure)
            let title =  "\(dimension.rawValue.capitalized), \(measure)"
            let cellItem = RocketCellItem(title: title, value: value)
            let sectionItem = RocketItemType.horizontal(cellItem: cellItem)
            return sectionItem
        }
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
        VerticalCells.General.allCases.map { cell in
            let title = cell.title
            let value = getValueForVerticalGeneralItem(cell: cell)
            let cellItem = RocketCellItem(title: title, value: value)
            let sectionItem = RocketItemType.vertical(cellItem: cellItem)
            return sectionItem
        }
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
        VerticalCells.FirstStage.allCases.map { cell in
            let title = cell.title
            let value = getValueForVerticalFirstStageItem(cell: cell)
            let cellItem = RocketCellItem(title: title, value: value)
            let sectionItem = RocketItemType.vertical(cellItem: cellItem)
            return sectionItem
        }
    }

    private func getValueForVerticalFirstStageItem(cell: VerticalCells.FirstStage) -> String {
        switch cell {
        case .engines: return String(rocket.firstStage.engines)
        case .fuelData: return String(rocket.firstStage.fuelAmountTons) + " ton"
        case .burnData:
            var value = "n/a"
            if rocket.firstStage.burnTimeSec != nil {
                value = "\(String(describing: rocket.firstStage.burnTimeSec!)) sec"
            }
            return value
        }
    }

    // MARK: - Vertical Stage Two items
    private func getVerticalSecondStageItems() -> [RocketItemType] {
        VerticalCells.SecondStage.allCases.map { cell in
            let title = cell.title
            let value = getValueForVerticalSecondStageItem(cell: cell)
            let cellItem = RocketCellItem(title: title, value: value)
            let sectionItem = RocketItemType.vertical(cellItem: cellItem)
             return sectionItem
        }
    }

    private func getValueForVerticalSecondStageItem(cell: VerticalCells.SecondStage) -> String {
        switch cell {
        case .engines: return String(rocket.secondStage.engines)
        case .fuelData: return String(rocket.secondStage.fuelAmountTons) + " ton"
        case .burnData:
            var value = "n/a"
            if rocket.secondStage.burnTimeSec != nil {
                value = "\(String(describing: rocket.secondStage.burnTimeSec!)) sec"
            }
            return value
        }
    }
}

extension RocketViewModel {

    private enum VerticalCells {
        // swiftlint:disable:next nesting
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

        // swiftlint:disable:next nesting
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

        // swiftlint:disable:next nesting
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
    }
}
