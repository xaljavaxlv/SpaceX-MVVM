//
//  LaunchesViewModel.swift
//  SpaceX MVVM
//
//  Created by Vlad Zavada on 12/11/22.
//

import Foundation

protocol LaunchesVCViewModelProtocol: AnyObject {
    var launchesForRocket: [LaunchesModel]? { get }
    func getLaunches(launches: [LaunchesModel])
}

extension LaunchesVCViewModel: LaunchesVCViewModelProtocol {
    func getLaunches(launches: [LaunchesModel]) {
        self.allLaunches = launches
    }
}

class LaunchesVCViewModel {
    var dataProvider = LaunchDataProvider()
    weak var viewController: LaunchesVCProtocol!
    var allLaunches: [LaunchesModel]? {
        didSet {
            filterLaunches()
        }
    }
    var rocketName: String!
    var launchesForRocket: [LaunchesModel]? {
        didSet{
            viewController.reload()
        }
    }
    
    required init(viewController: LaunchesVCProtocol, rocketId: String) {
        self.viewController = viewController
        self.rocketName = rocketId
        dataProvider.fetchLaunches { [weak self ] launches in
            guard let self = self else { return }
            self.allLaunches = launches
        }
    }
    func filterLaunches() {
        guard let launches = allLaunches else { return }
        launchesForRocket = launches.filter({ $0.rocket == rocketName })
    }
}
