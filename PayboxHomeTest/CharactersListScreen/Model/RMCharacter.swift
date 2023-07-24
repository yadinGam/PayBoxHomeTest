//
//  RMCharacter.swift
//  PayboxHomeTest
//
//  Created by Yadin Gamliel on 23/07/2023.
//

import Foundation

enum IdType {
    case origin
    case location
}

struct RMCharacter: Codable {
    let id: Int
    let name, status: String?
    var origin: RMLocation?
    var location: RMLocation?
    let image: String?
}

extension RMCharacter {
    
    var locationsIdsNumbers: [Int] {
        var ids = [Int]()
        if let originId = self.origin?.IdFromLocation {
            ids.append(originId)
        }
        
        if let locationId = self.location?.IdFromLocation {
            ids.append(locationId)
        }
        
        return ids
    }
    
    var locationsIds: [IdType] {
        var ids = [IdType]()
        if let originId = self.origin?.IdFromLocation {
            ids.append(.origin)
        }
        
        if let locationId = self.location?.IdFromLocation {
            ids.append(.location)
        }
        
        return ids
    }
}



