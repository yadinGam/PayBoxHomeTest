//
//  CharacterViewModel.swift
//  PayboxHomeTest
//
//  Created by Yadin Gamliel on 24/07/2023.
//

import Foundation

protocol CharacterViewModelProtocol {
    var imageUrl: URL? { get }
    var name: String { get }
    var status: String { get }
    var originName: String { get }
    var originType: String { get }
    var originDimesion: String { get }
    var locationName: String { get }
    var locationType: String { get }
    var locationDimesion: String { get }
}

struct CharacterViewModel: CharacterViewModelProtocol {
    
    var imageUrl: URL?
    var name: String
    var status: String
    var originName: String
    var originType: String
    var originDimesion: String
    var locationName: String
    var locationDimesion: String
    var locationType: String
    
    init(with model: RMCharacter) {
        self.name = model.name ?? ""
        self.imageUrl = URL(string: model.image ?? "")
        self.status = model.status ?? ""
        self.originName = model.origin?.name ?? ""
        self.originType = model.origin?.type ?? ""
        self.originDimesion = model.origin?.dimension ?? ""
        self.locationName = model.location?.name ?? ""
        self.locationType = model.location?.type ?? ""
        self.locationDimesion = model.location?.dimension ?? ""
    }
    
}
