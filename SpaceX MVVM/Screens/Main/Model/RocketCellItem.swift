//
//  StringsModel.swift
//  SpaceX MVVM
//
//  Created by Vlad Zavada on 12/23/22.
//

import UIKit

struct RocketCellItem: Hashable {
    var id = UUID()
    let title: String
    let value: String
    let measure: String?

}

enum RocketItemType: Hashable {

    case header(title: String, image: URL)
    case info(cellItem: RocketCellItem)
    case button(rocketId: String)

//    var id: Int {
//        switch self {
//        case .header: return 1
//        case .info: return 2
//        case .button: return 3
//        }
//    }

    var rocketId: String {
        switch self {
        case .button(rocketId: let rocketId):
            return rocketId
        default: return ""
        }
    }

//    func hash(into hasher: inout Hasher) {
//      hasher.combine(id)
//    }
//    static func == (lhs: RocketItemType, rhs: RocketItemType) -> Bool {
//        lhs.id == rhs.id
//    }
}

enum RocketSectionType {
    case header
    case horizontal
    case vertical
    case button
}

struct RocketSectionModel: Hashable {

    var id = UUID()
    let type: RocketSectionType
    let title: String?
    let items: [RocketItemType] // optional?

    func hash(into hasher: inout Hasher) {
      hasher.combine(id)
    }

    static func == (lhs: RocketSectionModel, rhs: RocketSectionModel) -> Bool {
        lhs.id == rhs.id
    }
}
