//
//  LaunchesModel.swift
//  SpaceX MVVM
//
//  Created by Vlad Zavada on 12/11/22.
//

import Foundation

struct LaunchesModel: Codable {
    let name: String?
    let rocket: String
    let dateLocal: Date?
    let success: Bool?
    let id: String
    enum CodingKeys: String, CodingKey {
        case name
        case rocket
        case dateLocal = "date_local"
        case success
        case id
    }
}
