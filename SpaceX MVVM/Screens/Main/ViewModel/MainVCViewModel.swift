//
//  MainVCViewModel.swift
//  SpaceX MVVM
//
//  Created by Vlad Zavada on 12/6/22.
//

import UIKit



protocol MainRocketViewModelProtocol: AnyObject {
    var verticalValues: [StringsModel] { get set }
    var horizontalValues: [StringsModel] { get set }
    var titleRocket: String { get }
    var numberOfItemsForHorizontal: Int { get }
    var numberOfItemsForVertical: Int { get }
    init(viewController: MainRocketVCProtocol, rocket: RocketModel)
    func updateTitles()
    func rocketId() -> String
}

extension MainRocketViewModel: MainRocketViewModelProtocol {
    func rocketId() -> String {
        guard let rocket = rocket else { return "" }
        return rocket.id
    }
    

}

// MARK: - Start

class MainRocketViewModel {
    weak var viewController: MainRocketVCProtocol!
    //var dataProvider: RocketDataProvider!
    var rocket: RocketModel? {
        didSet {
            updateRocketTitle()
            prepareHorizontalValues()
            prepareVerticalValues()
            viewController.reload()
        }
    }

    var verticalValues = [StringsModel]() {
        didSet {
            updateNumbersOfItems()
        }
    }
    var horizontalValues = [StringsModel](){
        didSet {
            updateNumbersOfItems()
        }
    }
    var titleRocket = "Loading..."
    var numberOfItemsForHorizontal = 4 // initial value. updates below
    var numberOfItemsForVertical = 9 // initial value. updates below
    
    required init(viewController: MainRocketVCProtocol, rocket: RocketModel) {
        //super.init()
        self.viewController = viewController
        self.rocket = rocket
        updateRocketTitle()
        prepareHorizontalValues()
        prepareVerticalValues()
    }
    func updateNumbersOfItems() {
        if horizontalValues.count > 0 {
            numberOfItemsForHorizontal = horizontalValues.count
        } else {
            numberOfItemsForHorizontal = 4
        }
        if verticalValues.count > 0 {
            numberOfItemsForVertical = verticalValues.count
        } else {
            numberOfItemsForVertical = 9
        }
    }

    func updateRocketTitle() {
        guard let rocket = rocket else { return }
        titleRocket = rocket.name
    }
    
    //MARK: - Horizontal List Data
    
    func prepareHorizontalValues() {
        horizontalValues.removeAll()
        addHeightData()
        addDiameterData()
        addMassData()
        addPayloadData()
    }
    func addHeightData() {
        guard let rocket = rocket else { return }
        var data = StringsModel()
        data.measure = UserSettings.shared.getHeight()
        var value: String?
        if data.measure == Lenghts.feets.rawValue {
            value = "\(String(describing: rocket.height.feet!))"
        } else {
            value = "\(String(describing: rocket.height.meters!))"
        }
        var additionalTitle = "n/a"
        if data.measure != nil {
            additionalTitle = "\(String(describing: data.measure!))"
        }
        data.value = value
        data.tittle =  "Height, \(additionalTitle)"
        horizontalValues.append(data)
    }
    func addDiameterData() {
        guard let rocket = rocket else { return }
        var data = StringsModel()
        data.measure = UserSettings.shared.getDiameter()
        var value = ""
        if data.measure == Lenghts.feets.rawValue {
            value = "\(String(describing: rocket.diameter.feet!))"
        } else {
            value = "\(String(describing: rocket.diameter.meters!))"
        }
        var additionalTitle = "n/a"
        if data.measure != nil {
            additionalTitle = "\(String(describing: data.measure!))"
        }
        data.value = value
        data.tittle =  "Diameter, \(additionalTitle)"
        horizontalValues.append(data)
    }
    func addMassData() {
        guard let rocket = rocket else { return }
        var data = StringsModel()
        data.measure = UserSettings.shared.getMass()
        var value = ""
        if data.measure == Weights.lb.rawValue {
            value = "\(rocket.mass.lb)"
        } else {
            value = "\(rocket.mass.kg)"
        }
        var additionalTitle = "n/a"
        if data.measure != nil {
            additionalTitle = "\(String(describing: data.measure!))"
        }
        data.value = value
        data.tittle =  "Mass, \(additionalTitle)"
        horizontalValues.append(data)
    }
    func addPayloadData() {
        guard let rocket = rocket else { return }
        var data = StringsModel()
        data.measure = UserSettings.shared.getPayload()
        var value = ""
        guard let filtered = rocket.payloadWeights.filter ({$0.id == "leo"}).first else { return }
        if data.measure == Weights.lb.rawValue {
            value = "\(String(describing: filtered.lb))"
        } else {
            value = "\(String(describing: filtered.kg))"
        }
        var additionalTitle = "n/a"
        if data.measure != nil {
            additionalTitle = "\(String(describing: data.measure!))"
        }
        data.value = value
        data.tittle =  "Payload, \(additionalTitle)"
        horizontalValues.append(data)
    }
    
