//
//  LaunchDataProvider.swift
//  SpaceX MVVM
//
//  Created by Vlad Zavada on 12/11/22.
//

import Foundation

class LaunchDataProvider {
    private let networkLayer = NetworkLayer()
    
    private func launchTask(with url: URL, completionHandler: @escaping ([LaunchModel]?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        networkLayer.decodableTask(with: url, completionHandler: completionHandler)
    }
    
    public func fetchLaunches(completion: @escaping ([LaunchModel]) -> ()) {
        let urlLaunchApiString = "https://api.spacexdata.com/v4/launches"
        let urlLaunchApi = URL(string: urlLaunchApiString)!
        let task = launchTask(with: urlLaunchApi) { launchModel, response, error in
            print("lsunchmodel - \(launchModel)")
            if let launchModel = launchModel {
                //Thread.sleep(forTimeInterval: 1) //simulates loading large data
                DispatchQueue.main.async {
                    completion(launchModel)
                    print(launchModel)
                }
            } else {
                print("error - \(error)")
            }
        }
        task.resume()
    }
}
