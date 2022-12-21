//
//  RocketModel.swift
//  SpaceX MVVM
//  https://app.quicktype.io/ https://codebeautify.org/json-decode-online
//  Created by Vlad Zavada on 12/4/22.

import Foundation

// MARK: - RocketElement length
struct RocketModel: Decodable {
    let height, diameter: Length
    let mass: Mass
    let firstStage: FirstStage
    let secondStage: SecondStage
    let payloadWeights: [PayloadWeight]
    let name: String
    let costPerLaunch: Int
    let firstFlight, country, company: String
    let id: String
}

// MARK: - Diameter
struct Length: Codable {
    let meters, feet: Double?
}

// MARK: - FirstStage
struct FirstStage: Decodable {
    let engines: Int
    let fuelAmountTons: Double
    let burnTimeSec: Int?
}

// MARK: - Mass
struct Mass: Decodable {
    let kg, lb: Int
}

// MARK: - PayloadWeight
struct PayloadWeight: Codable {
    let id, name: String
    let kg, lb: Int
}

// MARK: - SecondStage
struct SecondStage: Codable {
    let engines: Int
    let fuelAmountTons: Double
    let burnTimeSec: Int?
}
