//
//  LaunchDataProvider.swift
//  SpaceX MVVM
//
//  Created by Vlad Zavada on 12/24/22.
//

import Foundation
import os

final class LaunchDataProvider {
    private let networkLayer = NetworkLayer()
    private let url = "https://api.spacexdata.com/v4/launches"
    private let logger = Logger()

    func fetchLaunches(completion: @escaping ([LaunchModel]) -> Void) {
        networkLayer.loadData(url: url) { [weak self] (result: Result<[LaunchModel], Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let launches):
                DispatchQueue.main.async {
                    completion(launches)
                }
            case .failure(let error):
                self.logger.log("fetchLaunches have not gotten data with error \(error.localizedDescription)")
            }
        }
    }
}
