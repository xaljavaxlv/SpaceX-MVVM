//
//  LaunchDataProvider.swift
//  SpaceX MVVM
//
//  Created by Vlad Zavada on 12/11/22.
//

import Foundation

class LaunchDataProvider {
    
    var launches: [LaunchesModel]? {
        didSet{
            guard let launches = launches else { return }
            guard let delegate = delegate else { return }
            delegate.getLaunches(launches: launches)
        }
    }
    var completion = ((([LaunchesModel]) -> ()).self) // все ок???
    weak var delegate: LaunchesVCViewModelProtocol?
    func fetchLaunches(completion: @escaping ([LaunchesModel]) -> ()) {
        let urlLaunchApiString = "https://api.spacexdata.com/v4/launches"
        let urlLaunchApi = URL(string: urlLaunchApiString)!
        let task = URLSession.shared.launchTask(with: urlLaunchApi) { launchModel, response, error in
            if let launchModel = launchModel {
                //Thread.sleep(forTimeInterval: 1) //simulates loading large data
                DispatchQueue.main.async {
                    completion(launchModel)
                }
            }
        }
        task.resume()
    }
}
