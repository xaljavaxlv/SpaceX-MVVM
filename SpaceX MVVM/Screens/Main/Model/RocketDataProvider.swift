//
//  DataSource.swift
//  mvvm first
//
//  Created by Vlad Zavada on 12/23/22.
//

import Foundation
import os

final class RocketDataProvider {

    private let networkLayer = NetworkLayer()
    private let url = "https://api.spacexdata.com/v4/rockets"
    private let logger = Logger()

    func fetchRockets(completion: @escaping ([RocketModel]) -> Void) {
        networkLayer.loadData(url: url) { (result: Result<[RocketModel], Error>) in
            switch result {
            case .success(let rockets):
                DispatchQueue.main.async {
                    completion(rockets)
                }
            case .failure(let error):
                self.logger.log("fetchRockets felt with error \(error.localizedDescription)")
            }
        }
    }
}
