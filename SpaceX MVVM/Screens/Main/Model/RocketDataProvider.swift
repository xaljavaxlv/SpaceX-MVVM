//
//  DataSource.swift
//  mvvm first
//
//  Created by Vlad Zavada on 12/4/22.
//

import Foundation

class RocketDataProvider {

    var rockets: [RocketModel]?{
        didSet{
            guard let rockets = rockets else { return }
            self.delegate.getRocketData(rockets: rockets)
        }
    }
   weak var delegate: MainPageVCProtocol!  
    
   init() {
        fetchRockets()
    }
    
    func fetchRockets() {
        let urlRocketApiString = "https://api.spacexdata.com/v4/rockets"
        let urlRocketApi = URL(string: urlRocketApiString)!
        let task = URLSession.shared.rocketTask(with: urlRocketApi) { [weak self] rocketModel, response, error in
            if let rocketModel = rocketModel{
                //Thread.sleep(forTimeInterval: 2) //simulates loading large data
                DispatchQueue.main.async {
                    self!.rockets = rocketModel
                }
            }
        }
        task.resume()
    }
}