    func updateTitles() {
        prepareHorizontalValues()
    }
    
    //MARK: - Vertical List Data
    func prepareVerticalValues() {
        verticalValues.removeAll()
        addFirstLaunchData()
        addCountryData()
        addLaunchCostData()
        addFirstStageEnginesData()
        addFirstStageFuelData()
        addFirstStageBurnData()
        addSecondStageEnginesData()
        addSecondStageFuelData()
        addSecondStageBurnData()
    }
    
    //MARK: - First Group
    
    func addFirstLaunchData() {
        guard let rocket = rocket else { return }
        var data = StringsModel()
        data.tittle = "First Flight"
        data.value = rocket.firstFlight
        verticalValues.append(data)
    }
    func addCountryData() {
        guard let rocket = rocket else { return }
        var data = StringsModel()
        data.tittle = "Country"
        data.value = rocket.country
        verticalValues.append(data)
    }
    func addLaunchCostData() {
        guard let rocket = rocket else { return }
        var data = StringsModel()
        data.tittle = "Cost per launch"
        data.value = String(rocket.costPerLaunch)
        verticalValues.append(data)
    }
    
    //MARK: - Second Group
    
    func addFirstStageEnginesData() {
        guard let rocket = rocket else { return }
        var data = StringsModel()
        data.tittle = "Engines"
        data.value = String(rocket.firstStage.engines)
        verticalValues.append(data)
    }
    func addFirstStageFuelData() {
        guard let rocket = rocket else { return }
        var data = StringsModel()
        data.tittle = "Fuel Amount"
        data.value = String(rocket.firstStage.fuelAmountTons)
        data.measure = "ton"
        verticalValues.append(data)
    }
    func addFirstStageBurnData() {
        guard let rocket = rocket else { return }
        var data = StringsModel()
        data.tittle = "Burn time"
        var value = "n/a"
        if (rocket.firstStage.burnTimeSEC != nil) {
            value = "\(String(describing: rocket.firstStage.burnTimeSEC!))"
        }
        data.value = value
        data.measure = "sec"
        verticalValues.append(data)
    }
    
    //MARK: - Third Group
    
    func addSecondStageEnginesData() {
        guard let rocket = rocket else { return }
        var data = StringsModel()
        data.tittle = "Engines"
        data.value = String(rocket.secondStage.engines)
        verticalValues.append(data)
    }
    func addSecondStageFuelData() {
        guard let rocket = rocket else { return }
        var data = StringsModel()
        data.tittle = "Fuel Amount"
        data.value = String(rocket.secondStage.fuelAmountTons)
        data.measure = "ton"
        verticalValues.append(data)
    }
    func addSecondStageBurnData() {
        guard let rocket = rocket else { return }
        var data = StringsModel()
        data.tittle = "Burn time"
        var value = "n/a"
        if (rocket.secondStage.burnTimeSEC != nil) {
            value = "\(String(describing: rocket.secondStage.burnTimeSEC!))"
        }
        data.value = value
        data.measure = "sec"
        verticalValues.append(data)
    }
}

