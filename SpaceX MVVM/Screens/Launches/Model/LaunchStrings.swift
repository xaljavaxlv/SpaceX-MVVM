//
//  LaunchStrings.swift
//  SpaceX MVVM
//
//  Created by Vlad Zavada on 12/17/22.
//

import Foundation

struct LaunchStrings {

    let name: String
    let date: String
    let imageName: Image

    enum Image: String {
        case rocketdown, rocketup, unknown
    }
}
