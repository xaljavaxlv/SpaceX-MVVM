//
//  LaunchesViewModel.swift
//  SpaceX MVVM
//
//  Created by Vlad Zavada on 12/11/22.
//

import Foundation

protocol LaunchVCViewModelProtocol: AnyObject {
    var launches: [LaunchModel]? { get }
    var launchStrings: [LaunchStrings] { get }
    var viewController: LaunchVCProtocol? { get set }
}

final class LaunchVCViewModel: LaunchVCViewModelProtocol {
    // обязательно final? По умолчанию же сам ставится final под капотом если никто не наследуется

    private let dataProvider = LaunchDataProvider()
    public weak var viewController: LaunchVCProtocol?
    internal var launches: [LaunchModel]? { // private не дает
        didSet {
            prepareStrings()
            guard let viewController = viewController else { return }
            viewController.reload()
        }
    }
    public var rocketName = "Unknown"
    public var launchStrings = [LaunchStrings]()

    required init(rocketName: String) {
        self.rocketName = rocketName
        dataProvider.fetchLaunches { [weak self] launches in
            guard let self = self else { return }
                self.launches = launches.filter({ $0.rocket == self.rocketName })
        }
    }

    private func prepareStrings() { // так норм или лучше разбить подготовку каждго стринга на отдельную функцию?
        guard let launches = launches else { return  }
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.dateFormat = "d MMM y"

        for launch in launches {
            let date = formatter.string(from: launch.dateLocal)
            var imageName: LaunchStrings.Image
            switch launch.success {
            case true: imageName = .rocketup
            case false: imageName = .rocketdown
            default: imageName = .unknown
            }
            let launchString = LaunchStrings(name: launch.name, date: date, imageName: imageName)
            launchStrings.append(launchString)
        }
    }
}
