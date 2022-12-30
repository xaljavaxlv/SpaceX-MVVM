//
//  StringsModel.swift
//  SpaceX MVVM
//
//  Created by Vlad Zavada on 12/23/22.
//

import Foundation

struct RocketCellItem: Hashable {
    let id = UUID()
    let title: String
    let value: String
}

enum RocketSectionType: CaseIterable {
    case header, horizontal, vertical, button
}

struct RocketSectionModel: Hashable {
    let id = UUID()
    let type: RocketSectionType
    let title: String?
    let items: [RocketItemType]
}

enum RocketItemType: Hashable {
    case header(title: String, image: URL)
    case horizontal(cellItem: RocketCellItem)
    case vertical(cellItem: RocketCellItem)
    case button
}


