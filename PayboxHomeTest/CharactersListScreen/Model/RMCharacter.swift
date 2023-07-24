//
//  RMCharacter.swift
//  PayboxHomeTest
//
//  Created by Yadin Gamliel on 23/07/2023.
//

import Foundation

enum IdType {
    case origin(Int)
    case location(Int)
}

struct RMCharacter: Codable {
    let id: Int
    let name, status: String?
    var origin: RMLocation?
    var location: RMLocation?
    let image: String?
}

struct RMLocation: Codable {
    var name: String?
    let url: String?
    var type: String?
    var dimension: String?
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
            ids.append(.origin(originId))
        }
        
        if let locationId = self.location?.IdFromLocation {
            ids.append(.location(locationId))
        }
        
        return ids
    }
}

extension RMLocation {
    var IdFromLocation: Int? {
        
        guard let url = self.url else {
            return nil
        }
        
        if let idRange = url.range(of: "location/[0-9]+", options: .regularExpression),
           let idSubstring = url[idRange].split(separator: "/").last,
           let id = Int(idSubstring) {
            return id
        }
        return nil
    }
}
    

