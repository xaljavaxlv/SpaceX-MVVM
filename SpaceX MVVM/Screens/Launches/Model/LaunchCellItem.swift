//
//  LaunchCellItem.swift
//  SpaceX MVVM
//
//  Created by Vlad Zavada on 12/24/22.
//

import Foundation

struct LaunchCellItem {

    let name: String
    let date: String
    let imageName: Image

    enum Image: String {
        case rocketdown, rocketup, unknown
    }
}
