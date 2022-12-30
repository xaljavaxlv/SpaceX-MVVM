//
//  LaunchesViewModel.swift
//  SpaceX MVVM
//
//  Created by Vlad Zavada on 12/24/22.
//

import Foundation

protocol LaunchViewModelProtocol: AnyObject {
    var launchCellItem: [LaunchCellItem] { get }
    var viewController: LaunchVCProtocol? { get set }
}

final class LaunchViewModel: LaunchViewModelProtocol {

    private let dataProvider = LaunchDataProvider()
    weak var viewController: LaunchVCProtocol?
    private var launches: [LaunchModel]? {
        didSet {
            prepareStrings()
            guard let viewController = viewController else { return }
            viewController.reload()
        }
    }
    let rocketId: String
    var launchCellItem = [LaunchCellItem]()

    init(rocketId: String) {
        self.rocketId = rocketId
        dataProvider.fetchLaunches { [weak self] launches in
            guard let self = self else { return }
            self.launches = launches.filter({ $0.rocket == self.rocketId })
        }
    }

    private func prepareStrings() { // так норм или лучше разбить подготовку каждго стринга на отдельную функцию
        guard let launches = launches else { return  }
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.dateFormat = "d MMM y"

        for launch in launches {
            let date = formatter.string(from: launch.dateLocal)
            var imageName: LaunchCellItem.Image
            switch launch.success {
            case true: imageName = .rocketup
            case false: imageName = .rocketdown
            default: imageName = .unknown
            }
            let launchString = LaunchCellItem(name: launch.name, date: date, imageName: imageName)
            launchCellItem.append(launchString)
        }
    }
}
