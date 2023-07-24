//
//  RMLocation.swift
//  PayboxHomeTest
//
//  Created by Yadin Gamliel on 25/07/2023.
//

import Foundation

struct RMLocation: Codable {
    var name: String?
    let url: String?
    var type: String?
    var dimension: String?
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
