//
//  LaunchesModel.swift
//  SpaceX MVVM
//
//  Created by Vlad Zavada on 12/24/22.
//

import Foundation

struct LaunchModel: Decodable {
    let name: String
    let rocket: String
    let dateLocal: Date
    let success: Bool?
    let id: String
}
