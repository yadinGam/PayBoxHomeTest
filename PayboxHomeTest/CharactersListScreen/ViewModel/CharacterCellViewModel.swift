//
//  CharacterCellViewModel.swift
//  PayboxHomeTest
//
//  Created by Yadin Gamliel on 24/07/2023.
//

import Foundation

protocol RMCharacterCellViewModelProtocol {
    var name: String { get }
    var status: String { get }
    var imageUrl: URL? { get }
}

class CharacterCellViewModel: RMCharacterCellViewModelProtocol {
    
    let name: String
    let status: String
    let imageUrl: URL?
    
    init(character: RMCharacter) {
        self.name = character.name ?? ""
        self.status = character.status ?? ""
        self.imageUrl = URL(string: character.image ?? "")
    }
    
}
