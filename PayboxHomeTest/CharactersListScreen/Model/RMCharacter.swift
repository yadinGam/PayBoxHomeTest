//
//  RMCharacter.swift
//  PayboxHomeTest
//
//  Created by Yadin Gamliel on 23/07/2023.
//

import Foundation

struct RMCharacter: Codable {
    let id: Int
    let name, status: String?
    let origin: RMLocation?
    let location: RMLocation?
    let image: String?
}

struct RMLocation: Codable {
    let name: String?
    let type: String?
    let dimension: String?
    let url: String?
}

