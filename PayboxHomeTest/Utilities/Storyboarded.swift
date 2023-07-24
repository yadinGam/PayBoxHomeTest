//
//  Storyboarded.swift
//  PayboxHomeTest
//
//  Created by Yadin Gamliel on 24/07/2023.
//

import UIKit

protocol Storyborded {
    static func instantiate() -> Self
}

extension Storyborded where Self: UIViewController  {
    
    static func instantiate() -> Self {
        let id = String (describing: self)
        let storybord = UIStoryboard(name: "Main", bundle: Bundle.main)
        return storybord.instantiateViewController(withIdentifier: id) as! Self
    }
    
}
