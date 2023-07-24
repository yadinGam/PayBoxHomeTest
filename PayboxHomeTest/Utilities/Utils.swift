//
//  Utils.swift
//  PayboxHomeTest
//
//  Created by Yadin Gamliel on 23/07/2023.
//

import Foundation

func generateRandomNumbers(by amount: Int, from lowerBound: Int, to upperBound: Int) -> [Int] {
    var randomNumbers = [Int]()
    
    for _ in 0..<amount {
        let randomNumber = Int.random(in: lowerBound...upperBound)
        randomNumbers.append(randomNumber)
    }
    return randomNumbers
}
